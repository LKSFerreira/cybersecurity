# Guia de Resolução: Hacker101 CTF - Petshop Pro

Este documento é um guia de estudo completo para o desafio "Petshop Pro". Ele detalha as três vulnerabilidades encontradas, organizadas em uma ordem lógica de descoberta e dificuldade, do fundamental ao mais complexo. O objetivo é explicar não apenas *como* resolver, mas *por que* cada técnica funciona.

---

## Vulnerabilidade 1: Manipulação de Dados do Lado do Cliente (Flag 0)

Esta vulnerabilidade explora a confiança excessiva do servidor nos dados enviados pelo cliente, especificamente em um formulário.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>Algo parece fora do comum no checkout. É sempre bom conseguir coisas de graça.</i></p>
</details>

### 2. Explicação Didática

> Imagine que você está em um supermercado onde você mesmo escaneia os produtos e digita o preço. A etiqueta do leite diz R$ 5,00, mas na hora de pagar, você digita no caixa que o preço é -R$ 100,00. Se o sistema do caixa for ingênuo e não verificar o preço real do produto, ele não só te dará o leite de graça, como também te dará um crédito de R$ 100,00.

**Manipulação de Dados do Lado do Cliente** ocorre quando uma aplicação permite que um usuário modifique dados importantes (como preços, quantidades ou permissões) no seu próprio navegador, e o servidor aceita esses dados modificados sem validá-los novamente.

### 3. Explicação Técnica (Passo a Passo)

1.  **Identificação:** Ao adicionar itens ao carrinho e ir para a página `/cart`, notamos um campo de formulário oculto (`<input type="hidden">`) chamado `cart`. O valor deste campo era uma string JSON contendo todos os detalhes dos itens no carrinho, incluindo o preço.
2.  **Ponto de Entrada (Input):** O valor do campo oculto `cart` enviado via `POST` para o endpoint `/checkout`.
3.  **Falha no Servidor (Server-side):** Ao processar o checkout, o servidor não recalcula o total com base nos preços armazenados no seu próprio banco de dados. Em vez disso, ele confia cegamente nos dados, incluindo os preços, enviados pelo cliente dentro do JSON do carrinho.
    *   Exemplo em pseudo-código (Python/Flask):
      ```python
      # checkout.py
      @app.route('/checkout', methods=['POST'])
      def checkout():
          cart_data = json.loads(request.form.get('cart'))
          total = 0
          # FALHA: O loop usa o preço vindo do cliente.
          for item in cart_data:
              total += item[1]['price'] 
          # CORREÇÃO: Deveria buscar o preço do banco de dados.
          # for item in cart_data:
          #     product = db.get_product(item[0])
          #     total += product.price
          return render_template('checkout.html', total=total)
      ```
4.  **Exploração e Solução:**
    *   Fomos para a página `/cart`.
    *   Usamos as Ferramentas de Desenvolvedor (F12) para editar o HTML do campo oculto `cart`.
    *   Localizamos a propriedade de preço de um item, por exemplo, `"price": 8.95`.
    *   Alteramos o valor para um número negativo, como `"price": -2.0`.
    *   Enviamos o formulário clicando em "Check Out".
    *   A página de checkout calculou um total negativo, e a Flag 0 foi exibida como recompensa pela exploração bem-sucedida.

---

## Vulnerabilidade 2: Credenciais Fracas via Brute-Force (Flag 1)

Esta vulnerabilidade explora a existência de um endpoint administrativo protegido por uma combinação de usuário e senha que pode ser adivinhada através de automação.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>Deve haver uma forma de administrar a aplicação. Ferramentas podem te ajudar a encontrar o ponto de entrada. Ferramentas também são ótimas para encontrar credenciais.</i></p>
</details>

### 2. Explicação Didática

> Você descobre uma porta dos fundos trancada em um prédio (o endpoint `/login`). Você não tem a chave. Em vez de tentar arrombar a fechadura (SQLi), você pega um chaveiro gigante com milhares de chaves comuns (uma wordlist) e testa uma por uma, pacientemente, até que uma delas abra a porta.

**Ataques de Força Bruta (Brute-Force)** contra formulários de login envolvem testar sistematicamente um grande número de nomes de usuário e senhas até que uma combinação correta seja encontrada. É um ataque de volume que depende de automação.

### 3. Explicação Técnica (Passo a Passo)

1.  **Identificação do Endpoint:** Usando uma ferramenta de enumeração de diretórios como `ffuf` (ou a sua própria ferramenta LKS_TOOLS), descobrimos a existência do endpoint `/login`, que não estava linkado em nenhum lugar.
    *   **Comando:** `ffuf -w /caminho/para/wordlist.txt -u https://{challenge_url}/FUZZ`
2.  **Análise do Formulário:** O formulário em `/login` era padrão. Tentativas de bypass com SQL Injection falharam. O servidor implementava **rate limiting** (bloqueio por excesso de tentativas), o que tornava o brute-force manual ou rápido ineficaz.
3.  **Enumeração de Usuários:** Usando uma ferramenta de brute-force configurada para ser lenta e detectar a mensagem de erro "Invalid username", conseguimos identificar um nome de usuário válido: `seline`.
4.  **Brute-Force de Senha:** Com o nome de usuário válido em mãos, lançamos um segundo ataque de força bruta, desta vez testando uma lista de senhas comuns contra o usuário `seline`. Descobrimos que a senha era `angela`.
5.  **Exploração e Solução:**
    *   Fomos para a página `/login`.
    *   Inserimos as credenciais descobertas: `seline` / `angela`.
    *   Após o login bem-sucedido, fomos redirecionados para a página principal, onde a Flag 1 estava visível.

### 4. Ferramentas que Poderiam Ajudar

*   **ffuf / gobuster:** Essenciais para a fase de descoberta de endpoints (passo 1).
*   **Hydra / LKS_TOOLS (sua ferramenta):** Essenciais para a fase de brute-force (passos 3 e 4). A chave para o sucesso foi a capacidade de:
    *   Controlar a velocidade do ataque para evitar o rate limiting (`-t 1` no Hydra ou um número baixo de workers no seu script).
    *   Definir corretamente a condição de falha para distinguir entre um usuário inválido e uma senha inválida.

---

## Vulnerabilidade 3: Cross-Site Scripting (XSS) Armazenado (Flag 2)

Esta vulnerabilidade explora a falha da aplicação em sanitizar a entrada do usuário em um local, que é então renderizada sem segurança em outro.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>Sempre teste cada input. Bugs nem sempre aparecem no lugar onde os dados são inseridos.</i></p>
</details>

### 2. Explicação Didática

> Você escreve um grafite em uma parede de um túnel. Mais tarde, pessoas que saem do outro lado do túnel veem seu grafite exibido em um grande telão. Você inseriu os dados em um lugar (a parede do túnel), mas o "bug" (a exibição do seu grafite) apareceu em outro (o telão).

**XSS Armazenado (Stored XSS)** acontece quando um payload malicioso é salvo no servidor e é servido a outros usuários. A dica nos lembra que o local da injeção e o local da execução podem ser diferentes, o que é a definição de um XSS armazenado.

### 3. Explicação Técnica (Passo a Passo)

1.  **Identificação:** Após logar como administrador, ganhamos acesso à funcionalidade de edição de produtos (`/edit?id=...`). Testamos todos os campos de entrada.
2.  **Análise:**
    *   O campo `name` sanitizava a entrada (convertia `<` para `&lt;`).
    *   O campo `price` esperava um número e quebrava com texto.
    *   O campo `desc` (descrição) **não sanitizava a entrada corretamente**.
3.  **Ponto de Entrada (Input):** O campo `desc` no formulário de edição de produto.
4.  **Ponto de Execução (Output):** A página principal (`/`), onde a descrição dos produtos é exibida.
5.  **Falha no Servidor (Server-side):** O script que processa a edição do produto falha em aplicar a sanitização de HTML ao campo `desc` antes de salvá-lo no banco de dados.
6.  **Exploração e Solução:**
    *   Acessamos a página de edição de um produto (ex: `/edit?id=0`).
    *   No campo `Description`, inserimos um payload de XSS clássico: `<img src=x onerror=alert(1)>`.
    *   Salvamos as alterações.
    *   Navegamos de volta para a página principal (`/`).
    *   O navegador, ao tentar renderizar a descrição do produto, encontrou a tag `<img>`, tentou carregar a fonte inválida `x`, disparou o evento `onerror` e executou o `alert`.
    *   O sistema do CTF, ao detectar a execução bem-sucedida do XSS pelo bot administrador, injetou a Flag 2 na página do carrinho (`/cart`), que era outra página onde o nome do produto era refletido. A solução final foi editar o campo `name` com o payload de XSS e depois visitar a página `/cart`.