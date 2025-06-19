# Guia de Resolução: Hacker101 CTF - Postbook

Este documento é um guia de estudo completo para o desafio "Postbook". Ele detalha as sete vulnerabilidades encontradas, organizadas em uma ordem lógica de descoberta e dificuldade, do fundamental ao mais complexo. O objetivo é explicar não apenas *como* resolver, mas *por que* cada técnica funciona.

---

## Vulnerabilidade 1: Credenciais Fracas (Flag 0)

Esta é a vulnerabilidade mais fundamental e humana. Ela explora a tendência de se utilizar senhas óbvias e fáceis de adivinhar.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>A pessoa com o nome de usuário "user" tem uma senha muito fácil...</i></p>
</details>

### 2. Explicação Didática

> Pense na segurança da sua casa. Você instala uma porta de aço reforçada, mas usa um tapete com "bem-vindo" para esconder a chave. A porta é forte, mas o método para acessá-la é fraco e previsível. Um invasor não precisa arrombar a porta; ele só precisa levantar o tapete.

**Credenciais Fracas** ocorrem quando uma conta é protegida por uma senha que está entre as mais comuns ou que é facilmente associada ao nome de usuário (ex: usuário `bill`, senha `bill123`). É um ataque direto à camada humana da segurança.

### 3. Explicação Técnica (Passo a Passo)

1.  **Identificação:** A dica do CTF nos direcionou explicitamente para o usuário `user` e sua senha "muito fácil". Isso elimina a necessidade de adivinhação e nos diz para focar em um ataque de dicionário ou tentativa manual das senhas mais comuns.
2.  **Ponto de Entrada (Input):** O formulário de login em `index.php?page=sign_in.php`.
3.  **Falha no Servidor (Server-side):** A falha não está no código, mas na política de senhas (ou na falta dela). A aplicação permitiu que o usuário `user` definisse uma senha trivial.
4.  **Exploração e Solução:**
    *   Navegamos para a página de login.
    *   Inserimos `user` no campo de usuário.
    *   Tentamos senhas comuns. A senha `password` funcionou.
    *   Ao fazer login, a Flag 0 foi exibida na página principal, visível apenas para o usuário `user`.

### 4. Ferramentas que Poderiam Ajudar

*   **Hydra / Burp Suite Intruder:** Para um cenário real, ferramentas de brute-force automatizado seriam usadas. Você forneceria uma lista de nomes de usuário e uma lista de senhas comuns (um "dicionário"), e a ferramenta testaria todas as combinações. Para este CTF, a tentativa manual foi suficiente e mais rápida.

---

## Vulnerabilidade 2: Controle de Acesso Quebrado (Flag 1)

Esta vulnerabilidade explora a falha do sistema em restringir o acesso a informações com base no perfil do usuário.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>Tente visualizar seu próprio post e depois veja se consegue alterar o ID.</i></p>
</details>

### 2. Explicação Didática

> Imagine que os perfis dos funcionários de uma empresa são como páginas em um fichário. Qualquer um pode folhear e ver a página de qualquer pessoa. Em uma dessas páginas, a do chefe, há um post-it dizendo "Lembrete secreto: reunião no cofre". O fichário em si não era secreto, mas a informação contida nele, que deveria ser privada, foi exposta.

**Controle de Acesso Quebrado** ocorre quando um usuário pode acessar recursos ou dados que não lhe pertencem, simplesmente porque a aplicação não verifica adequadamente as permissões.

### 3. Explicação Técnica (Passo a Passo)

1.  **Identificação:** Após logar, notamos que a URL do perfil era `...profile.php&id=c`. A dica nos incentivou a trocar o ID. Testando IDs sequenciais (`a`, `b`, `c`...), descobrimos que `id=b` correspondia ao perfil do `admin`.
2.  **Análise:** No perfil do `admin`, encontramos um link para um post chamado "Dear diary..." com `id=2`, que não estava visível na timeline principal. Isso é um **Vazamento de Informação**.
3.  **Ponto de Entrada (Input):** O parâmetro `id` na URL da página de visualização de post: `...view.php&id={id}`.
4.  **Falha no Servidor (Server-side):** A falha ocorreu em duas etapas:
    *   O script `profile.php` não impedia a visualização de perfis de outros usuários.
    *   Mais importante, o script `view.php` não verificava se um post marcado como "privado" estava sendo acessado por seu dono.
5.  **Exploração e Solução:**
    *   Acessamos o perfil do admin com `...profile.php&id=b`.
    *   Clicamos no link do post secreto ou acessamos diretamente a URL:
      ```
      https://{challenge_url}/index.php?page=view.php&id=2
      ```
    *   O servidor nos entregou o conteúdo do post privado, que continha a Flag 1.

---

## Vulnerabilidade 3: Insecure Direct Object Reference (IDOR) em Formulário (Flag 2)

Uma variação do IDOR, onde o parâmetro vulnerável está escondido dentro do formulário da página.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>Você definitivamente deveria usar a função "Inspecionar Elemento" no formulário ao criar um novo post.</i></p>
</details>

### 2. Explicação Didática

> Você preenche um formulário para enviar um pacote, e o atendente cola uma etiqueta de remetente com seu nome. Agora, imagine que essa etiqueta já vem pré-colada no formulário e você pode trocá-la pela etiqueta do seu chefe antes de entregar o formulário. O sistema de correio, ao processar, pensará que o pacote foi enviado pelo seu chefe, não por você.

Esta falha ocorre quando o servidor confia em um dado enviado pelo formulário (especialmente um campo oculto) para identificar o usuário ou o recurso, em vez de usar informações seguras da sessão do usuário.

### 3. Explicação Técnica (Passo a Passo)

1.  **Identificação:** A dica nos mandou inspecionar o formulário de criação de post. Ao fazer isso (F12), encontramos um campo oculto: `<input type="hidden" name="user_id" value="2">`.
2.  **Ponto de Entrada (Input):** O parâmetro `user_id` enviado via `POST` ao criar um post.
3.  **Falha no Servidor (Server-side):** Ao processar a criação do post, o servidor usa o `user_id` vindo do formulário para definir o autor, em vez de usar o ID do usuário autenticado na sessão.
    *   Exemplo em pseudo-código (PHP):
      ```php
      // create.php
      if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // FALHA: Confia no user_id enviado pelo cliente.
        $author_id = $_POST['user_id']; 
        $title = $_POST['title'];
        
        // CORREÇÃO: Deveria usar o ID da sessão.
        // $author_id = $_SESSION['user_id'];
        
        $db->query("INSERT INTO posts (author_id, title) VALUES ($author_id, '$title')");
      }
      ```
4.  **Exploração e Solução:**
    *   Fomos para a página `create.php`.
    *   Usamos as Ferramentas de Desenvolvedor (F12) para alterar o valor do campo oculto de `user_id` de `2` (nosso ID) para `1` (ID do admin).
    *   Preenchemos e enviamos o formulário.
    *   O post foi criado com sucesso como se o autor fosse o `admin`. A Flag 2 foi exibida na mensagem de confirmação.

---

## Vulnerabilidade 4: Insecure Direct Object Reference (IDOR) na URL (Flag 4)

Esta vulnerabilidade explora a confiança cega do servidor em um ID fornecido pelo usuário na URL.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>Você pode editar seus próprios posts, mas e os de outra pessoa?</i></p>
</details>

### 2. Explicação Didática

> Imagine que cada arquivo em um escritório tem um número. Você tem permissão para pedir ao estagiário o arquivo "3", que é seu. Você percebe que pode simplesmente pedir o arquivo "1", que é do seu chefe, e o estagiário o entrega sem questionar quem você é. Ele confia no número que você deu, não na sua identidade.

**IDOR** ocorre quando uma aplicação permite que um usuário acesse um recurso (um objeto) diretamente pelo seu identificador (ID), sem verificar se aquele usuário tem as permissões necessárias para acessá-lo.

### 3. Explicação Técnica (Passo a Passo)

1.  **Identificação:** Após logar como `user`, vimos que podíamos editar nosso próprio post (`id=3`) através da URL `.../edit.php&id=3`. A dica nos incentivou a tentar editar o post de outra pessoa.
2.  **Ponto de Entrada (Input):** O parâmetro `id` na URL da página de edição.
3.  **Falha no Servidor (Server-side):** O script `edit.php` não valida a posse do post. Ele verifica se o usuário está logado, mas não se o ID do post pertence ao ID do usuário logado.
    *   Exemplo em pseudo-código (PHP):
      ```php
      // edit.php
      if (!is_user_logged_in()) {
        die("Você precisa estar logado.");
      }
      
      $post_id = $_GET['id'];
      
      // FALHA: Falta uma verificação crucial aqui.
      // CORREÇÃO: if (get_post_owner($post_id) !== get_current_user_id()) { die("Acesso negado."); }
      
      $post = $db->query("SELECT * FROM posts WHERE id = $post_id");
      show_edit_form($post);
      ```
4.  **Exploração e Solução:**
    *   Logados como `user`, acessamos diretamente a URL para editar o post do `admin` (`id=1`):
      ```
      https://{challenge_url}/index.php?page=edit.php&id=1
      ```
    *   O servidor nos entregou o formulário de edição do post do `admin`. A Flag 4 estava pré-preenchida no conteúdo do post como recompensa.

---

## Vulnerabilidade 5: Manipulação de Cookies / Sessão Fraca (Flag 5)

Este ataque explora a forma insegura como o servidor identifica um usuário através de cookies.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>O cookie permite que você continue logado. Você consegue descobrir como eles funcionam para poder se logar como o usuário de ID 1?</i></p>
</details>

### 2. Explicação Didática

> Seu crachá de acesso ao escritório tem apenas o número "2" escrito nele. Você percebe que pode pegar uma caneta, riscar o "2" e escrever "1" (o número do seu chefe). Se o segurança na porta apenas olhar o número e não a foto ou um código de barras seguro, ele te deixará entrar na sala do chefe.

A sessão de um usuário é mantida por um cookie. Se o valor desse cookie for previsível (como um número de ID ou um hash simples desse número), um atacante pode forjar um cookie válido para outro usuário e se passar por ele.

### 3. Explicação Técnica (Passo a Passo)

1.  **Identificação:** Logados como `user` (ID 2), usamos as Ferramentas de Desenvolvedor para inspecionar os cookies. Encontramos um cookie chamado `id` com o valor `c81e728d9d4c2f636f067f89cc14862c`.
2.  **Análise:** Reconhecemos que essa string de 32 caracteres é um hash MD5. Ao calcular o MD5 da string "2", confirmamos que o valor correspondia. O cookie de sessão era apenas o MD5 do ID do usuário.
3.  **Ponto de Entrada (Input):** O valor do cookie `id` enviado ao servidor em cada requisição.
4.  **Falha no Servidor (Server-side):** O servidor valida a sessão do usuário simplesmente pegando o hash do cookie, revertendo-o (ou comparando com hashes de IDs válidos) para identificar o usuário, em vez de usar um identificador de sessão aleatório, longo e seguro.
5.  **Exploração e Solução:**
    *   Calculamos o MD5 do ID do `admin` ("1"), que é `c4ca4238a0b923820dcc509a6f75849b`.
    *   Usamos uma extensão (ex: Cookie-Editor) para alterar o valor do nosso cookie `id` para o hash do `admin`.
    *   Recarregamos a página. O servidor nos identificou como `admin`, e a Flag 5 apareceu na timeline.

---

## Vulnerabilidade 6: Recurso Previsível com Hash Fraco (Flag 6)

Esta falha ocorre quando um recurso "seguro" é protegido por um método previsível e fraco.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>Deletar um post parece exigir um ID que não é um número. Você consegue descobrir o que é?</i></p>
</details>

### 2. Explicação Didática

> Para deletar um arquivo, o sistema não pede o número do arquivo (ex: "3"), mas sim uma "senha" para ele. Você percebe que a senha para o arquivo "3" é "três", a senha para o "5" é "cinco", e assim por diante. O sistema de segurança parece complexo, mas na verdade segue uma regra simples e previsível que você pode replicar para qualquer arquivo.

A aplicação tenta proteger uma ação crítica (deletar) usando um ID que não é o número sequencial. No entanto, se esse novo ID for gerado de forma previsível (como um hash MD5 do ID original), um atacante pode calcular o ID de qualquer recurso que queira atacar.

### 3. Explicação Técnica (Passo a Passo)

1.  **Identificação:** Ao inspecionar o link de exclusão de um post, notamos que o ID não era um número, mas um hash: `...delete.php&id=eccbc87e4b5ce2fe28308fd9f2a7baf3`.
2.  **Análise:** O post em questão tinha o ID numérico `3`. Calculamos o MD5 de "3" e confirmamos que ele correspondia ao hash no link de exclusão.
3.  **Ponto de Entrada (Input):** O parâmetro `id` na URL da página de exclusão.
4.  **Falha no Servidor (Server-side):** O script `delete.php` espera receber o hash MD5 do ID do post, não o ID numérico. Ele não tem outra camada de segurança.
5.  **Exploração e Solução:**
    *   Decidimos deletar o post `id=1`.
    *   Calculamos o MD5 de "1": `c4ca4238a0b923820dcc509a6f75849b`.
    *   Construímos a URL de exclusão e a acessamos:
      ```
      https://{challenge_url}/index.php?page=delete.php&id=c4ca4238a0b923820dcc509a6f75849b
      ```
    *   O post foi deletado com sucesso, e a Flag 6 foi exibida como confirmação.

---

## Vulnerabilidade 7: Quebra-Cabeça / Enumeração (Flag 3)

Esta flag se desvia das vulnerabilidades web tradicionais e testa a capacidade de resolver um quebra-cabeça e a disposição para automatizar tarefas.

### 1. Dica do Desafio
<details>
  <summary>Clique para revelar a dica</summary>
  <p><i>189 * 5</i></p>
</details>

### 2. Explicação Didática

> Você encontra um bilhete com um enigma: "Para abrir o cofre, multiplique a quantidade de janelas do prédio pelo número do andar da sala de reuniões". Não é uma falha de segurança, mas um quebra-cabeça. Você precisa observar o ambiente, encontrar os números e fazer a conta para obter a combinação.

Às vezes, uma flag não está protegida por uma lógica de permissão, mas simplesmente escondida em um local de difícil acesso, cujo caminho é revelado por um enigma.

### 3. Explicação Técnica (Passo a Passo)

1.  **Identificação:** A dica era um cálculo matemático explícito.
2.  **Análise:** `189 * 5 = 945`. A hipótese imediata é que `945` é o ID de um post oculto.
3.  **Ponto de Entrada (Input):** O parâmetro `id` na URL da página de visualização: `.../view.php&id={id}`.
4.  **Falha no Servidor (Server-side):** Não há uma falha de segurança aqui. O servidor simplesmente possui um recurso (o post 945) que não está linkado em nenhum lugar. O acesso a ele é possível, mas não é óbvio.
5.  **Exploração e Solução:**
    *   Construímos a URL com o ID calculado:
      ```
      https://{challenge_url}/index.php?page=view.php&id=945
      ```
    *   Ao acessar a URL, o conteúdo do post era a Flag 3.

### 4. Ferramentas que Poderiam Ajudar

*   **Como eu descobriria isso sem a dica?** Sua pergunta foi perfeita. A resposta é **automação**. Testar manualmente 10.000 IDs é inviável. Uma ferramenta profissional faria isso em minutos. Os números `189` e `5` provavelmente estavam escondidos em algum lugar nos arquivos estáticos (CSS, JS) como um teste de observação, mas se não fossem encontrados, a enumeração seria o caminho.
*   **Ferramenta Sugerida: Burp Suite Intruder**
    *   **O que é?** Uma ferramenta poderosa para automatizar requisições web customizadas. É o padrão da indústria para esse tipo de teste.
    *   **Como usaríamos aqui:**
        1.  **Capturar:** Usaríamos o Burp Proxy para capturar uma requisição legítima, como `GET /index.php?page=view.php&id=1`.
        2.  **Enviar ao Intruder:** Enviaríamos essa requisição para a ferramenta Intruder.
        3.  **Marcar Posição:** Marcaríamos o número `1` no parâmetro `id=1` como a posição do nosso payload.
        4.  **Definir Payloads:** Na aba de Payloads, escolheríamos o tipo "Numbers" e definiríamos um intervalo, por exemplo, de 1 a 10.000, com um passo de 1.
        5.  **Lançar Ataque:** O Intruder enviaria 10.000 requisições, uma para cada ID.
        6.  **Analisar Resultados:** A chave é olhar para a coluna "Length" (tamanho da resposta). Todas as respostas para IDs inválidos teriam o mesmo tamanho (o da página "Post not found"). A resposta para o ID `945` teria um tamanho **diferente**. Clicaríamos nela para ver a resposta e encontrar a flag. Este processo é chamado de **enumeração de conteúdo** ou **fuzzing**.