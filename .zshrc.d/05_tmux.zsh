if (( ${+commands[tmux]} )); then
    if [ -z "${TMUX}" ]; then
        UNATTACHED_TMUX_SESSIONS=$(tmux ls -F '#{session_name}' -f '#{m:0,#{session_attached}}' 2> /dev/null)
        if [ -z "${UNATTACHED_TMUX_SESSIONS}" ]; then
            exec tmux new
        else
            exec tmux attach
        fi
    fi
fi
