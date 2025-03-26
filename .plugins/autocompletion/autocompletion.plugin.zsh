unsetopt list_beep
zstyle ':completion:complete:*' cache-path ${XDG_CACHE_HOME:-${ZDOTDIR:-${HOME}}}/zsh/zcompcache
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'%B%d%b'
