alias ls="ls --color=auto"
alias bc="bc -lq"
if (($+commands[nvim])); then
    alias vi=vim
    alias vim=nvim
    alias vimdiff="nvim -d"
    export EDITOR=nvim
elif (($+commands[vim])); then
    alias vi=vim
    alias vimdiff="vim -d"
    export EDITOR=vim
else
    export EDITOR=vi
fi
