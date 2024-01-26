#!/usr/bin/env zpm

import ./providers/theme.zsh --as theme
import ./providers/config.zsh --as conf
import ./providers/custom_plugin.zsh --as custom_plugin

G_DOTFILES_ROOT=${ZPM_WORKSPACE}

function init() {
    call main # <-- Auto load main function after init.
}

function main() {
    call conf.load
    call custom_plugin.load
    call theme.load
}