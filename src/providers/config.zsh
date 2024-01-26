#!/usr/bin/env zsh

function load() {
    autoload -Uz compinit && compinit
    zstyle ':completion:*' menu select
}