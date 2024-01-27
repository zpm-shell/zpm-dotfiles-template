#!/usr/bin/env zsh

function load() {
    local lib=''
    for lib in ${G_DOTFILES_ROOT}/src/lib/*.zsh; do
        . "${lib}"
    done
}