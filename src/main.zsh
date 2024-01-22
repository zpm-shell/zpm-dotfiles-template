#!/usr/bin/env zpm

import ./main.zsh --as self

function init() {
    call self.main
}

function main() {
    echo "Hello world: Dotfiles"
}