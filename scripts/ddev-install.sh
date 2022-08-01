#!/usr/bin/env bash
export COMPOSER_PROCESS_TIMEOUT=600;

# Deal with relative paths
script_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$script_dir" ]]; then script_dir="$PWD"; fi

source "$script_dir/parse-yaml.sh"
cd $script_dir
PATH_TO_DDEV=${PWD:0:${#PWD} - 8}
DDEV_SITES=${PATH_TO_DDEV}/sites
export PATH=$PWD:$PATH

profiletype="none"
if [ -f $HOME/.bash_profile ]; then
    profiletype="bash_profile"
    else
        if [ -f $HOME/.bash_login ]; then
            profiletype="bash_login"
            else
                if [ -f $HOME/.profile ]; then
                    profiletype="profile"

        fi;
    fi;
fi;

if [ ! -f $HOME/.bashrc_ddev ] && [ "$profiletype" != "none" ]; then
    echo "Do you wish to update .$profiletype with an include for Springboard DDEV's shell commands?"
    INCLUDE_DDEV=false
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) INCLUDE_DDEV=true; break;;
            No ) INCLUDE_DDEV=false; break;;
        esac
    done

    if [ ${INCLUDE_DDEV} = true ]; then
        cp ${PATH_TO_DDEV}/templates/bashrc_ddev $HOME/.bashrc_ddev
        if [[ "$OSTYPE" == "darwin"* ]]; then
          sed -i '' -e "s|absolute_path_to_springboard_ddev|${PATH_TO_DDEV}|g"  $HOME/.bashrc_ddev
        else
          sed -i -e "s|absolute_path_to_springboard_ddev|${PATH_TO_DDEV}|g"  $HOME/.bashrc_ddev
        fi;
        cat ${PATH_TO_DDEV}/templates/bash_profile_ddev >> $HOME/.$profiletype
    fi;
fi

if [ -d $HOME/.drush ] && [ ! -f $HOME/.drush/dd.aliases.drushrc.php ]; then
    INCLUDE_DDEV_DRUSH=true
    PS3="Do you wish to copy Springboard DDEV's drush aliases to your ${HOME}/.drush folder?"
    select yn in Yes No; do
        case $yn in
            Yes ) INCLUDE_DDEV_DRUSH=true; break;;
            No ) break;;
        esac
    done

    if [ ${INCLUDE_DDEV_DRUSH} = true ]; then
        cp ${PATH_TO_DDEV}/templates/dd.aliases.drushrc.php $HOME/.drush/dd.aliases.drushrc.php
        if [[ "$OSTYPE" == "darwin"* ]]; then
           sed -i '' -e "s|absolute_path_to_springboard_ddev|${PATH_TO_DDEV}|g"  $HOME/.drush/dd.aliases.drushrc.php
        else
           sed -i -e "s|absolute_path_to_springboard_ddev|${PATH_TO_DDEV}|g"  $HOME/.drush/dd.aliases.drushrc.php
        fi;
    fi;
fi;
