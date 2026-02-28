alias ls="ls --color=auto"
alias bc="bc -lq"
if (($+commands[nvim])); then
    export EDITOR="$(command -v nvim)"
    alias vi=vim
    alias vim="$EDITOR"
    alias vimdiff="$EDITOR -d"
elif (($+commands[vim])); then
    export EDITOR="$(command -v vim)"
    alias vi=vim
    alias vimdiff="$EDITOR -d"
else
    export EDITOR=vi
fi
