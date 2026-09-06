# Upgrade everything, skipping tools that aren't installed.
upgrade-all() {
    local -aU failed

    _upgrade-all-step() {
        local cmd=$1 run=$2 label=${3:-$2}
        if ! command -v $cmd >/dev/null 2>&1; then
            print -P "%F{yellow}==>%f ${3:-$cmd} (not installed, skipping)"
            return 0
        fi
        print -P "%F{blue}==>%f $label"
        eval $run || failed+=(${3:-$cmd})
    }

    # Fast-forward a config repo. Skips silently when the directory isn't a
    # checkout, so a partially set-up machine doesn't report a failure.
    _upgrade-all-git() {
        local dir=$1
        if [[ ! -d $dir/.git ]]; then
            print -P "%F{yellow}    not a git checkout, skipping%f"
            return 0
        fi
        git -C $dir pull --ff-only
    }

    # Refresh the Mason registry, then update every installed package that has a
    # newer version. Asks the registry what's installed rather than relying on a
    # declared tool list, so nothing has to be kept in sync by hand.
    _upgrade-all-mason() {
        nvim --headless -c 'lua
            local registry = require("mason-registry")
            local ok = true

            -- Equivalent of :MasonUpdate -- force a refresh of all registries.
            local refreshed = false
            registry.update(function(success, err)
              if not success then
                ok = false
                print(("registry update failed: %s"):format(vim.inspect(err)))
              end
              refreshed = true
            end)
            if not vim.wait(120000, function() return refreshed end, 200) then
              print("registry update timed out")
              ok = false
            end
            if not ok then
              vim.cmd("cquit 1")
            end

            -- Update each installed package whose latest version differs from the
            -- installed one -- the same check the `U` keymap runs in the :Mason UI.
            local pending = 0
            for _, pkg in ipairs(registry.get_installed_packages()) do
              local installed = pkg:get_installed_version()
              local has_latest, latest = pcall(pkg.get_latest_version, pkg)
              if has_latest and latest ~= installed and pkg:is_installable { version = latest } then
                pending = pending + 1
                print(("updating %s %s -> %s"):format(pkg.name, tostring(installed), latest))
                pkg:install(nil, function(success, err)
                  if not success then
                    ok = false
                    print(("failed %s: %s"):format(pkg.name, vim.inspect(err)))
                  end
                  pending = pending - 1
                end)
              end
            end

            if not vim.wait(900000, function() return pending == 0 end, 200) then
              print("package updates timed out")
              ok = false
            end
            if not ok then
              vim.cmd("cquit 1")
            end
        ' +qa
    }

    _upgrade-all-step git '_upgrade-all-git ${ZDOTDIR:-$HOME/.config/zsh}' 'config: zsh'
    _upgrade-all-step git '_upgrade-all-git $HOME/.config/tmux' 'config: tmux'
    _upgrade-all-step git '_upgrade-all-git $HOME/.config/nvim' 'config: nvim'
    _upgrade-all-step apt 'sudo apt update && sudo apt dist-upgrade'
    _upgrade-all-step brew 'brew upgrade'
    _upgrade-all-step mise 'mise upgrade --bump'
    _upgrade-all-step npm 'npm update -g'
    _upgrade-all-step antidote 'antidote update'
    _upgrade-all-step nvim 'nvim --headless "+Lazy! sync" +qa' 'nvim: lazy sync'
    _upgrade-all-step nvim '_upgrade-all-mason' 'nvim: mason update'

    unfunction _upgrade-all-step _upgrade-all-git _upgrade-all-mason

    if (( $#failed )); then
        print -P "%F{red}Failed:%f $failed"
        return 1
    fi
    return 0
}
