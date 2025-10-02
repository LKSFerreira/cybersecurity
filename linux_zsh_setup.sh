#!/bin/bash
#
# Script para instalar e configurar o ZSH, Oh My ZSH, Zinit e plugins no WSL (Linux).
#
# IMPORTANTE: Execute este script dentro do seu terminal WSL (ex: Ubuntu).
# Exemplo: bash ./linux_zsh_setup.sh

# --- Configuração de Segurança ---
# Encerra o script imediatamente se um comando falhar.
set -e

echo "==================================================================="
echo " Iniciando configuracao do ZSH e Oh My ZSH no WSL"
echo "==================================================================="
echo ""

# --- Passo 1: Atualizar pacotes do sistema ---
echo "--> Passo 1/8: Atualizando a lista de pacotes do sistema..."
sudo apt update -y
echo "Lista de pacotes atualizada."
echo ""

# --- Passo 2: Instalar dependencias essenciais (wget, git, zsh) ---
echo "--> Passo 2/8: Instalando wget, git e zsh..."
sudo apt install -y wget git zsh
echo "wget, git e zsh instalados com sucesso."
echo ""

# --- Passo 3: Instalar Oh My ZSH ---
echo "--> Passo 3/8: Instalando Oh My ZSH..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My ZSH ja esta instalado. Pulando instalacao."
else
    # O script de instalacao do Oh My ZSH ira perguntar se deseja alterar o shell padrao.
    # Responder 'y' para sim via input automatizado.
    printf "y\n" | sh -c "$(wget -O- [https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh](https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh))"
    echo "Oh My ZSH instalado com sucesso."
fi
echo ""

# --- Passo 4: Instalar Zinit (Gerenciador de Plugins) ---
echo "--> Passo 4/8: Instalando Zinit (gerenciador de plugins)..."
if [ -d "$HOME/.local/share/zinit" ]; then
    echo "Zinit ja esta instalado. Pulando instalacao."
else
    bash -c "$(curl --fail --show-error --silent --location [https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh](https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh))"
    echo "Zinit instalado com sucesso."
fi
echo ""

# --- Passo 5: Configurar .zshrc para Zinit e Plugins ---
echo "--> Passo 5/8: Configurando ~/.zshrc com Zinit e plugins..."

# Fazer um backup do .zshrc existente
cp ~/.zshrc ~/.zshrc.bak_$(date +%Y%m%d%H%M%S)
echo "Backup de ~/.zshrc criado em ~/.zshrc.bak_$(date +%Y%m%d%H%M%S)"

# Remover ZSH_THEME antigo e plugins=(git ...) se existirem
sed -i '/^ZSH_THEME=/d' ~/.zshrc
sed -i '/^plugins=(/d' ~/.zshrc
sed -i '/^source $ZSH\/oh-my-zsh.sh/d' ~/.zshrc


# Adicionar configuracao do Powerlevel10k e Zinit ao .zshrc
cat << 'EOF' >> ~/.zshrc

# Configurações adicionadas pelo script linux_zsh_setup.sh
# =========================================================

# Tema Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Carrega Oh My ZSH
source $ZSH/oh-my-zsh.sh

# Inicializa Zinit
# Certifique-se de que esta linha esteja ANTES de quaisquer carregamentos de plugins com zinit light
source "$HOME/.local/share/zinit/zinit.zsh"

# Plugins com Zinit
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# Para configurar o Powerlevel10k, execute 'p10k configure' apos reiniciar o terminal.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# =========================================================
EOF

echo "~/.zshrc configurado com Powerlevel10k, Zinit e os plugins."
echo ""

# --- Passo 6: Instalar o tema Powerlevel10k ---
echo "--> Passo 6/8: Instalando o tema Powerlevel10k..."
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Powerlevel10k ja esta instalado. Pulando clonagem."
else
    git clone --depth=1 [https://github.com/romkatv/powerlevel10k.git](https://github.com/romkatv/powerlevel10k.git) ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    echo "Powerlevel10k clonado com sucesso."
fi
echo ""

# --- Passo 7: Alterar o shell padrao para ZSH ---
echo "--> Passo 7/8: Alterando o shell padrao para ZSH..."
if [ "$(basename "$SHELL")" = "zsh" ]; then
    echo "O shell padrao ja e ZSH."
else
    chsh -s $(which zsh)
    echo "Shell padrao alterado para ZSH. Voce precisara reiniciar seu terminal."
fi
echo ""

# --- Passo 8: Iniciar configuracao interativa do Powerlevel10k ---
echo "--> Passo 8/8: Iniciando configuracao do Powerlevel10k..."
echo "Siga as instrucoes interativas para personalizar seu prompt."
echo "Se o configurador nao iniciar automaticamente, digite 'p10k configure' apos reiniciar o terminal."

# Recarrega o .zshrc para garantir que o p10k configure funcione corretamente
source ~/.zshrc || true # Permite que o script continue mesmo se houver um erro no source inicial

# Executa o configurador do p10k, mas APENAS se o .p10k.zsh nao existir (primeira configuracao)
if [ ! -f ~/.p10k.zsh ]; then
    p10k configure
else
    echo "O arquivo ~/.p10k.zsh ja existe. Para reconfigurar, digite 'p10k configure' manualmente."
fi

echo ""
echo "==================================================================="
echo " Configuracao do ZSH e Oh My ZSH concluida!"
echo "==================================================================="
echo ""
echo " >>> PROXIMOS PASSOS IMPORTANTES: <<<"
echo " 1. Feche e reabra seu terminal WSL para que todas as mudancas sejam aplicadas."
echo " 2. Se o configurador do Powerlevel10k nao apareceu, digite 'p10k configure' para iniciar."
echo " 3. Se ainda nao o fez, configure a fonte 'MesloLGS NF' no seu Windows Terminal."
echo "    (Configuracoes -> Perfis -> Seu Perfil WSL -> Aparencia -> Fonte)"
echo " 4. Explore as opcoes de 'Esquema de cores' no Windows Terminal para personalizar a estetica."
echo ""

# Desativa o 'set -e' ao final para nao impactar a sessao do terminal do usuario
set +e
