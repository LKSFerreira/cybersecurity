# 🚩 Guia de Preparação: 4º CTF - Hackers do Bem

<div align="center">

![Kali Linux](https://img.shields.io/badge/Kali_Linux-557C94?style=for-the-badge\&logo=kali-linux\&logoColor=white)
![WSL](https://img.shields.io/badge/WSL-0078D4?style=for-the-badge\&logo=windows\&logoColor=white)
![CTF](https://img.shields.io/badge/CTF-Ready-brightgreen?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)

**Guia completo de verificação e preparação do ambiente WSL Kali Linux para competições CTF**

[Sobre](#-sobre) • [Pré-requisitos](#-pré-requisitos) • [Instalação](#-instalação) • [Verificação](#-verificação) • [Categorias](#-categorias-do-ctf) • [Testes](#-testes-práticos) • [Recursos](#-recursos-úteis) • [Troubleshooting](#-troubleshooting)

</div>

## 📖 Sobre

Este guia foi desenvolvido para auxiliar na preparação do ambiente **WSL Kali Linux** para participação no **4º CTF - Hackers do Bem**. Contém scripts de verificação, instalação de ferramentas essenciais e testes práticos com flags simuladas.

## 🎯 Pré-requisitos

* Windows 10/11 com WSL2 habilitado
* Kali Linux instalado via WSL
* Conexão com internet estável
* Pelo menos 20GB de espaço livre

## 🔧 Instalação

### 1. Atualizar o Sistema

```bash
# Verificar versão do sistema
cat /etc/os-release
uname -a

# Listar pacotes disponíveis para atualização
sudo apt list --upgradable

# Atualizar completamente o sistema
sudo apt update && sudo apt full-upgrade -y

# Instalar ferramentas básicas top 10
sudo apt install kali-tools-top10 -y
```

### 2. Instalar Ferramentas Essenciais

```bash
# Instalar ferramentas principais de CTF
sudo apt install -y \
    nmap \
    burpsuite \
    john \
    hashcat \
    wireshark \
    metasploit-framework \
    aircrack-ng \
    hydra \
    sqlmap \
    gobuster \
    nikto \
    binwalk \
    steghide \
    foremost \
    exiftool \
    volatility3 \
    gdb \
    radare2 \
    ghidra \
    pwntools \
    python3-pip \
    git \
    wget \
    curl \
    netcat-traditional
```

```bash
# Ferramentas Python para CTF
pip3 install pwntools requests beautifulsoup4 pycryptodome
```

## ✅ Verificação

### Script de Verificação Automática

Execute o seguinte script para verificar se todas as ferramentas essenciais estão instaladas corretamente e funcionando. Ele também realiza testes práticos simulando desafios comuns de CTF.

```bash
wget https://raw.githubusercontent.com/LKSFerreira/cybersecurity/main/check_ctf.sh && chmod +x check_ctf.sh && ./check_ctf.sh
```

Crie um arquivo chamado `check_ctf.sh`:

```sh
#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Verificar se está rodando como root para instalações
check_sudo() {
    if [ "$EUID" -ne 0 ]; then 
        echo -e "${YELLOW}⚠️  Este script precisa de privilégios sudo para instalar pacotes ausentes.${NC}"
        echo -e "${YELLOW}   Você será solicitado a inserir sua senha quando necessário.${NC}"
        echo ""
    fi
}

echo "╔════════════════════════════════════════════════╗"
echo "║      VERIFICAÇÃO CTF HACKERS DO BEM            ║"
echo "╚════════════════════════════════════════════════╝"
echo ""

check_sudo

# Arrays de ferramentas e seus pacotes correspondentes
declare -A tool_packages=(
    ["nmap"]="nmap"
    ["john"]="john"
    ["hashcat"]="hashcat"
    ["hydra"]="hydra"
    ["sqlmap"]="sqlmap"
    ["gobuster"]="gobuster"
    ["binwalk"]="binwalk"
    ["steghide"]="steghide"
    ["exiftool"]="libimage-exiftool-perl"
    ["gdb"]="gdb"
    ["radare2"]="radare2"
    ["nc"]="netcat-traditional"
    ["python3"]="python3"
    ["msfconsole"]="metasploit-framework"
    ["wireshark"]="wireshark"
)

# Ferramentas adicionais úteis
additional_tools=(
    "git"
    "wget"
    "curl"
    "nikto"
    "foremost"
    "volatility3"
    "ghidra"
    "burpsuite"
    "aircrack-ng"
)

# Bibliotecas Python
python_libs=("pwntools" "requests" "pycryptodome" "beautifulsoup4")

missing_tools=()
missing_packages=()

echo -e "${BLUE}📦 VERIFICANDO FERRAMENTAS INSTALADAS:${NC}"
echo "────────────────────────────────────────────────"

# Verificar ferramentas principais
for tool in "${!tool_packages[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo -e "${GREEN}✅ $tool - INSTALADO${NC}"
    else
        echo -e "${RED}❌ $tool - AUSENTE${NC}"
        missing_tools+=("$tool")
        missing_packages+=("${tool_packages[$tool]}")
    fi
done

echo ""

# Verificar bibliotecas Python
echo -e "${BLUE}🐍 VERIFICANDO BIBLIOTECAS PYTHON:${NC}"
echo "────────────────────────────────────────────────"

missing_python_libs=()

for lib in "${python_libs[@]}"; do
    # Tratamento especial para nomes de import diferentes
    import_name="$lib"
    [[ "$lib" == "pwntools" ]] && import_name="pwn"
    [[ "$lib" == "pycryptodome" ]] && import_name="Crypto"
    [[ "$lib" == "beautifulsoup4" ]] && import_name="bs4"
    
    if python3 -c "import $import_name" 2>/dev/null; then
        echo -e "${GREEN}✅ $lib - INSTALADO${NC}"
    else
        echo -e "${RED}❌ $lib - AUSENTE${NC}"
        missing_python_libs+=("$lib")
    fi
done

echo ""

# Se houver ferramentas ou bibliotecas ausentes, oferecer instalação
if [ ${#missing_tools[@]} -gt 0 ] || [ ${#missing_python_libs[@]} -gt 0 ]; then
    echo "────────────────────────────────────────────────"
    echo -e "${YELLOW}⚠️  FERRAMENTAS AUSENTES DETECTADAS${NC}"
    echo "────────────────────────────────────────────────"
    echo ""
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo -e "${YELLOW}Ferramentas ausentes:${NC}"
        for tool in "${missing_tools[@]}"; do
            echo "  • $tool"
        done
        echo ""
    fi
    
    if [ ${#missing_python_libs[@]} -gt 0 ]; then
        echo -e "${YELLOW}Bibliotecas Python ausentes:${NC}"
        for lib in "${missing_python_libs[@]}"; do
            echo "  • $lib"
        done
        echo ""
    fi
    
    read -p "Deseja instalar as ferramentas ausentes? (s/N): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[SsYy]$ ]]; then
        echo ""
        echo -e "${BLUE}🔄 INICIANDO INSTALAÇÃO...${NC}"
        echo ""
        
        # Atualizar repositórios
        echo -e "${BLUE}📥 Atualizando repositórios...${NC}"
        sudo apt update -qq
        
        # Instalar ferramentas ausentes
        if [ ${#missing_packages[@]} -gt 0 ]; then
            echo -e "${BLUE}🔧 Instalando ferramentas do sistema...${NC}"
            for package in "${missing_packages[@]}"; do
                echo -e "${YELLOW}  → Instalando $package...${NC}"
                sudo apt install -y "$package" > /dev/null 2>&1
                
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}    ✅ $package instalado com sucesso${NC}"
                else
                    echo -e "${RED}    ❌ Erro ao instalar $package${NC}"
                fi
            done
        fi
        
        # Instalar bibliotecas Python ausentes
        if [ ${#missing_python_libs[@]} -gt 0 ]; then
            echo ""
            echo -e "${BLUE}🐍 Instalando bibliotecas Python...${NC}"
            
            # Verificar se pip3 está instalado
            if ! command -v pip3 &> /dev/null; then
                echo -e "${YELLOW}  → Instalando pip3...${NC}"
                sudo apt install -y python3-pip > /dev/null 2>&1
            fi
            
            for lib in "${missing_python_libs[@]}"; do
                echo -e "${YELLOW}  → Instalando $lib...${NC}"
                pip3 install "$lib" > /dev/null 2>&1
                
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}    ✅ $lib instalado com sucesso${NC}"
                else
                    echo -e "${RED}    ❌ Erro ao instalar $lib${NC}"
                fi
            done
        fi
        
        # Instalar ferramentas adicionais recomendadas
        echo ""
        read -p "Deseja instalar ferramentas adicionais recomendadas? (s/N): " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[SsYy]$ ]]; then
            echo ""
            echo -e "${BLUE}🔧 Instalando ferramentas adicionais...${NC}"
            
            for tool in "${additional_tools[@]}"; do
                if ! command -v "$tool" &> /dev/null; then
                    echo -e "${YELLOW}  → Instalando $tool...${NC}"
                    sudo apt install -y "$tool" > /dev/null 2>&1
                    
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}    ✅ $tool instalado com sucesso${NC}"
                    else
                        echo -e "${RED}    ❌ Erro ao instalar $tool${NC}"
                    fi
                else
                    echo -e "${GREEN}  ✅ $tool já está instalado${NC}"
                fi
            done
        fi
        
        echo ""
        echo -e "${GREEN}✨ INSTALAÇÃO CONCLUÍDA!${NC}"
        echo ""
        echo -e "${BLUE}🔄 Executando verificação final...${NC}"
        echo ""
        
        # Executar verificação final
        sleep 2
        exec "$0" # Re-executar o script para verificar novamente
    else
        echo ""
        echo -e "${YELLOW}⚠️  Instalação cancelada. Algumas ferramentas podem não funcionar corretamente.${NC}"
    fi
else
    echo "────────────────────────────────────────────────"
    echo -e "${GREEN}✅ TODAS AS FERRAMENTAS ESTÃO INSTALADAS!${NC}"
    echo "────────────────────────────────────────────────"
fi

echo ""
echo "────────────────────────────────────────────────"
echo -e "${GREEN}🏁 FLAG{SISTEMA_PRONTO_PARA_CTF}${NC}"
echo "════════════════════════════════════════════════"
echo ""

# Informações adicionais
echo -e "${BLUE}📊 RESUMO DO SISTEMA:${NC}"
echo "────────────────────────────────────────────────"
echo -e "Sistema: $(lsb_release -ds 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo -e "Kernel: $(uname -r)"
echo -e "Python: $(python3 --version 2>/dev/null || echo 'Não instalado')"
echo -e "Espaço disponível: $(df -h / | awk 'NR==2 {print $4}')"
echo ""
echo -e "${GREEN}🎯 Sistema pronto para o CTF Hackers do Bem!${NC}"
echo -e "${BLUE}   Boa sorte no desafio! 🚀${NC}"
echo ""
```

**Para executar o script:**

```bash
chmod +x check_ctf.sh
./check_ctf.sh
```

## 🎪 Categorias do CTF

### 🔴 Segurança Ofensiva

**Ferramentas:** Metasploit, Hydra, SQLMap, Gobuster, Nikto

```bash
# Testar Metasploit
msfconsole -v

# Testar Hydra
hydra -h

# Testar SQLMap
sqlmap --version
```

### 🔵 Blue Team

**Ferramentas:** Wireshark, Volatility, Snort, TCPDump

```bash
# Testar Wireshark
wireshark --version

# Testar Volatility
vol.py -h
```

### 🔍 Forense Digital

**Ferramentas:** Autopsy, Binwalk, Foremost, Volatility, ExifTool

```bash
# Testar Binwalk
binwalk --help

# Testar ExifTool
exiftool -ver

# Testar Foremost
foremost -V
```

### ⚙️ Engenharia Reversa

**Ferramentas:** Ghidra, Radare2, GDB, objdump, strings

```bash
# Testar Radare2
r2 -v

# Testar GDB
gdb --version

# Instalar GDB-PEDA (opcional)
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit
```

### 💥 Exploração de Binários

**Ferramentas:** Pwntools, ROPgadget, GDB-PEDA

```bash
# Testar Pwntools
python3 -c "from pwn import *; print(context.arch)"

# Instalar ROPgadget
pip3 install ropgadget
```

## 🧪 Testes Práticos

### Teste 1: Verificação de Rede (Nmap)

```bash
# Testar Nmap localmente
nmap --version
nmap -sV localhost
```

**FLAG_TEST_1:** ✅ Se a versão for exibida e o scan funcionar = OK

### Teste 2: Análise de Arquivos (Binwalk/Exiftool)

```bash
# Criar arquivo de teste
echo "FLAG{TESTE_BINWALK_OK}" > teste.txt

# Verificar com exiftool
exiftool teste.txt

# Testar binwalk
binwalk teste.txt
```

**FLAG_TEST_2:** ✅ Se o exiftool mostrar metadados = OK

### Teste 3: Criptografia (John the Ripper)

```bash
# Testar John the Ripper
john --test
```

**FLAG_TEST_3:** ✅ Se os benchmarks de algoritmos forem exibidos = OK

### Teste 4: Conexão de Rede (Netcat)

```bash
# Terminal 1 - Iniciar listener
nc -lvnp 4444 &

# Terminal 2 - Enviar mensagem
echo "FLAG{NETCAT_FUNCIONANDO}" | nc localhost 4444

# Verificar resultado e encerrar o listener
jobs
kill %1
```

**FLAG_TEST_4:** ✅ Se a mensagem for recebida no Terminal 1 = OK

### Teste 5: Python e Bibliotecas CTF

```bash
# Testar pwntools
python3 -c "from pwn import *; print('FLAG{PWNTOOLS_OK}')"

# Testar requests
python3 -c "import requests; print('FLAG{REQUESTS_OK}')"

# Testar crypto
python3 -c "from Crypto.Cipher import AES; print('FLAG{CRYPTO_OK}')"
```

**FLAG_TEST_5:** ✅ Se todas as bibliotecas importarem sem erro = OK

## 📚 Recursos Úteis

### Comandos Essenciais Linux

```bash
# Buscar arquivos por nome
find / -name "flag.txt" 2>/dev/null

# Buscar strings dentro de arquivos
grep -r "FLAG{" /path/to/search

# Analisar binários
strings arquivo_binario
file arquivo_desconhecido

# Verificar portas abertas
netstat -tulpn
ss -tulpn

# Listar processos em execução
ps aux | grep <nome_do_processo>
```

### Esteganografia

```bash
# Steghide - extrair dados de uma imagem
steghide extract -sf imagem.jpg

# Binwalk - analisar e extrair arquivos embutidos
binwalk -e arquivo.png

# Strings - extrair texto legível de arquivos
strings imagem.jpg | grep FLAG
```

### Web Exploitation

```bash
# Gobuster - enumerar diretórios e arquivos
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt

# SQLMap - automatizar testes de SQL Injection
sqlmap -u "http://target.com/page?id=1" --dbs

# Curl - realizar requisições HTTP
curl -X POST http://target.com/api -d "param=value"
```

## 🛠️ Troubleshooting

### Problema: Ferramentas não encontradas

Pode ser um problema com a variável de ambiente `PATH`.

```bash
# Verificar se o PATH está correto
echo $PATH

# Adicionar um diretório ao PATH (se necessário)
export PATH=$PATH:/usr/local/bin
```

### Problema: Permissões negadas (ex: Wireshark)

Algumas ferramentas precisam de permissões especiais.

```bash
# Adicionar seu usuário ao grupo 'wireshark'
sudo usermod -aG wireshark $USER

# Adicionar seu usuário ao grupo 'sudo' (se ainda não estiver)
sudo usermod -aG sudo $USER

# Para aplicar, saia e entre novamente na sessão ou use:
newgrp wireshark
```

### Problema: Metasploit não inicia

O banco de dados do Metasploit pode não ter sido inicializado.

```bash
# Inicializar e iniciar o banco de dados
sudo msfdb init
sudo msfdb start
```

## 🎓 Dicas para o CTF

1. **Leia atentamente** cada desafio antes de começar.
2. **Documente** seus passos e descobertas.
3. **Use múltiplas abordagens** se uma não funcionar.
4. **Pesquise** writeups de CTFs anteriores para aprender técnicas.
5. **Colabore** com sua equipe (se aplicável).
6. **Gerencie seu tempo** - não fique preso em um desafio por muito tempo.
7. **Mantenha organização** de flags encontradas e notas.

## 📝 Checklist Final

* [ ] Sistema atualizado (`sudo apt update && sudo apt full-upgrade -y`)
* [ ] Ferramentas essenciais instaladas via `apt`
* [ ] Script de verificação (`check_ctf.sh`) executado com sucesso
* [ ] Todos os 5 testes práticos passaram
* [ ] Ambiente de rede configurado e funcionando
* [ ] Bibliotecas Python instaladas via `pip3`
* [ ] Wordlists disponíveis em `/usr/share/wordlists`
* [ ] Metasploit inicializado e funcionando

## 🤝 Contribuindo

Encontrou algum erro ou tem sugestões? Sinta-se à vontade para:

1. Fazer um **fork** do projeto.
2. Criar uma nova **branch** (`git checkout -b feature/MinhaFeature`).
3. Fazer **commit** de suas mudanças (`git commit -m 'Adiciona nova feature'`).
4. Fazer **push** para a branch (`git push origin feature/MinhaFeature`).
5. Abrir um **Pull Request**.

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 🔗 Links Úteis

* [Hackers do Bem - Hub](https://hub.hackersdobem.org.br/)
* [Kali Linux Documentation](https://www.kali.org/docs/)
* [CTF Time](https://ctftime.org/)
* [HackTricks](https://book.hacktricks.xyz/)
* [OverTheWire Wargames](https://overthewire.org/wargames/)

---

<div align="center">

**Boa sorte no CTF! 🚩**

*Desenvolvido para o 4º CTF - Hackers do Bem*

[Repositório](https://github.com)

</div>
