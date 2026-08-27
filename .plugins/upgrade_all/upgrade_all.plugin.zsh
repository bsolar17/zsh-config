# Upgrade everything, skipping tools that aren't installed.
upgrade-all() {
    local -a skipped failed

    _upgrade-all-step() {
        local cmd=$1 run=$2
        if ! command -v $cmd >/dev/null 2>&1; then
            skipped+=($cmd)
            return 0
        fi
        print -P "%F{blue}==>%f $run"
        eval $run || failed+=($cmd)
    }

    _upgrade-all-step apt 'sudo apt update && sudo apt dist-upgrade'
    _upgrade-all-step brew 'brew upgrade'
    _upgrade-all-step mise 'mise upgrade --bump'
    _upgrade-all-step npm 'npm update -g'
    _upgrade-all-step antidote 'antidote update'

    unfunction _upgrade-all-step

    (( $#skipped )) && print -P "%F{yellow}Skipped (not installed):%f $skipped"
    if (( $#failed )); then
        print -P "%F{red}Failed:%f $failed"
        return 1
    fi
    return 0
}
