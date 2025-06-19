# Guia de Resolução: Hack The Box - Dancing

Este documento é um guia de estudo para o desafio "Dancing". Ele detalha a exploração da máquina, focando na identificação e acesso a um compartilhamento SMB (Server Message Block) mal configurado, permitindo a enumeração de arquivos e a captura da flag. O objetivo é explicar não apenas *como* resolver, mas *por que* cada passo e comando funciona.

---

## Introdução: O Protocolo SMB e Compartilhamentos de Rede

O SMB é um protocolo de comunicação de rede usado principalmente por sistemas Windows para fornecer acesso compartilhado a arquivos, impressoras e outros recursos de rede. Ele opera nas camadas superiores do modelo OSI (Aplicação/Apresentação) e geralmente utiliza a porta TCP 445.

Um conceito central no SMB é o de "share" (compartilhamento), que é essencialmente uma pasta ou recurso disponibilizado na rede para outros computadores acessarem. Embora o SMB possua mecanismos de autenticação, configurações incorretas podem permitir acesso não autenticado (anônimo ou como convidado), o que representa uma vulnerabilidade significativa. Esta máquina explora tal falha.

---

## Fase 1: Preparação e Reconhecimento Inicial

Os passos iniciais são cruciais para entender o alvo. Garantimos a conectividade e identificamos os serviços expostos.

### 1. Explicação Didática

> Imagine que você está investigando um prédio. Primeiro, você confirma o endereço e se ele realmente existe (conectividade). Depois, você observa de fora para ver quais portas e janelas estão visíveis e quais parecem ser de interesse (portas de rede e serviços ativos).

### 2. Explicação Técnica (Passo a Passo)

1.  **Verificação de Conectividade (Prática Recomendada):**
    Embora o write-up comece diretamente com o `nmap`, em um cenário real, um `ping` inicial é uma boa prática.
    *   **Comando:**
        ```bash
        ping {IP_DO_ALVO}
        ```
    *   **Por que funciona:** Confirma que a máquina alvo está online e respondendo na rede.

2.  **Enumeração de Portas e Serviços:** Utilizamos o `nmap` para descobrir os serviços ativos no alvo.

    *   **Comando:**
        ```bash
        sudo nmap -sV {IP_DO_ALVO}
        ```
    *   **Explicação dos Parâmetros:**
        *   `sudo`: Muitas técnicas de `nmap`, especialmente para detecção de versão, requerem privilégios elevados.
        *   `nmap`: A ferramenta de varredura.
        *   `-sV`: Tenta identificar o serviço e a versão do software em execução nas portas abertas. Isso é vital para encontrar vulnerabilidades conhecidas ou entender a natureza do serviço.
        *   `{IP_DO_ALVO}`: O endereço IP da máquina "Dancing".

    *   **Resultado:** O `nmap` identifica as portas `135/tcp` (msrpc - Microsoft Windows RPC) e `445/tcp` (microsoft-ds - SMB sobre TCP) abertas. A presença da porta 445 indica fortemente um serviço SMB ativo.

---

## Vulnerabilidade 1: Acesso a Compartilhamento SMB Mal Configurado (Foothold)

Com o serviço SMB identificado, o próximo passo é interagir com ele para descobrir compartilhamentos acessíveis e procurar por configurações permissivas.

### 1. Dica do Desafio

<details>
  <summary>Clique para revelar a dica</summary>
  <p>A natureza do SMB e a prática comum de configurações incorretas sugerem que devemos tentar listar e acessar compartilhamentos com credenciais mínimas ou nenhuma, como um usuário anônimo ou convidado.</p>
</details>

### 2. Explicação Didática

> Pense no serviço SMB como um sistema de arquivos compartilhado em um escritório. Cada departamento pode ter sua pasta (um "share"). O problema aqui é que uma dessas pastas ("WorkShares") foi deixada aberta ao público, permitindo que qualquer um entre e veja os arquivos sem precisar de um crachá (autenticação).

**Acesso Anônimo/Convidado a Compartilhamentos SMB** ocorre quando os administradores não configuram corretamente as permissões, permitindo que usuários sem credenciais válidas listem e, por vezes, acessem o conteúdo dos compartilhamentos.

### 3. Explicação Técnica (Passo a Passo)

1.  **Instalação do Cliente SMB (se necessário):** Para interagir com compartilhamentos SMB, precisamos de uma ferramenta cliente. `smbclient` é uma ferramenta comum em sistemas Linux.

    *   **Comando:**
        ```bash
        sudo apt-get install smbclient
        ```
    *   **Explicação dos Parâmetros:**
        *   `sudo apt-get install`: Comando padrão para instalar pacotes em sistemas baseados em Debian/Ubuntu.
        *   `smbclient`: O nome do pacote para o cliente SMB.

2.  **Listagem de Compartilhamentos Disponíveis:** O primeiro passo na enumeração SMB é listar quais compartilhamentos o servidor está oferecendo.

    *   **Comando:**
        ```bash
        smbclient -L {IP_DO_ALVO}
        ```
    *   **Explicação dos Parâmetros:**
        *   `smbclient`: A ferramenta cliente SMB.
        *   `-L {IP_DO_ALVO}`: O parâmetro `-L` (ou `--list=`) instrui o `smbclient` a listar os compartilhamentos disponíveis no host especificado (`{IP_DO_ALVO}`).
    *   **Autenticação:** O `smbclient` tentará se autenticar. Se você não fornecer um nome de usuário, ele usará o seu nome de usuário local. Como não temos credenciais para o servidor "Dancing", ao ser solicitado a senha (`Enter WORKGROUP\{username}'s password:`), simplesmente pressionamos **Enter** (senha em branco). Isso tenta um login anônimo ou como convidado.
    *   **Resultado:** O comando lista os seguintes compartilhamentos:
        *   `ADMIN$`: Compartilhamento administrativo oculto para acesso remoto ao disco C:.
        *   `C$`: Compartilhamento administrativo oculto para o volume C:.
        *   `IPC$`: Usado para comunicação entre processos (Inter-Process Communication), não para armazenamento de arquivos navegáveis.
        *   `WorkShares`: Um compartilhamento personalizado, provavelmente criado pelo usuário e, portanto, mais propenso a erros de configuração.

3.  **Tentativa de Acesso aos Compartilhamentos:** Agora, tentamos nos conectar a cada compartilhamento interessante, novamente usando uma senha em branco.

    *   **Tentativa no `ADMIN$`:**
        ```bash
        smbclient \\\\{IP_DO_ALVO}\\ADMIN$
        ```
        Ao ser solicitada a senha, pressione Enter.
        *   **Resultado:** `tree connect failed: NT_STATUS_ACCESS_DENIED`. Acesso negado, como esperado para compartilhamentos administrativos sem credenciais válidas.

    *   **Tentativa no `C$`:**
        ```bash
        smbclient \\\\{IP_DO_ALVO}\\C$
        ```
        Ao ser solicitada a senha, pressione Enter.
        *   **Resultado:** `tree connect failed: NT_STATUS_ACCESS_DENIED`. Acesso negado.

    *   **Tentativa no `WorkShares`:**
        ```bash
        smbclient \\\\{IP_DO_ALVO}\\WorkShares
        ```
        Ao ser solicitada a senha, pressione Enter.
        *   **Resultado:** Sucesso! O prompt muda para `smb: \>`. Isso indica que o compartilhamento `WorkShares` permite acesso anônimo/convidado.

4.  **Navegação e Download de Arquivos dentro do `WorkShares`:** Uma vez conectado ao compartilhamento, podemos usar comandos semelhantes aos do Linux para navegar e interagir com os arquivos.

    *   No prompt `smb: \>`, digite `help` para ver os comandos disponíveis.
    *   **Listar conteúdo:**
        ```
        smb: \> ls
        ```
        Isso mostrará os diretórios `Amy.J` e `James.P`.

    *   **Navegar para `Amy.J` e baixar `worknotes.txt`:**
        ```
        smb: \> cd Amy.J
        smb: \Amy.J\> ls
        smb: \Amy.J\> get worknotes.txt
        ```
        O arquivo `worknotes.txt` é baixado para o diretório local da sua máquina atacante.

    *   **Navegar para `James.P` e baixar `flag.txt`:**
        ```
        smb: \Amy.J\> cd ..
        smb: \> cd James.P
        smb: \James.P\> ls
        smb: \James.P\> get flag.txt
        ```
        O arquivo `flag.txt` é baixado.

5.  **Sair do Cliente SMB:**

    *   **Comando:**
        ```
        smb: \James.P\> exit
        ```
    *   Isso encerra a sessão `smbclient` e retorna ao seu terminal.

6.  **Visualização dos Arquivos Baixados:** De volta ao seu terminal local, você pode inspecionar os arquivos baixados.

    *   **Comandos no terminal do atacante:**
        ```bash
        cat worknotes.txt
        cat flag.txt
        ```
    *   O `worknotes.txt` contém notas que podem ser úteis em cenários mais complexos (como Pro Labs), mas para esta máquina, o `flag.txt` é o objetivo principal. O conteúdo do `flag.txt` é a flag necessária para completar o desafio.

---