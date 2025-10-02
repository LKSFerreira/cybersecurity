#!/bin/bash
#
# Script para instalar e configurar o ZSH, Oh My ZSH, Zinit e plugins no WSL (Linux).
#
# IMPORTANTE: Execute este script dentro do seu terminal WSL (ex: Ubuntu).
# Exemplo: bash ./linux_zsh_setup.sh

# --- Configuração de Segurança ---
# Encerra o script imediatamente se um comando falhar.
set -e

# --- Função para pausar o script ---
function pause_script() {
    echo "" # Adiciona uma linha em branco para espaçamento
    read -p "--> Pressione [Enter] para continuar para o proximo passo..."
    echo ""
}

echo "==================================================================="
echo " Iniciando configuracao do ZSH e Oh My ZSH no WSL"
echo "==================================================================="
echo ""
pause_script

# --- Passo 1: Atualizar pacotes do sistema ---
echo "--> Passo 1/8: Atualizando a lista de pacotes do sistema..."
sudo apt update -y
echo "Lista de pacotes atualizada."
pause_script

# --- Passo 2: Instalar dependencias essenciais (wget, git, zsh) ---
echo "--> Passo 2/8: Instalando wget, git e zsh..."
sudo apt install -y wget git zsh
echo "wget, git e zsh instalados com sucesso."
pause_script

# --- Passo 3: Instalar Oh My ZSH ---
echo "--> Passo 3/8: Instalando Oh My ZSH..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My ZSH ja esta instalado. Pulando instalacao."
else
    # CORREÇÃO: Usando o modo '--unattended' para uma instalação não-interativa e mais robusta.
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "Oh My ZSH instalado com sucesso."
fi
pause_script

# --- Passo 4: Instalar Zinit (Gerenciador de Plugins) ---
echo "--> Passo 4/8: Instalando Zinit (gerenciador de plugins)..."
if [ -d "$HOME/.local/share/zinit" ]; then
    echo "Zinit ja esta instalado. Pulando instalacao."
else
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
    echo "Zinit instalado com sucesso."
fi
pause_script

# --- Passo 5: Configurar .zshrc para Zinit e Plugins ---
echo "--> Passo 5/8: Configurando ~/.zshrc com Zinit e plugins..."
# Fazer um backup do .zshrc existente
cp ~/.zshrc ~/.zshrc.bak_$(date +%Y%m%d%H%M%S)
echo "Backup de ~/.zshrc criado em ~/.zshrc.bak_$(date +%Y%m%d%H%MS)"

# Limpa configurações antigas para evitar duplicatas
sed -i '/^# Configurações adicionadas pelo script/,/^# =========================================================/d' ~/.zshrc 2>/dev/null || true
sed -i '/^ZSH_THEME="powerlevel10k\/powerlevel10k"/d' ~/.zshrc 2>/dev/null || true

# Adicionar configuracao do Powerlevel10k e Zinit ao .zshrc
cat << 'EOF' >> ~/.zshrc

# Configurações adicionadas pelo script linux_zsh_setup.sh
# =========================================================

# Tema Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Carrega Oh My ZSH (se o source padrão não estiver presente)
if [[ -z "$ZSH_VERSION" ]] && [[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
  source "$HOME/.oh-my-zsh/oh-my-zsh.sh"
fi

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
pause_script

# --- Passo 6: Instalar o tema Powerlevel10k ---
echo "--> Passo 6/8: Instalando o tema Powerlevel10k..."
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Powerlevel10k ja esta instalado. Pulando clonagem."
else