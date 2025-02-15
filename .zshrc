# Source zshrc files
for zsh_file in ${ZDOTDIR}/.zshrc.d/*.zsh; source $zsh_file
unset zsh_file
