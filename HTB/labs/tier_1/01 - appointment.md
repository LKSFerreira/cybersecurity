# Guia de Resolução: Hack The Box - Appointment

Este documento é um guia de estudo para o desafio "Appointment". O foco principal desta máquina é a exploração de uma vulnerabilidade de Injeção de SQL (SQL Injection) em uma aplicação web para contornar um formulário de login. O objetivo é explicar não apenas *como* realizar o ataque, mas *por que* ele funciona, detalhando a interação entre a entrada do usuário, a consulta SQL e a lógica da aplicação.

---

## Introdução: Injeção de SQL em Aplicações Web

A Injeção de SQL é uma técnica de ataque que explora falhas de segurança em aplicações que utilizam bancos de dados SQL. Ocorre quando a entrada fornecida pelo usuário não é devidamente sanitizada (validada ou escapada) antes de ser incorporada em uma consulta SQL. Isso permite que um atacante manipule a consulta original, podendo ler dados sensíveis, modificar dados ou até mesmo executar comandos no sistema do banco de dados.

No contexto desta máquina, a vulnerabilidade está presente em um formulário de login. A aplicação constrói dinamicamente uma consulta SQL para verificar as credenciais do usuário, e um atacante pode injetar caracteres especiais (como aspas simples e o símbolo de comentário) para alterar a lógica dessa consulta e obter acesso sem conhecer a senha correta.

---

## Fase 1: Reconhecimento Inicial e Enumeração da Aplicação Web

Antes de explorar a vulnerabilidade, precisamos identificar os serviços em execução no alvo e entender a estrutura básica da aplicação web.

### 1. Explicação Didática

> Imagine que você está se aproximando de um prédio com uma recepção (a página de login). Antes de tentar entrar, você primeiro verifica se o prédio está aberto e qual o seu propósito (identificar o servidor web e sua versão). Depois, você observa a recepção para entender como ela funciona e se há outras portas ou caminhos visíveis (enumeração de diretórios da aplicação web).

### 2. Explicação Técnica (Passo a Passo)

1.  **Enumeração de Portas e Serviços:** Utilizamos o `nmap` para descobrir os serviços ativos.

    *   **Comando:**
        ```bash
        sudo nmap -sC -sV {IP_DO_ALVO}
        ```
    *   **Explicação dos Parâmetros:**
        *   `sudo`: Necessário para executar scripts e detecção de versão que podem exigir privilégios.
        *   `nmap`: A ferramenta de varredura.
        *   `-sC`: Executa um conjunto padrão de scripts de enumeração do `nmap`. Pode fornecer informações adicionais sobre o serviço.
        *   `-sV`: Tenta identificar a versão do serviço em execução nas portas abertas.
        *   `{IP_DO_ALVO}`: O endereço IP da máquina "Appointment".

    *   **Resultado:** O `nmap` identifica a porta `80/tcp` aberta, rodando um servidor web `Apache httpd 2.4.38 ((Debian))`. O título da página é "Login". Isso nos diz que o alvo principal é uma aplicação web acessível via HTTP.

2.  **Análise Inicial da Aplicação Web:** Acessamos o endereço IP do alvo no navegador.

    *   Somos recebidos por uma página de login. Isso confirma o que o `nmap` indicou.
    *   O write-up menciona uma etapa opcional de enumeração de diretórios web usando ferramentas como `gobuster`.
        *   **Comando Exemplo (Gobuster):**
            ```bash
            gobuster dir --url http://{IP_DO_ALVO}/ --wordlist /caminho/para/sua/wordlist.txt
            ```
        *   **Explicação dos Parâmetros:**
            *   `gobuster dir`: Especifica o modo de enumeração de diretórios.
            *   `--url http://{IP_DO_ALVO}/`: A URL base da aplicação web.
            *   `--wordlist /caminho/para/sua/wordlist.txt`: O caminho para um arquivo contendo nomes comuns de diretórios e arquivos (ex: `directory-list-2.3-small.txt` da SecLists).
        *   **Por que fazer isso:** Para descobrir páginas ou diretórios ocultos que não estão diretamente linkados na aplicação. No caso da "Appointment", essa enumeração não revela informações cruciais para a exploração principal, mas é uma boa prática.

---

## Vulnerabilidade 1: Injeção de SQL no Formulário de Login (Foothold)

A principal vulnerabilidade da máquina é uma Injeção de SQL clássica no formulário de login. A aplicação não valida ou sanitiza adequadamente as entradas do usuário antes de usá-las para construir uma consulta SQL.

### 1. Dica do Desafio

<details>
  <summary>Clique para revelar a dica</summary>
  <p>A presença de um formulário de login em uma máquina introdutória focada em web frequentemente aponta para vulnerabilidades de autenticação, como SQL Injection ou credenciais fracas. O write-up detalha explicitamente a natureza da SQL Injection.</p>
</details>

### 2. Explicação Didática

> Imagine que o formulário de login é um pedido que você preenche para entrar em uma sala restrita. O segurança (a aplicação) pega seu nome de usuário e senha e os usa para procurar seu nome em uma lista. Se você escrever no campo do nome de usuário: "Meu nome é 'admin', e ignore o resto deste pedido #", o segurança, se não for cuidadoso, pode procurar apenas por "admin" e ignorar a parte da senha, permitindo sua entrada se "admin" estiver na lista, mesmo sem a senha correta.

### 3. Explicação Técnica (Passo a Passo)

1.  **Análise do Código PHP e da Consulta SQL (Hipotético, conforme o write-up):**
    O write-up apresenta um exemplo de código PHP vulnerável para ilustrar como a injeção funciona. A parte crucial é a construção da consulta SQL:
    ```php
    $username=$_POST['username'];
    $password=$_POST['password'];
    $sql="SELECT * FROM users WHERE username='$username' AND password='$password'";
    // ... restante da lógica de verificação
    ```
    Nesta consulta:
    *   `$username` e `$password` são diretamente concatenados na string SQL.
    *   A aplicação espera que `$username` e `$password` sejam simples strings.

2.  **Construção do Payload de Injeção de SQL:**
    O objetivo é fazer com que a consulta seja verdadeira para um usuário conhecido (como `admin`) sem precisar saber a senha. Usamos um payload que manipula a estrutura da consulta SQL.

    *   **Campo Username:**
        ```
        admin'#
        ```
    *   **Campo Password:** Pode ser qualquer coisa (ex: `abc123` ou deixado em branco, dependendo da lógica exata da aplicação, mas no exemplo do write-up, ele se torna irrelevante).

3.  **Como o Payload Afeta a Consulta:**
    Quando o payload `admin'#` é inserido no campo `username`, a consulta SQL se torna:
    ```sql
    SELECT * FROM users WHERE username='admin'#' AND password='qualquercoisa'
    ```
    *   `admin'`: A primeira aspa simples (`'`) fecha a string esperada para `username`. A string `admin` é o nome de usuário que estamos tentando personificar.
    *   `#`: No MySQL (e em muitas outras variantes de SQL), o símbolo `#` inicia um comentário. Tudo que vier depois dele na mesma linha é ignorado pelo interpretador SQL.
    *   **Efeito:** A parte `AND password='qualquercoisa'` da consulta original é comentada. A consulta efetivamente executada pelo banco de dados torna-se:
        ```sql
        SELECT * FROM users WHERE username='admin'
        ```

4.  **Lógica da Aplicação Pós-Injeção:**
    A aplicação PHP (conforme o exemplo do write-up) provavelmente verifica se a consulta SQL retornou exatamente uma linha (`if ($count==1)`).
    *   Se existir um usuário chamado `admin` na tabela `users`, a consulta `SELECT * FROM users WHERE username='admin'` retornará uma linha.
    *   A condição `$count==1` será verdadeira.
    *   A aplicação então prossegue como se o login fosse bem-sucedido, criando uma sessão para o usuário `admin` e redirecionando para a página principal ou painel.

5.  **Execução do Ataque:**
    *   Navegue até a página de login da aplicação (`http://{IP_DO_ALVO}/`).
    *   No campo "Username", insira: `admin'#`
    *   No campo "Password", insira qualquer valor (ex: `abc123`).
    *   Clique no botão "Login".

6.  **Resultado e Captura da Flag:**
    Se a injeção for bem-sucedida e um usuário `admin` existir, a aplicação irá logá-lo. Na máquina "Appointment", após o login bem-sucedido via SQL Injection, a página carregada exibe a mensagem "Congratulations!" e a flag.

---

Este desafio demonstra uma vulnerabilidade clássica de Injeção de SQL, ressaltando a importância crítica da validação e sanitização de todas as entradas do usuário em aplicações web.