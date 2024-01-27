#!/usr/bin/env zsh

import github.com/zpm-shell/zpm/src/utils/log.zsh --as log

function load() {
    # local plugin=''
    # for plugin in ${G_DOTFILES_ROOT}/src/custom/plugins/*; do
    #     local name=${plugin:t}
    #     local pluginPath=${plugin}/${name}.plugin.zsh
    #     if [[ -f ${pluginPath} ]]; then
    #         . ${pluginPath}
    #     else
    #         call log.error "Plugin ${name} not found."
    #     fi
    # done
}