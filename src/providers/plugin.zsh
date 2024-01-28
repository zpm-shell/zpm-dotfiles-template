#!/usr/bin/env zsh

import github.com/zpm-shell/zpm/src/utils/bin.zsh --as bin

function load() {
    local jq=$( call bin.jq )

    # 1 get the plugin names from zpm-package.json with the field `plugins`.
    local plugins=()
    local packageData="$( cat ${G_DOTFILES_ROOT}/zpm-package.json )"
    local hasPlugin=$( $jq -q plugins -j "${packageData}" -t has )
    [[ ${hasPlugin} == 'false' ]] && return ${TRUE}
    local size=$( $jq -q plugins -j "${packageData}" -t size )
    [[ ${size} -eq 0 ]] && return ${TRUE}
    local i=0;
    while [[ $i -lt ${size} ]]; do
        local plugin=$( $jq -q plugins.$i -j "${packageData}" -t get )
        # if the plugin is a string, then source it.
        local pluginConfType=$( $jq -q plugins.$i -j "${packageData}" -t type )
        if [[ ${pluginConfType} == 'string' ]]; then
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
            (( i++ )) && continue
        fi

        # if the plugin is a object, and then load the plugin from the object config like:
        # {
        #   "name": "github.com/ohmyzsh/ohmyzsh", # <-- the plugin name was required.
        #   "config": "./src/config/oh-my-zsh.zsh" # <-- the config path was optional. if the config was set, then load the config file.
        #   "entry": "oh-my-zsh.sh", # <-- the entry was optional. if the entry was not set, then the entry will be set to ohmyzsh.plugin.zsh
        #   "subPlugin": { # <-- the subPlugin was optional.
        #     "path": "plugins", # <-- the path was optional. if the path was not set, then the default value was ''
        #     "name": [ "git", "z" ] # <-- the name was required.
        #   }
        # }
        if [[  ${pluginConfType} == 'object' ]]; then
            # check the plugin config was valid or not.
            # 1 check the plugin name was set or not.
            local hasName=$( $jq -q name -j "${plugin}" -t has )
            if [[ ${hasName} == 'false' ]]; then
                throw \
                --error-message "the plugin name was required in config ${plugin}" \
                --exit-code 1
            fi
            # 2 check the plugin name was installed or not.
            local pluginName=$( $jq -q name -j "${plugin}" -t get )
            local query="dependencies.${pluginName//\./\\.}"
            local hasDependence=$( $jq -q ${query} -j "${packageData}" -t has)
            local notFoundMessage="the plugin ${pluginName} was not found.please try the cmd: zpm install ${pluginName} to install."
            if [[ ${hasDependence} == 'false' ]]; then
                throw --error-message "${notFoundMessage}" --exit-code 1
            fi
            local version=$( $jq -q ${query} -j "${packageData}" -t get )
            local pluginPath=${ZPM_DIR}/packages/${pluginName}/${version}
            if [[ ! -d ${pluginPath} ]]; then
                throw --error-message "${notFoundMessage}" --exit-code 1
            fi
            # 3 check the plugin entry was set or not.
            local hasEntry=$( $jq -q entry -j "${plugin}" -t has )
            local entry=${pluginName##*/}.plugin.zsh
            if [[ ${hasEntry} == 'true' ]]; then
                entry=$( $jq -q entry -j "${plugin}" -t get )
            fi
            # 3.1 check the entry file was exist or not.
            entry=${pluginPath}/${entry}
            if [[ ! -f ${entry} ]]; then
                throw --error-message "the entry file ${entry} was not found for the plugin ${pluginName}." --exit-code 1
            fi
            # 4 check the plugin subPlugin was set or not.
            local hasSubPlugin=$( $jq -q subPlugin -j "${plugin}" -t has )
            local subPluginPath=''
            local subPluginFiles=()
            if [[ ${hasSubPlugin} == 'true' ]]; then
                # 4.1 check the plugin subPlugin path was set or not.
                local hasSubPluginPath=$( $jq -q subPlugin.path -j "${plugin}" -t has )
                if [[ ${hasSubPluginPath} == 'true' ]]; then
                    subPluginPath=$( $jq -q subPlugin.path -j "${plugin}" -t get )
                fi
                # 4.2 check the plugin subPlugin name was set or not.
                local hasSubPluginName=$( $jq -q subPlugin.name -j "${plugin}" -t has )
                if [[ ${hasSubPluginName} == 'false' ]]; then
                    local errorMsg="the plugin subPlugin.name was required in config ${plugin}"
                    throw --error-message "${errorMsg}" --exit-code 1
                fi
                # 4.3 check the plugin subPlugin name was object or not.
                local subPluginNamesType=$( $jq -q subPlugin.name -j "${plugin}" -t type )
                if [[ ${subPluginNamesType} != 'object' ]]; then
                    local errorMsg="the plugin subPlugin.name was required as a array in config ${plugin}"
                    throw --error-message "${errorMsg}" --exit-code 1
                fi
                # 4.4 check every subPlugin name was string or not.
                local subPluginNamesSize=$( $jq -q subPlugin.name -j "${plugin}" -t size )
                local subPluginNamesIndex=0
                while [[ ${subPluginNamesIndex} -lt ${subPluginNamesSize} ]]; do
                    local subPluginName=$( $jq -q subPlugin.name.${subPluginNamesIndex} -j "${plugin}" -t get )
                    if [[ $( $jq -q subPlugin.name.${subPluginNamesIndex} -j "${plugin}" -t type ) != 'string' ]]; then
                        local errorMsg="the plugin subPlugin.name.${subPluginNamesIndex} was required as a string in config ${plugin}"
                        throw --error-message "${errorMsg}" --exit-code 1
                    fi
                    local subPluginFile=${pluginPath}/${subPluginPath}/${subPluginName}/${subPluginName}.plugin.zsh
                    subPluginFile=${subPluginFile:A}
                    if [[ ! -f ${subPluginFile} ]]; then
                        local errorMsg="the subPlugin file ${subPluginFile} was not found for the plugin ${pluginName} in config ${plugin}."
                        throw --error-message "${errorMsg}" --exit-code 1
                    fi
                    subPluginFiles+=( "${subPluginFile}" )
                    (( subPluginNamesIndex++ ))
                done
            fi
        fi
        local configFile=''
        # 5 check the config was set or not.
        local hasConfig=$( $jq -q config -j "${plugin}" -t has )
        if [[ ${hasConfig} == 'true' ]]; then
            configFile=$( $jq -q config -j "${plugin}" -t get )
            configFile=${G_DOTFILES_ROOT}/${configFile}
            if [[ ! -f ${configFile} ]]; then
                local errorMsg="the config file ${configFile} was not found for the plugin ${pluginName} in the config ${plugin}."
                throw --error-message "${errorMsg}" --exit-code 1
            fi
            configFile=${configFile:A}
        fi
        
        # 6　load the plugin
        # 6.1 load the plugin config
        [[ -f ${configFile} ]] && source ${configFile}
        # 6.2 load the plugin
        source ${entry}
        # 6.3 load the subPlugin
        for subPluginFile in ${subPluginFiles[@]}; do
            source ${subPluginFile}
        done

        (( i++ ))
    done
}