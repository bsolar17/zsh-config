# Load antidote
source ${ZDOTDIR}/.antidote.zsh

# Source additional zshrc files
for zsh_file in ${ZDOTDIR}/.zshrc.d/*.zsh(.N); source $zsh_file
unset zsh_file
