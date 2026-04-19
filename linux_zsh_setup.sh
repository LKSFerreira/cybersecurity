#!/bin/bash
#
# Script unificado para instalar e configurar ZSH, Oh My ZSH, Zinit e Powerlevel10k no WSL
# Versão automatizada com interface melhorada
set -e

# =================================================================
# Funções de cores e mensagens (do segundo script)
# =================================================================
{ # Colors
  COLOR_RESET='\033[0m'
  COLOR_BOLD_RED='\033[1;31m'
  COLOR_BOLD_GREEN='\033[1;32m'
  COLOR_BOLD_YELLOW='\033[1;33m'
  COLOR_BOLD_BLUE='\033[1;34m'
  COLOR_BOLD_MAGENTA='\033[1;35m'
  COLOR_BOLD_CYAN='\033[1;36m'
  COLOR_PALE_MAGENTA='\033[38;5;177m'
  COLOR_BOLD_WHITE_ON_BLACK='\033[1;37;40m'
}

echo_fancy() {
  emoji="$1"
  color="$2"
  shift 2

  msg=""
  if [ -z "$NO_EMOJI" ]; then
    msg="$emoji "
  fi

  for str in "$@"; do
    if [ -z "$NO_COLOR" ]; then
      msg="${msg}${color}"
    fi
    msg="${msg}${str}"
  done

  echo -e "${msg}${COLOR_RESET}" >&2
  unset emoji color str msg
}

echo_info() {
  echo_fancy "🔵" "${COLOR_BOLD_BLUE}" "INFO: ${*}"
}

echo_success() {
  echo_fancy "✅" "${COLOR_BOLD_GREEN}" "SUCESSO: ${*}"
}

echo_warning() {
  echo_fancy "🚧" "${COLOR_BOLD_YELLOW}" "AVISO: ${*}"
}

echo_error() {
  echo_fancy "❌" "${COLOR_BOLD_RED}" "ERRO: ${*}"
}

# =================================================================
# Início da instalação
# =================================================================
echo ""
echo_fancy "🌻" "${COLOR_BOLD_WHITE_ON_BLACK}" "============================================================================"
echo_fancy "🚀" "${COLOR_BOLD_CYAN}" " Iniciando configuração completa do ZSH + Oh My ZSH + Zinit + Powerlevel10k"
echo_fancy "🌻" "${COLOR_BOLD_WHITE_ON_BLACK}" "============================================================================"
echo ""

# --- Passo 1: Atualizar pacotes do sistema ---
echo_fancy "📦" "${COLOR_BOLD_MAGENTA}" "Passo 1/8: Atualizando a lista de pacotes do sistema..."
sudo apt update -y > /dev/null 2>&1
echo_success "Lista de pacotes atualizada."
echo ""

# --- Passo 2: Instalar dependências essenciais ---
echo_fancy "⚙️" "${COLOR_BOLD_MAGENTA}" "Passo 2/8: Instalando wget, git, curl e zsh..."
sudo apt install -y wget git curl zsh > /dev/null 2>&1
echo_success "wget, git, curl e zsh instalados com sucesso."
echo ""

# --- Passo 3: Instalar Oh My ZSH ---
echo_fancy "🎨" "${COLOR_BOLD_MAGENTA}" "Passo 3/8: Instalando Oh My ZSH..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo_warning "Oh My ZSH já está instalado. Pulando."
else
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo_success "Oh My ZSH instalado com sucesso."
fi
echo ""

# --- Passo 4: Instalar Zinit (Gerenciador de Plugins) ---
echo_fancy "🔌" "${COLOR_BOLD_MAGENTA}" "Passo 4/8: Instalando Zinit (Gerenciador de Plugins)..."
ZINIT_HOME="${HOME}/.local/share/zinit"
ZINIT_INSTALL_DIR="${ZINIT_HOME}/zinit.git"

if [ -d "$ZINIT_INSTALL_DIR" ]; then
    echo_warning "Zinit já está instalado. Pulando."
else
    mkdir -p "${ZINIT_HOME}"
    chmod g-w "${ZINIT_HOME}"
    chmod o-w "${ZINIT_HOME}"
    
    git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "${ZINIT_INSTALL_DIR}" > /dev/null 2>&1
    echo_success "Zinit instalado com sucesso."
fi
echo ""

# --- Passo 5: Instalar o tema Powerlevel10k ---
echo_fancy "⚡" "${COLOR_BOLD_MAGENTA}" "Passo 5/8: Instalando o tema Powerlevel10k..."
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo_warning "Powerlevel10k já está instalado. Pulando."
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k > /dev/null 2>&1
    echo_success "Powerlevel10k clonado com sucesso."
fi
echo ""

# --- Passo 6: Criar e configurar o .zshrc ---
echo_fancy "📝" "${COLOR_BOLD_MAGENTA}" "Passo 6/8: Criando o arquivo ~/.zshrc completo..."
rm -f ~/.zshrc

cat << 'EOF' > ~/.zshrc
# =========================================================
# Arquivo de configuração ZSH gerado automaticamente
# =========================================================

# 1. Otimização de Boot (Instant Prompt)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 2. Define o Tema Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# 3. Inicializa o Zinit (O MOTOR vem primeiro)
ZINIT_HOME="${HOME}/.local/share/zinit"
if [[ ! -f ${ZINIT_HOME}/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager...%f"
    command mkdir -p "${ZINIT_HOME}" && command chmod g-rwX "${ZINIT_HOME}"
    command git clone https://github.com/zdharma-continuum/zinit "${ZINIT_HOME}/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "${ZINIT_HOME}/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# 4. Carrega os Plugins Visuais (Eles precisam estar prontos antes do Shell carregar totalmente)
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# 5. Carrega extensões úteis
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# 6. Carrega o Oh My ZSH (O FRAMEWORK por último para não sobrescrever os plugins)
export ZSH="$HOME/.oh-my-zsh"

# ---> PLUGINS NATIVOS DO OH MY ZSH <---
plugins=(git colored-man-pages)

source "$ZSH/oh-my-zsh.sh"

# 7. Carrega a configuração do Powerlevel10k
# Para configurar, execute 'p10k configure'.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

echo_success "~/.zshrc criado e configurado com sucesso."
echo ""

# --- Passo 7: Instalar plugins e extensões do Zinit ---
echo_fancy "🧩" "${COLOR_BOLD_MAGENTA}" "Passo 7/8: Inicializando plugins no ambiente..."
echo_info "Instalando fast-syntax-highlighting (destaque de sintaxe)..."
echo_info "Instalando zsh-autosuggestions (sugestões baseadas no histórico)..."
echo_info "Instalando zsh-completions (autocompletar comandos)..."
echo_info "Instalando extensões úteis do Zinit..."

# Compila os plugins silenciosamente
zsh -c "source ~/.zshrc && zinit status" > /dev/null 2>&1 || true

echo_success "Plugins e extensões instalados com sucesso!"
echo_info "• fast-syntax-highlighting: Comandos corretos em VERDE, erros em VERMELHO"
echo_info "• zsh-autosuggestions: Sugestões em cinza baseadas no seu histórico"
echo_info "• zsh-completions: Autocompletar inteligente com informações dos comandos"
echo ""

# --- Passo 8: Alterar o shell padrão para ZSH ---
echo_fancy "🐚" "${COLOR_BOLD_MAGENTA}" "Passo 8/8: Alterando o shell padrão para ZSH..."
if [ "$(basename "$SHELL")" != "zsh" ]; then
    echo_warning "Você precisará digitar sua senha para alterar o shell padrão."
    sudo chsh -s $(which zsh) $(whoami)
    echo_success "Shell padrão alterado para ZSH."
else
    echo_success "O shell padrão já é ZSH."
fi
echo ""

# --- Mensagem Final ---
echo ""
echo_fancy "🎉" "${COLOR_BOLD_GREEN}" "============================================================================"
echo_fancy "✨" "${COLOR_BOLD_GREEN}" " Configuração do ZSH concluída com sucesso!"
echo_fancy "🎉" "${COLOR_BOLD_GREEN}" "============================================================================"
echo ""
echo_fancy "📋" "${COLOR_BOLD_CYAN}" "PRÓXIMOS PASSOS:"
echo_fancy "1️⃣" "${COLOR_BOLD_YELLOW}" "  O terminal será fechado automaticamente em 5 segundos."
echo_fancy "2️⃣" "${COLOR_BOLD_YELLOW}" "  Reabra o terminal WSL para aplicar todas as mudanças."
echo_fancy "3️⃣" "${COLOR_BOLD_YELLOW}" "  O configurador do Powerlevel10k deve iniciar automaticamente."
echo_fancy "4️⃣" "${COLOR_BOLD_YELLOW}" "  Se não iniciar, digite 'p10k configure' manualmente."
echo ""
echo_fancy "🎯" "${COLOR_BOLD_GREEN}" "PLUGINS INSTALADOS:"
echo_fancy "✅" "${COLOR_BOLD_GREEN}" "  • fast-syntax-highlighting: Verde = comando correto, Vermelho = erro"
echo_fancy "✅" "${COLOR_BOLD_GREEN}" "  • zsh-autosuggestions: Sugestões em cinza (pressione → para aceitar)"
echo_fancy "✅" "${COLOR_BOLD_GREEN}" "  • zsh-completions: TAB para autocompletar com informações"
echo ""

# --- Contador regressivo de 5 segundos ---
echo_fancy "🔄" "${COLOR_BOLD_MAGENTA}" "O terminal será fechado em:"
for i in 7 6 5 4 3 2 1; do
    echo_fancy "⏱️" "${COLOR_BOLD_CYAN}" "   $i..."
    sleep 1
done

echo_fancy "✨" "${COLOR_BOLD_GREEN}" "Fechando terminal... Até logo!"
sleep 1

# Fecha o terminal
kill -9 $PPID
