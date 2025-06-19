# Guia de Resolução: Hack The Box - Redeemer

Este documento é um guia de estudo para o desafio "Redeemer". Ele detalha o processo de enumeração e extração de dados de um servidor Redis, que é um banco de dados NoSQL do tipo chave-valor em memória. O objetivo é explicar não apenas *como* resolver, mas *por que* cada passo e comando funciona, focando na interação com o Redis através de sua interface de linha de comando (`redis-cli`).

---

## Introdução: Redis - Banco de Dados em Memória

Redis (REmote DIctionary Server) é um banco de dados NoSQL de código aberto que armazena dados em memória como pares de chave-valor. Sua principal característica é a velocidade, pois o acesso à RAM é significativamente mais rápido do que o acesso a discos. É comumente usado para caching, gerenciamento de sessões, e outras tarefas que exigem baixa latência.

A interação com o Redis é frequentemente feita através de uma ferramenta de linha de comando chamada `redis-cli`, que permite aos usuários enviar comandos diretamente ao servidor Redis.

---

## Fase 1: Preparação e Reconhecimento Inicial

Como sempre, começamos garantindo a conectividade e identificando os serviços que o alvo está oferecendo.

### 1. Explicação Didática

> Pense em investigar um cofre. Primeiro, você verifica se o cofre existe e se você pode chegar até ele (conectividade). Depois, você examina o cofre para ver qual tipo de fechadura ele tem (identificação do serviço e da porta).

### 2. Explicação Técnica (Passo a Passo)

1.  **Verificação de Conectividade:** Antes de qualquer varredura, confirmamos que a máquina alvo está acessível.

    *   **Comando:**
        ```bash
        ping {IP_DO_ALVO}
        ```
    *   **Por que funciona:** `ping` envia pacotes ICMP para o `{IP_DO_ALVO}`. Uma resposta confirma que o host está online e alcançável na rede. O write-up sugere interromper após alguns pacotes, o que é suficiente para confirmar a conectividade.

2.  **Enumeração de Portas e Serviços:** Usamos o `nmap` para descobrir os serviços ativos.

    *   **Comando:**
        ```bash
        nmap -p- -sV {IP_DO_ALVO}
        ```
    *   **Explicação dos Parâmetros:**
        *   `nmap`: A ferramenta de varredura.
        *   `-p-`: Este parâmetro instrui o `nmap` a escanear todas as 65535 portas TCP, em vez de apenas as portas mais comuns. É uma varredura mais completa.
        *   `-sV`: Tenta determinar a versão do serviço rodando em cada porta aberta. Para a máquina Redeemer, isso identificará o serviço como `Redis key-value store 5.0.7`.
        *   `{IP_DO_ALVO}`: O endereço IP da máquina Redeemer.

    *   **Resultado:** O `nmap` revela que a porta `6379/tcp` está aberta e rodando um servidor Redis versão 5.0.7. A porta 6379 é a porta padrão para o Redis.

---

## Vulnerabilidade 1: Acesso e Extração de Dados de Servidor Redis Exposto

O servidor Redis está acessível na rede sem autenticação. A "vulnerabilidade" aqui é a exposição do serviço e a capacidade de interagir com ele para extrair os dados armazenados.

### 1. Dica do Desafio

<details>
  <summary>Clique para revelar a dica</summary>
  <p>A identificação do serviço Redis na porta padrão 6379 e a natureza do desafio (CTF introdutório) sugerem que o servidor provavelmente estará acessível sem autenticação e conterá a flag diretamente no banco de dados.</p>
</details>

### 2. Explicação Didática

> Imagine que o servidor Redis é um armário de arquivos aberto, onde cada gaveta (chave) contém um documento (valor). Qualquer pessoa que encontrar este armário pode abrir as gavetas e ler os documentos. O `redis-cli` é a ferramenta que nos permite "abrir as gavetas".

Servidores Redis, especialmente em ambientes de desenvolvimento ou mal configurados, podem ser deixados acessíveis na rede sem exigir senha. Isso permite que qualquer pessoa com acesso à rede se conecte e interaja com o banco de dados.

### 3. Explicação Técnica (Passo a Passo)

1.  **Instalação do Cliente Redis (`redis-cli`):** Para interagir com o servidor Redis, precisamos da ferramenta `redis-cli`, que faz parte do pacote `redis-tools`.

    *   **Comando:**
        ```bash
        sudo apt install redis-tools
        ```
    *   **Explicação dos Parâmetros:**
        *   `sudo apt install`: Comando padrão para instalar pacotes em sistemas baseados em Debian/Ubuntu.
        *   `redis-tools`: O pacote que contém o `redis-cli` e outras utilidades do Redis.

2.  **Conexão ao Servidor Redis:** Usamos o `redis-cli` para nos conectarmos ao servidor Redis no IP do alvo.

    *   **Comando:**
        ```bash
        redis-cli -h {IP_DO_ALVO}
        ```
    *   **Explicação dos Parâmetros:**
        *   `redis-cli`: A interface de linha de comando do Redis.
        *   `-h {IP_DO_ALVO}`: O parâmetro `-h` especifica o nome do host (ou endereço IP) do servidor Redis ao qual queremos nos conectar. A porta padrão 6379 é usada automaticamente se não for especificada com `-p`.
    *   **O que acontece:** Se a conexão for bem-sucedida e não houver autenticação configurada no servidor Redis, o prompt mudará para `{IP_DO_ALVO}:6379>`, indicando que estamos conectados e podemos enviar comandos Redis.

3.  **Enumeração de Informações do Servidor:** Uma vez conectados, podemos obter informações sobre o servidor.

    *   **Comando Redis:**
        ```
        {IP_DO_ALVO}:6379> info
        ```
    *   **O que acontece:** O comando `info` retorna uma grande quantidade de informações e estatísticas sobre o servidor Redis. A seção de interesse para este desafio é `# Keyspace`, que mostra os bancos de dados disponíveis e o número de chaves em cada um. No caso da Redeemer, vemos `db0:keys=4,...`, indicando um banco de dados (índice 0) com 4 chaves.

4.  **Seleção do Banco de Dados:** O Redis pode ter múltiplos bancos de dados lógicos (numerados de 0 a 15 por padrão). Precisamos selecionar o banco de dados que contém as chaves.

    *   **Comando Redis:**
        ```
        {IP_DO_ALVO}:6379> select 0
        ```
    *   **O que acontece:** O comando `select 0` muda o contexto da nossa sessão para o banco de dados de índice 0. O servidor responde com `OK`.

5.  **Listagem de Todas as Chaves no Banco de Dados Selecionado:** Agora podemos listar todas as chaves presentes no `db0`.

    *   **Comando Redis:**
        ```
        {IP_DO_ALVO}:6379> keys *
        ```
    *   **O que acontece:** O comando `keys *` retorna uma lista de todas as chaves no banco de dados atualmente selecionado. O `*` é um curinga que corresponde a qualquer nome de chave. O resultado será:
        1.  `"temp"`
        2.  `"stor"`
        3.  `"numb"`
        4.  `"flag"`

6.  **Recuperação dos Valores das Chaves:** Para cada chave, podemos obter seu valor correspondente usando o comando `get`.

    *   **Comando Redis (para a chave "flag"):**
        ```
        {IP_DO_ALVO}:6379> get flag
        ```
    *   **O que acontece:** O comando `get flag` retorna o valor associado à chave `"flag"`. Este valor é a flag do desafio. O write-up também mostra a obtenção dos valores das outras chaves (`temp`, `stor`, `numb`), mas a chave `"flag"` é a que contém a solução.

    *   **Exemplo de Saída para a Flag:**
        `"03e1d2b376c37ab3f5319922053953eb"`

7.  **Sair do Cliente Redis (Opcional, mas boa prática):**

    *   **Comando Redis:**
        ```
        {IP_DO_ALVO}:6379> quit
        ```
    *   Isso encerra a sessão com o servidor Redis.

---

Com o valor da chave "flag" recuperado, o desafio está completo.