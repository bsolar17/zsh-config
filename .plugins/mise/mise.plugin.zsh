export MISE_DEFAULT_CONFIG_FILENAME=".mise.toml"
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi
