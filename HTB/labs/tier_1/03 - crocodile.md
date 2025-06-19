# Guia de Resolução: Hack The Box - Crocodile

Este documento é um guia de estudo para o desafio "Crocodile". Ele detalha uma cadeia de exploração que combina duas vulnerabilidades comuns: acesso anônimo a um servidor FTP contendo arquivos de credenciais e, em seguida, o uso dessas credenciais para acessar um painel administrativo em uma aplicação web. O objetivo é explicar não apenas *como* realizar a exploração, mas *por que* cada passo e comando funciona.

---

## Introdução: Encadeamento de Vetores de Exploração

Em cenários de teste de invasão, raramente uma única vulnerabilidade leva ao comprometimento total. Mais frequentemente, os atacantes encadeiam múltiplas vulnerabilidades menores. Por exemplo, informações obtidas de um serviço mal configurado (como um FTP anônimo) podem fornecer credenciais ou pistas para explorar outro serviço (como um painel de login de uma aplicação web). A máquina "Crocodile" ilustra este conceito.

---

## Fase 1: Enumeração Inicial - FTP Anônimo e Servidor Web

O primeiro passo é identificar os serviços expostos pelo alvo e procurar por configurações inseguras óbvias.

### 1. Explicação Didática

> Imagine que você está investigando uma propriedade. Primeiro, você olha ao redor para ver quais portas e janelas estão visíveis (portas de rede). Você percebe uma porta de serviço (FTP) que está destrancada e qualquer um pode entrar (acesso anônimo). Dentro desta sala, você encontra um caderno com nomes de usuário e senhas. Você também nota uma porta principal para um escritório (o servidor web). A ideia é tentar usar as credenciais encontradas na porta de serviço para entrar no escritório.

### 2. Explicação Técnica (Passo a Passo)

1.  **Enumeração de Portas e Serviços:** Utilizamos o `nmap` para uma varredura completa.

    *   **Comando:**
        ```bash
        sudo nmap -sC -sV {IP_DO_ALVO}
        ```
    *   **Explicação dos Parâmetros:**
        *   `sudo`: Para scripts e detecção de versão que podem precisar de privilégios.
        *   `nmap`: A ferramenta de varredura.
        *   `-sC`: Executa scripts de enumeração padrão. Para FTP, isso tentará um login anônimo e listará arquivos se bem-sucedido. Para HTTP, pode obter o título da página e cabeçalhos do servidor.
        *   `-sV`: Tenta identificar a versão dos serviços.
        *   `{IP_DO_ALVO}`: O endereço IP da máquina "Crocodile".

    *   **Resultado:** O `nmap` identifica duas portas principais:
        *   **Porta 21/tcp (FTP):** Rodando `vsftpd 3.0.3`. Crucialmente, o script `ftp-anon` do `nmap` relata: `Anonymous FTP login allowed (FTP code 230)`. Ele também lista dois arquivos no diretório raiz do FTP: `allowed.userlist` e `allowed.userlist.passwd`.
        *   **Porta 80/tcp (HTTP):** Rodando `Apache httpd 2.4.41 ((Ubuntu))`. O título da página é "Smash - Bootstrap Business Template".

2.  **Exploração do Acesso Anônimo ao FTP:** Como o `nmap` indicou que o login anônimo é permitido, nos conectamos ao FTP para investigar os arquivos listados.

    *   **Conexão ao FTP:**
        ```bash
        ftp {IP_DO_ALVO}
        ```
        Quando solicitado `Name ({target_IP}:{username}):`, digite `anonymous`.
        Para a senha, pressione Enter (ou digite qualquer coisa, pois geralmente é ignorada para logins anônimos bem-sucedidos).
        *   **Resultado:** Login bem-sucedido (`230 Login successful.`). O prompt muda para `ftp>`.

    *   **Listagem de Arquivos no FTP (verificação):**
        ```
        ftp> dir
        ```
        (ou `ls`). Isso confirma a presença de `allowed.userlist` e `allowed.userlist.passwd`.

    *   **Download dos Arquivos de Credenciais:**
        ```
        ftp> get allowed.userlist
        ftp> get allowed.userlist.passwd
        ```
        Os arquivos são baixados para o diretório local da sua máquina.

    *   **Sair do FTP:**
        ```
        ftp> exit
        ```

3.  **Análise dos Arquivos Baixados:** De volta ao seu terminal local, examine o conteúdo dos arquivos.

    *   **Comandos:**
        ```bash
        cat allowed.userlist
        cat allowed.userlist.passwd
        ```
    *   **Conteúdo de `allowed.userlist`:**
        ```
        aron
        pwnmeow
        egotisticalsw
        admin
        ```
    *   **Conteúdo de `allowed.userlist.passwd`:**
        ```
        root
        Supersecretpassword1
        @BaASD&9032123sADS
        rKXM59ESxesUFHAd
        ```
        Temos uma lista de nomes de usuário e uma lista de senhas. A tarefa agora é tentar combinar esses usuários e senhas no outro serviço encontrado: a aplicação web na porta 80.

---

## Fase 2: Enumeração e Exploração da Aplicação Web

Com as credenciais em mãos, o foco muda para a aplicação web na porta 80. Precisamos encontrar um painel de login e tentar as credenciais.

### 1. Explicação Didática

> Agora que temos uma lista de possíveis chaves (usuários e senhas) encontradas na sala de serviço (FTP), vamos até a porta principal do escritório (aplicação web). Primeiro, procuramos por uma fechadura óbvia (página de login). Se não houver uma visível, usamos uma ferramenta para procurar por portas escondidas ou menos óbvias (enumeração de diretórios web com `gobuster`).

### 2. Explicação Técnica (Passo a Passo)

1.  **Análise Inicial da Aplicação Web e Tecnologias:**
    *   Acessar `http://{IP_DO_ALVO}/` no navegador mostra uma página de negócios.
    *   O write-up sugere usar a extensão de navegador `Wappalyzer` para identificar tecnologias usadas pelo site. Isso revela que o site usa PHP e Ubuntu. Essa informação pode ser útil, mas não é diretamente explorável neste caso.

2.  **Enumeração de Diretórios e Arquivos Web:** Como não há um link de login óbvio na página inicial, usamos `gobuster` para encontrar páginas ocultas, especialmente páginas de login.

    *   **Comando:**
        ```bash
        gobuster dir --url http://{IP_DO_ALVO}/ --wordlist /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt -x php,html
        ```
    *   **Explicação dos Parâmetros:**
        *   `gobuster dir`: Modo de enumeração de diretórios/arquivos.
        *   `--url http://{IP_DO_ALVO}/`: A URL base.
        *   `--wordlist ...`: Caminho para a wordlist.
        *   `-x php,html`: Especifica para procurar por arquivos com extensões `.php` e `.html`. Isso ajuda a focar em páginas web e reduzir ruído.

    *   **Resultado:** `gobuster` encontra `/login.php` (Status: 200).

3.  **Acesso ao Painel de Login e Tentativa de Credenciais:**
    *   Navegue para `http://{IP_DO_ALVO}/login.php`. Isso apresenta um formulário de login.
    *   Agora, tentamos as combinações de usuários de `allowed.userlist` com as senhas de `allowed.userlist.passwd`.
        *   Usuário: `admin`
        *   Senha: `Supersecretpassword1` (esta é uma das senhas da lista `allowed.userlist.passwd`; o write-up não especifica qual senha exata funciona com `admin`, mas implica que uma delas funciona após algumas tentativas).

4.  **Acesso ao Painel Administrativo e Captura da Flag:**
    *   Após inserir a combinação correta (ex: `admin` / `Supersecretpassword1`), o login é bem-sucedido.
    *   Somos redirecionados para um painel de "Server Manager".
    *   A flag `c7110277ac44d78b6a9fff2232434d16` é exibida diretamente no topo do painel administrativo.

---

Este desafio demonstra como informações vazadas de um serviço (FTP anônimo) podem ser cruciais para comprometer outro serviço (painel de login da aplicação web). A segurança em camadas e a minimização da exposição de informações são fundamentais.