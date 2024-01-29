#!/usr/bin/env zsh

function load() {
    local lib=''
    local libPath="${G_DOTFILES_ROOT}/src/lib"
    if [[ -n "$(ls -A ${libPath})" ]]; then
        for lib in ${libPath}/*.zsh; do
            if [[ -f ${lib} ]]; then
                source "${lib}"
            fi
        done
    fi
}