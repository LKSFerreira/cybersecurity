# Guia de Resolução: Hack The Box - Fawn

Este documento é um guia de estudo para o desafio "Fawn". Ele detalha o processo de exploração da máquina, focando na identificação e exploração de uma configuração inadequada do serviço FTP que permite acesso anônimo. O objetivo é explicar não apenas *como* resolver, mas *por que* cada passo e comando funciona.

---

## Introdução: O Protocolo FTP e Suas Configurações

O File Transfer Protocol (FTP) é um protocolo de rede padrão usado para transferir arquivos entre um cliente e um servidor. Embora seja uma tecnologia antiga, ainda é encontrada em muitos sistemas para tarefas simples de transferência de arquivos.

A principal relevância para este desafio é que o FTP, por padrão, transmite credenciais (nome de usuário e senha) em texto claro, o que é inseguro. No entanto, uma configuração ainda mais crítica, e comum em cenários de teste, é a permissão de **login anônimo**. Isso ocorre quando o servidor FTP é configurado para permitir que qualquer usuário se conecte usando um nome de usuário genérico como "anonymous" ou "ftp", muitas vezes sem a necessidade de uma senha real. Esta máquina explora exatamente essa falha de configuração.

---

## Fase 1: Preparação e Reconhecimento Inicial

Como em qualquer teste de invasão, os primeiros passos envolvem garantir a conectividade com o alvo e identificar os serviços que ele está executando.

### 1. Explicação Didática

> Antes de tentar entrar em uma casa, você primeiro verifica se o endereço está correto e se a casa existe (conectividade). Depois, você observa de fora para ver quais portas e janelas estão visíveis, e se alguma parece estar aberta ou mal trancada (portas de rede e serviços).

### 2. Explicação Técnica (Passo a Passo)

1.  **Verificação de Conectividade:** Após obter o endereço IP da máquina "Fawn", o primeiro passo é confirmar que podemos alcançá-la na rede.

    *   **Comando:**
        ```bash
        ping {IP_DO_ALVO}
        ```
    *   **Por que funciona:** O comando `ping` envia pequenos pacotes de dados (ICMP Echo Request) para o `{IP_DO_ALVO}`. Se o alvo estiver online e acessível, ele responderá (ICMP Echo Reply). Isso confirma a conectividade básica. O write-up menciona que o ping pode ser bloqueado em ambientes corporativos, mas é um primeiro teste válido em laboratórios.

2.  **Enumeração de Portas e Serviços:** Com a conectividade confirmada, usamos o `nmap` para descobrir quais serviços estão ativos no alvo.

    *   **Comando Inicial (Descoberta de Portas):**
        ```bash
        sudo nmap {IP_DO_ALVO}
        ```
        Este comando realiza uma varredura padrão, que no caso da máquina Fawn, identificará a porta `21/tcp` como aberta e associada ao serviço `ftp`.

    *   **Comando Detalhado (Identificação de Versão):**
        ```bash
        sudo nmap -sV {IP_DO_ALVO}
        ```
    *   **Explicação dos Parâmetros:**
        *   `sudo`: Necessário porque algumas técnicas de varredura do `nmap`, especialmente as mais eficazes para detecção de versão, requerem privilégios de administrador.
        *   `nmap`: A ferramenta de varredura de rede.
        *   `-sV`: Instrui o `nmap` a tentar determinar a versão do serviço rodando em cada porta aberta. No caso da Fawn, isso identifica o serviço como `vsftpd 3.0.3`. Saber a versão é útil para pesquisar vulnerabilidades conhecidas, embora neste caso a vulnerabilidade seja de configuração.
        *   `{IP_DO_ALVO}`: O endereço IP da máquina Fawn.

    *   **Resultado:** A varredura com `-sV` confirma a porta `21/tcp` aberta, rodando `vsftpd 3.0.3`.

---

## Vulnerabilidade 1: Acesso Anônimo ao FTP (Foothold)

A única porta de interesse identificada é a do FTP. A exploração se baseia na má configuração comum de permitir acesso anônimo.

### 1. Dica do Desafio

<details>
  <summary>Clique para revelar a dica</summary>
  <p>A introdução do write-up e a natureza do FTP em si (especialmente a menção a logins anônimos) sugerem fortemente que devemos tentar acessar o serviço sem credenciais válidas, ou com credenciais genéricas de acesso anônimo.</p>
</details>

### 2. Explicação Didática

> Imagine que o servidor FTP é uma sala de arquivos. Normalmente, você precisaria de um crachá (nome de usuário) e uma senha para entrar. No entanto, nesta sala específica, o segurança (o servidor FTP) foi instruído a deixar qualquer pessoa entrar se disser que é um "visitante anônimo", sem se importar com a senha que essa pessoa fornecer.

**Acesso Anônimo ao FTP** é uma configuração onde o servidor permite que usuários se conectem fornecendo o nome de usuário `anonymous` (ou, às vezes, `ftp`). Tradicionalmente, qualquer string era aceita como senha (muitas vezes um endereço de e-mail era convencionado, mas não validado).

### 3. Explicação Técnica (Passo a Passo)

1.  **Instalação do Cliente FTP (se necessário):** Para interagir com um servidor FTP, precisamos de um cliente FTP.

    *   **Comando:**
        ```bash
        sudo apt install ftp -y
        ```
    *   **Explicação dos Parâmetros:**
        *   `sudo apt install`: Comando padrão em sistemas baseados em Debian/Ubuntu para instalar pacotes.
        *   `ftp`: Nome do pacote do cliente FTP.
        *   `-y`: Responde automaticamente "sim" para qualquer confirmação, útil para automação.

2.  **Conexão ao Servidor FTP:** Usamos o cliente FTP para conectar ao IP do alvo.

    *   **Comando:**
        ```bash
        ftp {IP_DO_ALVO}
        ```
    *   **O que acontece:** O cliente tenta estabelecer uma conexão com o servidor FTP no `{IP_DO_ALVO}`. Se bem-sucedido, o servidor responde com uma mensagem de boas-vindas (ex: `220 (vsFTPd 3.0.3)`) e solicita um nome de usuário (`Name ({target_IP}:{username}):`).

3.  **Login Anônimo:** Esta é a exploração da má configuração.

    *   **Entrada do Nome de Usuário:** No prompt `Name (...)`, digite:
        ```
        anonymous
        ```
    *   **Entrada da Senha:** O servidor responderá com algo como `331 Please specify the password.`. No prompt `Password:`, você pode digitar qualquer coisa (o write-up usa `anon123`) ou simplesmente pressionar Enter.
        ```
        anon123
        ```
    *   **Por que funciona:** O servidor `vsftpd` na máquina Fawn está configurado para aceitar logins anônimos. Para este tipo de login, a senha fornecida é geralmente ignorada ou registrada apenas para fins de log, não para autenticação real.

4.  **Verificação do Login e Exploração:** Se o login for bem-sucedido, você verá uma mensagem como `230 Login successful.` e o prompt mudará para `ftp>`.

5.  **Listagem de Arquivos:** Uma vez dentro do servidor FTP, o próximo passo é ver quais arquivos estão disponíveis.

    *   **Comando FTP:**
        ```
        ls
        ```
    *   **O que acontece:** Similar ao comando `ls` do Linux, ele lista os arquivos e diretórios no diretório atual do servidor FTP. O arquivo `flag.txt` será visível.

6.  **Download da Flag:** Para obter o conteúdo da flag, precisamos baixá-la para nossa máquina.

    *   **Comando FTP:**
        ```
        get flag.txt
        ```
    *   **O que acontece:** O comando `get` instrui o cliente FTP a baixar o arquivo `flag.txt` do servidor para o diretório local em sua máquina atacante de onde você iniciou o cliente `ftp`. Mensagens como `200 PORT command successful.` e `226 Transfer complete.` indicarão sucesso.

7.  **Sair do Cliente FTP:**

    *   **Comando FTP:**
        ```
        bye
        ```
    *   Isso encerra a sessão FTP e retorna ao seu terminal normal.

8.  **Visualização da Flag:** De volta ao seu terminal, verifique o arquivo baixado e exiba seu conteúdo.

    *   **Comandos no terminal do atacante:**
        ```bash
        ls
        cat flag.txt
        ```
    *   O `ls` mostrará que `flag.txt` agora existe localmente. O `cat flag.txt` exibirá o conteúdo da flag, completando o desafio.

---