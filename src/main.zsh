#!/usr/bin/env zpm

import ./providers/theme.zsh --as theme
import ./providers/config.zsh --as conf
import ./providers/plugin.zsh --as plugins
import ./providers/lib.zsh --as libs

G_DOTFILES_ROOT=${ZPM_WORKSPACE}

function init() {
    call main # <-- Auto load main function after init.
}

function main() {
    call conf.load
    call libs.load
    call plugins.load
    call theme.load
}