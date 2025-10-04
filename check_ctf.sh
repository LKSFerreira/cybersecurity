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
            
            # Verificar se pip3 e dependências estão instalados
            if ! command -v pip3 &> /dev/null; then
                echo -e "${YELLOW}  → Instalando pip3 e dependências...${NC}"
                sudo apt install -y python3-pip python3-dev git libssl-dev libffi-dev build-essential > /dev/null 2>&1
            fi
            
            for lib in "${missing_python_libs[@]}"; do
                echo -e "${YELLOW}  → Instalando $lib...${NC}"
                
                # Tratamento especial para pwntools no Kali Linux
                if [ "$lib" == "pwntools" ]; then
                    # Tentar primeiro via apt (recomendado para Kali)
                    if sudo apt install -y python3-pwntools > /dev/null 2>&1; then
                        echo -e "${GREEN}    ✅ $lib instalado via APT${NC}"
                    else
                        # Se falhar, tentar via pip com flag --break-system-packages
                        echo -e "${YELLOW}    → Tentando instalação via pip...${NC}"
                        if pip3 install "$lib" --break-system-packages > /dev/null 2>&1; then
                            echo -e "${GREEN}    ✅ $lib instalado via pip${NC}"
                        else
                            echo -e "${RED}    ❌ Erro ao instalar $lib${NC}"
                            echo -e "${YELLOW}    💡 Tente manualmente: sudo apt install python3-pwntools${NC}"
                        fi
                    fi
                else
                    # Para outras bibliotecas, usar pip normalmente
                    if pip3 install "$lib" --break-system-packages > /dev/null 2>&1; then
                        echo -e "${GREEN}    ✅ $lib instalado com sucesso${NC}"
                    else
                        echo -e "${RED}    ❌ Erro ao instalar $lib${NC}"
                    fi
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
echo -e "Pip3: $(pip3 --version 2>/dev/null | cut -d' ' -f2 || echo 'Não instalado')"
echo -e "Espaço disponível: $(df -h / | awk 'NR==2 {print $4}')"
echo ""

# Dicas finais
echo -e "${BLUE}💡 DICAS FINAIS:${NC}"
echo "────────────────────────────────────────────────"

if [ ${#missing_python_libs[@]} -gt 0 ]; then
    for lib in "${missing_python_libs[@]}"; do
        import_name="$lib"
        [[ "$lib" == "pwntools" ]] && import_name="pwn"
        [[ "$lib" == "pycryptodome" ]] && import_name="Crypto"
        
        if ! python3 -c "import $import_name" 2>/dev/null; then
            if [ "$lib" == "pwntools" ]; then
                echo -e "${YELLOW}• Pwntools ainda ausente. Tente:${NC}"
                echo -e "  ${BLUE}sudo apt install python3-pwntools${NC}"
                echo -e "  ou"
                echo -e "  ${BLUE}pip3 install pwntools --break-system-packages${NC}"
            elif [ "$lib" == "pycryptodome" ]; then
                echo -e "${YELLOW}• Pycryptodome ainda ausente. Tente:${NC}"
                echo -e "  ${BLUE}pip3 install pycryptodome --break-system-packages${NC}"
            fi
        fi
    done
    echo ""
fi

echo -e "${GREEN}🎯 Sistema verificado para o CTF Hackers do Bem!${NC}"
echo -e "${BLUE}   Boa sorte no desafio! 🚀${NC}"
echo ""
