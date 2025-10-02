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
  echo_fancy "✅" "${COLOR_BOLD_GREEN}" "SUCCESS: ${*}"
}

echo_warning() {
  echo_fancy "🚧" "${COLOR_BOLD_YELLOW}" "WARNING: ${*}"
}

echo_error() {
  echo_fancy "❌" "${COLOR_BOLD_RED}" "ERROR: ${*}"
}

# =================================================================
# Início da instalação
# =================================================================
echo ""
echo_fancy "🌻" "${COLOR_BOLD_WHITE_ON_BLACK}" "============================================================================"
echo_fancy "🚀" "${COLOR_BOLD_CYAN}" " Iniciando configuracao completa do ZSH + Oh My ZSH + Zinit + Powerlevel10k"
echo_fancy "🌻" "${COLOR_BOLD_WHITE_ON_BLACK}" "============================================================================"
echo ""

# --- Passo 1: Atualizar pacotes do sistema ---
echo_fancy "📦" "${COLOR_BOLD_MAGENTA}" "Passo 1/8: Atualizando a lista de pacotes do sistema..."
sudo apt update -y > /dev/null 2>&1
echo_success "Lista de pacotes atualizada."
echo ""

# --- Passo 2: Instalar dependencias essenciais ---
echo_fancy "⚙️" "${COLOR_BOLD_MAGENTA}" "Passo 2/8: Instalando wget, git, curl e zsh..."
sudo apt install -y wget git curl zsh > /dev/null 2>&1
echo_success "wget, git, curl e zsh instalados com sucesso."
echo ""

# --- Passo 3: Instalar Oh My ZSH ---
echo_fancy "🎨" "${COLOR_BOLD_MAGENTA}" "Passo 3/8: Instalando Oh My ZSH..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo_warning "Oh My ZSH ja esta instalado. Pulando."
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
    echo_warning "Zinit ja esta instalado. Pulando."
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
    echo_warning "Powerlevel10k ja esta instalado. Pulando."
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
# Arquivo de configuracao ZSH gerado automaticamente
# =========================================================

# Path para a instalacao do Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# 1. Define o Tema Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# 2. Carrega o Oh My ZSH (ESSENCIAL para carregar o tema e outras funcoes)
source "$ZSH/oh-my-zsh.sh"

# 3. Inicializa o Zinit
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

# 4. Carrega os Plugins com Zinit
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# 5. Carrega annexes uteis (instalados automaticamente)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# 6. Carrega a configuracao do Powerlevel10k (se existir)
# Para configurar, execute 'p10k configure'.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

echo_success "~/.zshrc criado e configurado com sucesso."
echo ""

# --- Passo 7: Instalar plugins e annexes do Zinit ---
echo_fancy "🧩" "${COLOR_BOLD_MAGENTA}" "Passo 7/8: Instalando plugins e annexes do Zinit..."
echo_info "Instalando fast-syntax-highlighting (destaque de sintaxe)..."
echo_info "Instalando zsh-autosuggestions (sugestoes baseadas no historico)..."
echo_info "Instalando zsh-completions (autocompletar comandos)..."
echo_info "Instalando annexes (extensoes uteis do Zinit)..."

# Força a instalação dos plugins e annexes
zsh -ic "
    zinit light zdharma-continuum/fast-syntax-highlighting 2>/dev/null
    zinit light zsh-users/zsh-autosuggestions 2>/dev/null
    zinit light zsh-users/zsh-completions 2>/dev/null
    zinit light zdharma-continuum/zinit-annex-as-monitor 2>/dev/null
    zinit light zdharma-continuum/zinit-annex-bin-gem-node 2>/dev/null
    zinit light zdharma-continuum/zinit-annex-patch-dl 2>/dev/null
    zinit light zdharma-continuum/zinit-annex-rust 2>/dev/null
    @zinit-scheduler burst 2>/dev/null
" 2>&1 | grep -v "^$" || true

echo_success "Plugins e annexes instalados com sucesso!"
echo_info "• fast-syntax-highlighting: Comandos corretos em VERDE, erros em VERMELHO"
echo_info "• zsh-autosuggestions: Sugestoes baseadas no seu historico de comandos"
echo_info "• zsh-completions: Autocompletar inteligente com informacoes dos comandos"
echo ""

# --- Passo 8: Alterar o shell padrao para ZSH ---
echo_fancy "🐚" "${COLOR_BOLD_MAGENTA}" "Passo 8/8: Alterando o shell padrao para ZSH..."
if [ "$(basename "$SHELL")" != "zsh" ]; then
    echo_warning "Voce precisara digitar sua senha para alterar o shell padrao."
    chsh -s $(which zsh)
    echo_success "Shell padrao alterado para ZSH."
else
    echo_success "O shell padrao ja e ZSH."
fi
echo ""

# --- Mensagem Final ---
echo ""
echo_fancy "🎉" "${COLOR_BOLD_GREEN}" "============================================================================"
echo_fancy "✨" "${COLOR_BOLD_GREEN}" " Configuracao do ZSH concluida com sucesso!"
echo_fancy "🎉" "${COLOR_BOLD_GREEN}" "============================================================================"
echo ""
echo_fancy "📋" "${COLOR_BOLD_CYAN}" "PROXIMOS PASSOS:"
echo_fancy "1️⃣" "${COLOR_BOLD_YELLOW}" "  O terminal sera fechado automaticamente em 5 segundos"
echo_fancy "2️⃣" "${COLOR_BOLD_YELLOW}" "  Reabra o terminal WSL para aplicar todas as mudancas"
echo_fancy "3️⃣" "${COLOR_BOLD_YELLOW}" "  O configurador do Powerlevel10k deve iniciar automaticamente"
echo_fancy "4️⃣" "${COLOR_BOLD_YELLOW}" "  Se nao iniciar, digite 'p10k configure' manualmente"
echo ""
echo_fancy "🎯" "${COLOR_BOLD_GREEN}" "PLUGINS INSTALADOS:"
echo_fancy "✅" "${COLOR_BOLD_GREEN}" "  • fast-syntax-highlighting: Verde = comando correto, Vermelho = erro"
echo_fancy "✅" "${COLOR_BOLD_GREEN}" "  • zsh-autosuggestions: Sugestoes em cinza (pressione → para aceitar)"
echo_fancy "✅" "${COLOR_BOLD_GREEN}" "  • zsh-completions: TAB para autocompletar com informacoes"
echo ""

# --- Contador regressivo de 5 segundos ---
echo_fancy "🔄" "${COLOR_BOLD_MAGENTA}" "Terminal sera fechado em:"
for i in 5 4 3 2 1; do
    echo_fancy "⏱️" "${COLOR_BOLD_CYAN}" "   $i..."
    sleep 1
done

echo_fancy "✨" "${COLOR_BOLD_GREEN}" "Fechando terminal... Ate logo!"
sleep 1

# Fecha o terminal
kill -9 $PPID

set +e