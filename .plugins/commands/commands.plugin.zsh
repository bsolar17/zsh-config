alias ls="ls --color=auto"
alias bc="bc -lq"
alias vi=vim
alias vimdiff="vim -d"
if [[ (($+commands[nvim])) ]]; then
    alias vim=nvim
    export EDITOR=nvim
fi
