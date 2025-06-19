# Guia de Resolução: Hack The Box - Meow

Este documento é um guia de estudo para o desafio "Meow". Ele detalha o processo de exploração da máquina, desde o reconhecimento inicial até a obtenção do acesso e a captura da flag. O objetivo é explicar não apenas *como* resolver, mas *por que* cada passo e comando funciona, focando nos conceitos fundamentais de enumeração e exploração de credenciais fracas.

---

## Fase 1: Preparação e Reconhecimento Inicial

Antes de atacar um alvo, é preciso garantir que estamos na mesma rede e que ele está acessível. Esta fase estabelece a conectividade e realiza a primeira varredura para descobrir serviços ativos.

### 1. Explicação Didática

> Pense nisso como o planejamento de uma visita. Primeiro, você precisa chegar ao bairro certo (conectar-se à rede do Hack The Box). Depois, você precisa confirmar o endereço da casa (o endereço IP do alvo). Por fim, antes de tentar entrar, você anda pela calçada e olha quais janelas e portas estão visíveis (portas de rede abertas).

### 2. Explicação Técnica (Passo a Passo)

1.  **Conexão e Verificação:** O primeiro passo é conectar-se à rede do laboratório, seja via Pwnbox ou OpenVPN, e obter o endereço IP da máquina alvo. Com o IP em mãos, verificamos a conectividade.

    *   **Comando:**
        ```bash
        ping {IP_DO_ALVO}
        ```
    *   **Por que funciona:** O comando `ping` envia pacotes de rede (ICMP Echo Request) para o alvo. Se o alvo responder (ICMP Echo Reply), sabemos duas coisas: a máquina está online e nossa máquina consegue se comunicar com ela na rede. É o teste de conectividade mais básico.

2.  **Enumeração de Portas:** Uma vez confirmada a conectividade, precisamos descobrir quais serviços a máquina está oferecendo na rede. Para isso, usamos um scanner de portas.

    *   **Comando:**
        ```bash
        nmap -sV {IP_DO_ALVO}
        ```
    *   **Explicação dos Parâmetros:**
        *   `nmap`: Abreviação de "Network Mapper", é a ferramenta padrão para descoberta de redes e auditoria de segurança.
        *   `-sV`: Este parâmetro instrui o `nmap` a não apenas verificar se uma porta está aberta, mas também a tentar identificar o serviço e a versão do software que está rodando nela. Saber a versão é crucial para encontrar vulnerabilidades conhecidas.
        *   `{IP_DO_ALVO}`: O endereço IP da máquina que estamos investigando.

    *   **Resultado:** O `nmap` revela que a porta `23/tcp` está aberta e rodando o serviço `Linux telnetd`.

---

## Vulnerabilidade 1: Acesso via Credenciais Fracas no Telnet

A única porta aberta nos leva a um serviço de login remoto. A vulnerabilidade aqui não está em um software complexo, mas em uma simples falha de configuração humana.

### 1. Dica do Desafio

<details>
  <summary>Clique para revelar a dica</summary>
  <p>As tags associadas à máquina no site do Hack The Box são: <i>Telnet, Reconnaissance, Weak Credentials, Misconfiguration</i>. Elas apontam diretamente para a natureza da vulnerabilidade.</p>
</details>

### 2. Explicação Didática

> Imagine uma porta de serviço de um prédio (o serviço Telnet) que leva diretamente à sala do administrador. O problema é que, em vez de uma fechadura segura, o administrador deixou a porta destrancada, permitindo que qualquer um que saiba o nome dele (`root`) entre sem precisar de chave (senha em branco).

**Credenciais Fracas** (ou, neste caso, ausentes) é uma das falhas de segurança mais comuns. Ocorre quando contas, especialmente as privilegiadas, são protegidas por senhas fáceis de adivinhar ou, como aqui, por nenhuma senha.

### 3. Explicação Técnica (Passo a Passo)

1.  **Identificação do Ponto de Entrada:** Nossa varredura com `nmap` identificou o serviço Telnet na porta 23. Telnet é um protocolo antigo e inseguro para acesso remoto, pois envia todos os dados, incluindo senhas, em texto plano.

2.  **Conexão ao Serviço:** Usamos o cliente `telnet` para nos conectarmos ao serviço.

    *   **Comando:**
        ```bash
        telnet {IP_DO_ALVO}
        ```
    *   **Por que funciona:** O comando `telnet` inicia uma sessão de comunicação com o servidor Telnet no endereço IP especificado. Ao conectar, o servidor nos apresenta um prompt de login.

3.  **Falha de Configuração (Server-side):** O sistema foi configurado de forma insegura. A conta de superusuário (`root`), que tem controle total sobre o sistema, foi deixada acessível via Telnet e, o mais crítico, **sem uma senha definida**. Permitir o login remoto do `root`, especialmente por um protocolo inseguro, é uma péssima prática de segurança.

4.  **Exploração e Obtenção de Acesso (Foothold):** Com o prompt de login visível, tentamos adivinhar credenciais comuns. A estratégia é testar usuários com altos privilégios (`admin`, `administrator`, `root`) com senhas em branco ou simples.

    *   **Tentativa 1:** `Meow login: admin` -> `Password:` (deixar em branco) -> `Login incorrect`
    *   **Tentativa 2:** `Meow login: administrator` -> `Password:` (deixar em branco) -> `Login incorrect`
    *   **Tentativa 3:** `Meow login: root` -> `Password:` (deixar em branco) -> **Sucesso!**

    Fomos autenticados com sucesso e obtivemos um shell no sistema como usuário `root`.

5.  **Pós-Exploração e Captura da Flag:** Agora que estamos dentro do sistema com privilégios máximos, o objetivo final é encontrar o arquivo da flag.

    *   **Listar arquivos:**
        ```bash
        ls
        ```
        O comando `ls` (list) mostra o conteúdo do diretório atual. Vemos o arquivo `flag.txt`.

    *   **Ler o arquivo da flag:**
        ```bash
        cat flag.txt
        ```
        O comando `cat` (concatenate) é usado aqui para exibir o conteúdo do arquivo `flag.txt` diretamente no terminal, revelando a flag e completando o desafio.