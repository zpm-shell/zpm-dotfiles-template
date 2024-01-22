#!/usr/bin/env zsh

local TRUE=0
local FALSE=1
local dotfiles_dir="${HOME}/.zpm-dotfiles"

##
# Check if zsh is installed
# @returnm {boolean} true if zsh is installed
##
function check_zsh_exists() {
    if [[ -z $(command -v zsh) ]]; then
        return ${FALSE}
    fi
    return ${TRUE}
}

##
# Check if zpm is installed
# @returnm {boolean} true if zpm is installed
##
function check_zpm_exists() {
    if [[ -z $(command -v zpm) ]]; then
        return ${FALSE}
    fi
    return ${TRUE}
}

##
# Check if git is installed
# @returnm {boolean} true if git is installed
##
function check_git_exists() {
    if [[ -z $(command -v git) ]]; then
        return ${FALSE}
    fi
    return ${TRUE}
}

##
# Check if curl is installed
# @returnm {boolean} true if curl is installed
##
function check_curl_exists() {
    if [[ -z $(command -v curl) ]]; then
        return ${FALSE}
    fi
    return ${TRUE}
}

##
# print error message
##
function print_error() {
    printf "%s\n" "\033[31mERROR\033[0m$1"
    exit ${FALSE}
}

local ZSHRC_START_SYMBOL="# zpm load zpm-dotfiles"
local ZSHRC_END_SYMBOL="# zpm end load zpm-dotfiles"

##
# check if the config to autoload the zpm dotfiles is already in the zshrc or not.
# @return {boolean} true if the config is already in the zshrc
##
function check_zshrc() {
    if [[ -z $(grep "${ZSHRC_START_SYMBOL}" ~/.zshrc) ]]; then
        return ${FALSE}
    fi
}

##
# add the config for the zpm dotfiles in the zshrc
# @return {boolean} true if the config is already in the zshrc
##
function add_zshrc() {
    cat >> ~/.zshrc <<EOF
${ZSHRC_START_SYMBOL}
if [[ -d ${dotfiles_dir} ]]; then
    . ${ZPM_DIR}/zpm run ${dotfiles_dir}
fi
${ZSHRC_END_SYMBOL}
EOF
}

check_zsh_exists || print_error "zsh is not installed"
check_curl_exists || print_error "curl is not installed"
check_git_exists || print_error "git is not installed"
if ! check_zpm_exists; then
  curl -fsSL -o install.sh https://raw.githubusercontent.com/zpm-shell/zpm/0.0.29/install.sh && source install.sh
fi

if ! check_zshrc; then
    add_zshrc
fi 