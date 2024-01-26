#!/usr/bin/env zsh

import github.com/zpm-shell/zpm/src/utils/bin.zsh --as bin

function load() {
    local jq=$( call bin.jq )
    local zpmPackageJson=${G_DOTFILES_ROOT}/zpm-package.json
    local theme=$( $jq -j "$( cat ${zpmPackageJson} )" -q theme.repository -t get )
    local version=$( $jq -j "$( cat ${zpmPackageJson} )" -q "dependencies.${theme//\./\\.}" -t get )
    local themeName=${theme##*/}
    local themeEntryFile=${ZPM_DIR}/packages/${theme}/${version}/${themeName}.zsh-theme
    local hasDest=$( $jq -j "$( cat ${zpmPackageJson} )" -q "theme.dest" -t has )
    local hasConf=$( $jq -j "$( cat ${zpmPackageJson} )" -q "theme.conf" -t has )
    if [[ ${hasDest} == 'true' ]]; then
        local dest=$( $jq -j "$( cat ${zpmPackageJson} )" -q "theme.dest" -t get )
        local conf=$( $jq -j "$( cat ${zpmPackageJson} )" -q "theme.conf" -t get )
        # remove the cofniguration file.
        eval "[[ -f ${dest} ]] && rm -rf ${dest}"
        conf=${G_DOTFILES_ROOT}/${conf}
        conf=${conf:A}
        eval "ln -s "${conf}" "${dest}""
    fi
    if [[ -f $themeEntryFile ]]; then
        source $themeEntryFile
    fi
}