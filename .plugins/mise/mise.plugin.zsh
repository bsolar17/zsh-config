if command -v mise >/dev/null 2>&1; then
    export MISE_DEFAULT_CONFIG_FILENAME=".mise.toml"
    alias envmise="eval '\$(MISE_ENV_FILE=.env mise env)'"
    eval "$(mise activate zsh)"
fi
