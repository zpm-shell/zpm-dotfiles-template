#!/usr/bin/env bash

TRUE=0
FALSE=1
dotfiles_repo="https://github.com/zpm-shell/zpm-dotfiles-template.git"
dotfiles_dir="${HOME}/.zpm-dotfiles"

##
# Check if zsh is installed
# @returnm {boolean} true if zsh is installed
##
function check_zsh_exists() {
    local hasZsh=$(command -v zsh)
    if [ -z "${hasZsh}" ]; then
        return ${FALSE}
    fi
    return ${TRUE}
}

##
# Check if zpm is installed
# @returnm {boolean} true if zpm is installed
##
function check_zpm_exists() {
    local hasZpm=$(command -v zpm)
    if [ -z "${hasZpm}" ]; then
        return ${FALSE}
    fi
    return ${TRUE}
}

##
# Check if git is installed
# @returnm {boolean} true if git is installed
##
function check_git_exists() {
    local hasGit=$(command -v git)
    if [ -z "${hasGit}" ]; then
        return ${FALSE}
    fi
    return ${TRUE}
}

##
# Check if curl is installed
# @returnm {boolean} true if curl is installed
##
function check_curl_exists() {
    local hasCurl=$(command -v curl)
    if [ -z "${hasCurl}" ]; then
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

ZSHRC_START_SYMBOL="# zpm load zpm-dotfiles"
ZSHRC_END_SYMBOL="# zpm end load zpm-dotfiles"

##
# check if the config to autoload the zpm dotfiles is already in the zshrc or not.
# @return {boolean} true if the config is already in the zshrc
##
function check_zshrc() {
    local hasConf=$(grep "${ZSHRC_START_SYMBOL}" ~/.zshrc)
    if [ -z "${hasConf}" ]; then
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
    . ${ZPM_DIR}/bin/zpm run -w ${dotfiles_dir} ${dotfiles_dir}/src/main.zsh
fi
${ZSHRC_END_SYMBOL}
EOF
}

##
# check if the zpm dotfiles is already installed
# @return {boolean} true if the zpm dotfiles is already installed
##
function check_zpm_dotfiles() {
    if [ -d "${dotfiles_dir}" ]; then
        return ${TRUE}
    fi
    return ${FALSE}
}

##
# install the zpm dotfiles
# @return {boolean} true if the zpm dotfiles is already installed
##
function install_zpm_dotfiles() {
    git clone  ${dotfiles_repo} ${dotfiles_dir}
}

##
# remove the config for the zpm dotfiles in the zshrc
##
function remove_zshrc_conf() {
    sed -i '' "/${ZSHRC_START_SYMBOL}/,/${ZSHRC_END_SYMBOL}/d" ~/.zshrc
}

check_zsh_exists || print_error "zsh is not installed"
check_curl_exists || print_error "curl is not installed"
check_git_exists || print_error "git is not installed"
if ! check_zpm_exists; then
  curl -fsSL -o install.sh https://raw.githubusercontent.com/zpm-shell/zpm/0.0.29/install.sh && source install.sh
fi

 check_zpm_dotfiles && print_error "zpm dotfiles is already installed"

 install_zpm_dotfiles
 
check_zshrc && remove_zshrc_conf

add_zshrc

[ -f install.sh ] && rm -f install.sh