# Source zshenv files
for zsh_file in ${ZDOTDIR}/.zshenv.d/*.zsh; source $zsh_file
unset zsh_file
