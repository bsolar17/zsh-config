# ZDOTDIR
export ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}

# XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-$HOME/.xdg}
export XDG_PROJECTS_DIR=${XDG_PROJECTS_DIR:-$HOME/Projects}

# zsh cache and data homes
export ZSH_CACHE_HOME=${XDG_CACHE_HOME}/zsh
export ZSH_DATA_HOME=${XDG_DATA_HOME}/zsh

# Ensure directories exist
() {
  local zdir
  for zdir in $@; do
    [[ -d "${(P)zdir}" ]] || mkdir -p -- "${(P)zdir}"
  done
} XDG_{CONFIG,CACHE,DATA,STATE}_HOME XDG_{RUNTIME,PROJECTS}_DIR ZSH_CACHE_HOME ZSH_DATA_HOME

# Disable OSX sessions
if [[ "$OSTYPE" == darwin* ]]; then
  export SHELL_SESSIONS_DISABLE=1
fi

# Exports
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export ZSH_TMUX_AUTOSTART=${ZSH_TMUX_AUTOSTART:-true}
export ZSH_TMUX_AUTOCONNECT=false
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZVM_INIT_MODE=sourcing

# Source additional zshenv files
for zsh_file in ${ZDOTDIR}/.zshenv.d/*.zsh(.N); source $zsh_file
unset zsh_file

typeset -gU path fpath
