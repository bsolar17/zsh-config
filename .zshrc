#!/usr/bin/env zsh

# Homebrew
if [[ $+commands[brew] ]]; then
    export HOMEBREW_NO_ANALYTICS=1
    eval "$(/opt/homebrew/bin/brew shellenv)"
    fpath+=(
        "${HOMEBREW_PREFIX}/share/zsh/site-functions"
        "${HOMEBREW_PREFIX}/opt/homebrew/share/zsh-completions"
        $fpath
    )
fi

# Tmux
if [[ $+commands[tmux] ]]; then
    if [ -z "${TMUX}" ]; then
        UNATTACHED_TMUX_SESSIONS=$(tmux ls -F '#{session_name}' -f '#{m:0,#{session_attached}}' 2> /dev/null)
        if [ -z "${UNATTACHED_TMUX_SESSIONS}" ]; then
            exec tmux new
        else
            exec tmux attach
        fi
    fi
fi

# Colors
export CLICOLOR=1
export LSCOLORS="ExFxCxDxBxegedabagacad"
export LS_COLORS="di=1;34:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# Autocompletion
unsetopt list_beep
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'%B%d%b'

if [[ $UID == 0 || $EUID == 0 ]]; then
    # Ignore compinit complaining about files not owned by root
    autoload -Uz compinit && compinit -u -d "$ZSH_COMPDUMP/.zcompdump"
else
    autoload -Uz compinit && compinit -d "$ZSH_COMPDUMP/.zcompdump"
fi

# Keybinds
bindkey -v # vi mode
bindkey -M vicmd '_' vi-first-non-blank 
bindkey ^R history-incremental-search-backward 
bindkey ^S history-incremental-search-forward

# Alias
alias bc="bc -lq"
alias vi=vim
(($+commands[nvim])) && alias vim=nvim
alias vimdiff="vim -d"

# History
setopt extended_history
setopt hist_ignore_dups
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history
export HISTSIZE=250000
export SAVEHIST=250000
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/zsh_history"

# Syntax highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue,bold'
source "${ZDOTDIR:-$HOME/.config/zsh}/.zsh_links/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Autosuggestions
source "${ZDOTDIR:-$HOME/.config/zsh}/.zsh_links/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Prompt basics
setopt PROMPT_SUBST
BOLD_RED='%F{red}%B'
BOLD_GREEN='%F{green}%B'
NORMAL='%f%b'
BOLD_BLUE='%F{blue}%B'
PROMPT_COL="%(?.${BOLD_BLUE}.${BOLD_RED})"
PROMPT_HOST="%(!.${BOLD_RED}%m${BOLD_BLUE}.${BOLD_GREEN}%n@%m${BOLD_BLUE})"

# Set simple prompt before configuring git-prompt
PS1="${PROMPT_HOST} %1~ ${PROMPT_COL}%#${NORMAL} "	

# Configure git-prompt
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto git"
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_STATESEPARATOR=""
source "${ZDOTDIR:-$HOME/.config/zsh}/.zsh_links/git-prompt.sh"

autoload -Uz async && async

get_git_info() {
    cd -q ${1}
    __git_ps1 '(%s) '
}

get_git_info_complete() {
    PROMPT="${PROMPT_HOST} %1~${NORMAL} ${3}${PROMPT_COL}%#${NORMAL} "
    zle && zle reset-prompt
}

async_start_worker get_git_info -n
async_register_callback get_git_info get_git_info_complete

precmd() {
    PROMPT="${PROMPT_HOST} %1~ ${PROMPT_COL}%#${NORMAL} "	
    async_job get_git_info get_git_info ${PWD}
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
