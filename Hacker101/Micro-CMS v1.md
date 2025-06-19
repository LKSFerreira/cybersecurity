# Guia de Resolução: Hacker101 CTF - Micro-CMS v1

Este documento serve como um guia de estudo e resolução para o desafio "Micro-CMS v1". Ele detalha as quatro vulnerabilidades presentes, ordenadas da mais simples à mais complexa, explicando a teoria, a técnica e a solução prática.

---

## Vulnerabilidade 1: Controle de Acesso Quebrado

Esta é frequentemente a vulnerabilidade mais simples de encontrar e explorar. Ela se baseia em falhas de lógica do desenvolvedor, em vez de complexidades técnicas.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>Como as páginas são indexadas? O que acontece quando você tenta acessar uma página que não existe, em comparação com uma que você não tem permissão para ver?</i></p>
</details>

### 2. Explicação Didática

> Pense na sua casa. Você tranca a porta da frente (`/page/6`), mas esquece de trancar a porta dos fundos que leva para a sala de estar (`/page/edit/6`). Um invasor que testa todas as portas descobre que, embora não possa entrar pela frente, a porta dos fundos está aberta e dá acesso ao mesmo cômodo.

**Controle de Acesso Quebrado (Broken Access Control)** ocorre quando um sistema não impõe restrições de permissão de forma consistente. Um usuário consegue acessar recursos ou executar ações que deveriam ser proibidas para ele, simplesmente por usar um caminho (endpoint) que o desenvolvedor esqueceu de proteger.

### 3. Explicação Técnica (Passo a Passo)

1.  **Identificação (Enumeração):** O primeiro passo foi enumerar os IDs das páginas na URL (`.../page/{id}`). Ao fazer isso, observamos respostas diferentes do servidor:
    *   `.../page/7` -> **404 Not Found** (A página não existe).
    *   `.../page/6` -> **403 Forbidden** (A página **existe**, mas não temos permissão para vê-la).
    *   A diferença entre 404 (não existe) e 403 (existe, mas é proibido) é a pista crucial. Ela confirma a existência de um recurso protegido.

2.  **Ponto de Entrada (Input):** A própria URL, especificamente o parâmetro de ID: `.../page/{id}` e suas variações, como `.../page/edit/{id}`.

3.  **Falha no Servidor (Server-side):** O desenvolvedor aplicou uma verificação de permissão na rota de visualização, mas não na rota de edição.
    *   Exemplo em pseudo-código (Node.js/Express):
      ```javascript
      // ROTA PROTEGIDA (CORRETAMENTE)
      app.get('/page/:id', function(req, res) {
        const page = db.findPage(req.params.id);
        if (page.isPrivate && page.owner !== req.session.user) {
          return res.status(403).send('Forbidden'); 
        }
        res.render('page', { page });
      });

      // ROTA VULNERÁVEL (ESQUECIDA)
      app.get('/page/edit/:id', function(req, res) {
        const page = db.findPage(req.params.id);
        // FALHA: Verificação de permissão não existe aqui!
        res.render('edit_page', { page });
      });
      ```

4.  **Exploração e Solução:**
    *   Acessamos diretamente a URL de edição da página proibida:
      ```
      https://{challenge_url}/page/edit/6
      ```
    *   Como a rota de edição não tinha a verificação de permissão, o servidor nos entregou o formulário de edição, cujo conteúdo era a própria flag.

### 4. Ferramentas que Poderiam Ajudar

*   **Burp Suite Intruder / OWASP ZAP Fuzzer:** Para um alvo com milhares de páginas, a enumeração manual seria impossível. Ferramentas de fuzzing automatizam o processo. Você capturaria a requisição para `/page/1` e usaria o Intruder para testar rapidamente os IDs de 1 a 10.000, analisando os códigos de status (200, 403, 404) e o tamanho das respostas para identificar páginas interessantes.

---

## Vulnerabilidade 2: Injeção de SQL (SQL Injection)

Esta vulnerabilidade explora a confiança do servidor na entrada do usuário ao construir comandos para o banco de dados.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>Algumas entradas são enviadas para um banco de dados. Caracteres especiais às vezes podem quebrar a linguagem do banco de dados. Você já tentou usar um apóstrofo (')?</i></p>
</details>

### 2. Explicação Didática

> Imagine que você vai a uma biblioteca e preenche uma ficha para pedir um livro, escrevendo o número "6" no campo "ID do Livro". O bibliotecário pega a ficha e busca o livro 6. Agora, imagine que em vez de "6", você escreve: "6, e também me traga a chave da sala do diretor". Se o bibliotecário for um autômato que lê e executa tudo sem questionar, ele pode acabar te entregando a chave.

**SQL Injection** ocorre quando um atacante consegue inserir (`injetar`) comandos SQL maliciosos dentro da consulta que a aplicação faz ao banco de dados. Isso permite ler dados sensíveis, modificar dados e, em alguns casos, tomar controle total do servidor.

### 3. Explicação Técnica (Passo a Passo)

1.  **Identificação:** O teste clássico é usar um apóstrofo (`'`) em parâmetros que parecem ser IDs. O apóstrofo é um caractere especial em SQL que delimita strings. Inserir um a mais geralmente quebra a sintaxe da consulta e causa um erro.
2.  **Análise:** O teste em `/page/1'` falhou (devolveu 404), provavelmente por uma validação na rota que só aceita números. No entanto, o teste em `/page/edit/1'` funcionou, revelando a flag. Isso indica validação de entrada inconsistente entre diferentes endpoints.
3.  **Ponto de Entrada (Input):** O parâmetro de ID na URL de edição: `.../page/edit/{id}`.
4.  **Falha no Servidor (Server-side):** A aplicação pega o ID da URL e o concatena diretamente na string da consulta SQL, sem sanitizá-lo ou usar "prepared statements".
    *   Exemplo em pseudo-código (PHP):
      ```php
      // Código vulnerável
      $page_id = $_GET['id']; // Pega o ID diretamente da URL, ex: "1'"
      $query = "SELECT title, body FROM pages WHERE id = '$page_id'";
      // A query final se torna: SELECT title, body FROM pages WHERE id = '1''
      // O apóstrofo extra quebra a sintaxe do SQL, causando um erro.
      $result = $db->query($query); 
      ```
5.  **Exploração e Solução:**
    *   Acessamos a URL injetando o apóstrofo:
      ```
      https://{challenge_url}/page/edit/1'
      ```
    *   O CTF foi configurado para, ao detectar o erro de sintaxe SQL, entregar a flag em vez de uma mensagem de erro padrão do servidor.

---

## Vulnerabilidade 3: Cross-Site Scripting (XSS) Armazenado

Aqui, o objetivo é fazer com que o navegador de outro usuário execute um código que nós escrevemos.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>A aplicação diz que "scripts não são suportados", mas isso se aplica a todas as formas de executar JavaScript? E quanto aos manipuladores de eventos como 'onerror' ou 'onclick'?</i></p>
</details>

### 2. Explicação Didática

> Pense num quadro de avisos público de uma cafeteria. Você escreve um aviso que diz: "Quem ler isto, grite 'Eu amo café!'". Qualquer pessoa que olhar para o quadro de avisos vai ler sua mensagem e executar a instrução. No mundo web, em vez de um grito, você pode instruir o navegador da vítima a te enviar informações secretas, como os cookies de sessão dela.

**XSS Armazenado (Stored XSS)** acontece quando um payload malicioso (geralmente JavaScript) é salvo no servidor (ex: num comentário, num post de fórum) e é servido a todos os usuários que visualizam aquela página, executando no navegador de cada um deles.

### 3. Explicação Técnica (Passo a Passo)

1.  **Identificação:** O desafio afirmava que "scripts are not supported", indicando que a tag `<script>` seria filtrada. A dica nos direcionou a testar "event handlers".
2.  **Ponto de Entrada (Input):** O `textarea` do corpo da página.
3.  **Bypass do Filtro:** Usamos um payload que não contém a palavra "script", mas que executa JavaScript através de um manipulador de eventos.
    *   **Payload:** `<img src=x onerror="alert(document.cookie)">`
    *   **Lógica:** Forçamos um erro ao tentar carregar uma imagem inválida (`src=x`), o que aciona o evento `onerror` e executa nosso código.
4.  **Falha no Servidor (Server-side):** O backend recebe o payload do `textarea` e o salva no banco de dados sem uma sanitização adequada para remover código executável (ele filtra `<script>`, mas não `onerror`).
5.  **Execução no Cliente e Mecanismo do CTF:**
    *   Quando a página é visualizada, o navegador tenta carregar a imagem, falha, e dispara o evento `onerror`, executando o JavaScript.
    *   **Peculiaridade do CTF:** O bot do desafio detectou o uso de `document.cookie` e, como recompensa, **modificou o payload no servidor**, adicionando um novo atributo `flag="..."` à tag `<img>`.
    *   **Solução:** A flag não estava no `alert` (que mostrava os cookies do nosso próprio navegador), mas sim visível no código-fonte da página (F12), dentro do atributo que o bot injetou para nós.

---

## Vulnerabilidade 4: Injeção de Template no Lado do Servidor (SSTI)

Esta é a vulnerabilidade mais crítica, pois permite a execução de código diretamente no servidor.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>A aplicação processa Markdown, que frequentemente usa um motor de template no servidor. Será que ela processa todas as entradas da mesma forma? O que acontece se você tentar fazê-la realizar um cálculo, como '7*7', usando diferentes sintaxes de template?</i></p>
</details>

### 2. Explicação Didática

> Imagine um sistema de correio que preenche cartas com um template: "Olá, `[nome]`, você ganhou!". Você deveria preencher o campo `[nome]` com "Maria". Mas, em vez disso, você escreve: "`[execute o comando 'apagar todos os arquivos']`". Se o sistema de template for ingênuo, ele pode executar sua instrução em vez de apenas imprimi-la, causando um desastre no servidor.

**Server-Side Template Injection (SSTI)** ocorre quando a entrada do usuário é concatenada e processada diretamente pelo motor de template no servidor, permitindo que o atacante injete comandos que serão executados pelo próprio servidor.

### 3. Explicação Técnica (Passo a Passo)

1.  **Identificação:** A funcionalidade de "Markdown" sugere o uso de um template engine no backend. A dica nos incentivou a testar diferentes sintaxes e em diferentes campos.
2.  **Análise:** Descobrimos que o `textarea` do corpo sanitizava a entrada, mas o `input` do **título** não. Isso ressalta a importância de testar **todos** os campos de entrada.
3.  **Ponto de Entrada (Input):** O campo `input` do título da página.
4.  **Encontrando a Sintaxe:** Testamos vários payloads e descobrimos que `<%= 7*7 %>` era executado pelo servidor, resultando em `49`. Isso aponta para um template engine como EJS (Node.js) ou ERB (Ruby).
5.  **Falha no Servidor (Server-side):** O servidor usa o valor do título para renderizar o template sem sanitizá-lo primeiro.
    *   Exemplo em pseudo-código (Node.js/EJS):
      ```javascript
      // O título vem diretamente da requisição do usuário
      const page_title = req.body.title; // Ex: "<%= 7*7 %>"
      // O corpo é sanitizado, mas o título não!
      const page_body = markdown_sanitizer(req.body.body);
      // FALHA: O título é passado diretamente para o template.
      res.render('template.ejs', { title: page_title, body: page_body });
      ```
6.  **Exploração e Solução (Mecanismo do CTF):**
    *   **Payload:** Inserimos `<%= 7*7 %>` no campo do título e salvamos.
    *   **Mecanismo:** O bot do CTF detectou a exploração bem-sucedida da SSTI e ativou uma regra: na próxima vez que nosso navegador fizesse uma requisição para a página inicial (`/`), o servidor injetaria um script de alerta com a flag na resposta.
    *   **Solução:** Ao clicar em "Go Home", a página inicial foi carregada com o script injetado pelo servidor, e um `alert()` exibiu a flag final.