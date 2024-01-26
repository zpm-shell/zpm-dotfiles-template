#!/usr/bin/env zsh

import github.com/zpm-shell/zpm/src/utils/bin.zsh --as bin

function load() {
    local jq=$( call bin.jq )

    # 1 get the plugin names from zpm-package.json with the field `customPlugins`.
    local plugins=()
    local packageData="$( cat ${G_DOTFILES_ROOT}/zpm-package.json )"
    local hasPlugin=$( $jq -q customPlugins -j "${packageData}" -t has )
    [[ ${hasPlugin} == 'false' ]] && return ${TRUE}
    local size=$( $jq -q customPlugins -j "${packageData}" -t size )
    [[ ${size} -eq 0 ]] && return ${TRUE}
    echo  "size: ${size}"
    local i=0;
    while [[ $i -lt ${size} ]]; do
        local plugin=$( $jq -q customPlugins.$i -j "${packageData}" -t get )
        plugins+=( "${plugin}" )
        (( i++ ))
    done

    # 2 load the plugins
    i=1
    while [[ $i -le ${#plugins[@]} ]]; do
        # 2.1 check the plugin is installed or not.
        local plugin=${plugins[$i]}
        local query="dependencies.${plugin//\./\\.}"
        local hasDependence=$( $jq -q ${query} -j "${packageData}" -t has)
        if [[ ${hasDependence} == 'false' ]]; then
            throw \
            --error-message "the plugin ${plugin} was not found.please try the cmd: zpm install ${plugin} to install." \
            --exit-code 1
        fi

        # 2.2 get the version of the plugin.
        local version=$( $jq -q ${query} -j "${packageData}" -t get )
        # 2.3 get the entry file name of the plugin.like: get the name zsh-syntax-highlighting in path/to/zsh-syntax-highlighting
        local entryFile=${ZPM_DIR}/packages/${plugin}/${version}/${plugin##*/}.plugin.zsh
        if [[ -f ${entryFile} ]]; then
            source ${entryFile}
        else
            throw \
            --error-message "the entry file ${entryFile} was not found for the plugin ${plugin}." \
            --exit-code 1
        fi

        (( i++ ))
    done
}