if [[ -s /opt/homebrew/bin/brew ]]; then
    export HOMEBREW_NO_ANALYTICS=1
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
