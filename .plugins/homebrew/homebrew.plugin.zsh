if [[ -s /opt/homebrew/bin/brew ]]; then
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_ENV_HINTS=1
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -s /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_ENV_HINTS=1
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
if [[ -d "$HOMEBREW_PREFIX/opt/ffmpeg-full/bin" ]]; then
    export PATH="$HOMEBREW_PREFIX/opt/ffmpeg-full/bin:$PATH"
fi
