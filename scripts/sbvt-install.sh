#!/usr/bin/env bash
export COMPOSER_PROCESS_TIMEOUT=600;

# Deal with relative paths

script_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$script_dir" ]]; then script_dir="$PWD"; fi

source "$script_dir/parse-yaml.sh"
cd $script_dir
PATH_TO_SBVT=${PWD:0:${#PWD} - 8}
SBVT_SITES=${PATH_TO_SBVT}/sites
export PATH=$PWD:$PATH

if [ -f $HOME/.bash_profile ] && [ ! -f $HOME/.bashrc_sbvt ]; then

    echo "Do you wish to update .bash_profile with an include for Springboard Valet's shell commands?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) INCLUDE_SBVT=true; break;;
            No ) INCLUDE_SBVT=false; break;;
        esac
    done

    if [ ${INCLUDE_SBVT} = true ]; then
        cp ${PATH_TO_SBVT}/templates/bashrc_sbvt $HOME/.bashrc_sbvt
        sed -i '' -e "s|absolute_path_to_springboard_valet|${PATH_TO_SBVT}|g"  $HOME/.bashrc_sbvt
        cat ${PATH_TO_SBVT}/templates/bash_profile_sbvt >> $HOME/.bash_profile
    fi;
fi

if [ -d $HOME/.drush ] && [ ! -f $HOME/.drush/sbvt.aliases.drushrc.php ]; then

    echo "Do you wish to copy Springboard Valet's drush aliases to your $HOME/.drush folder?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) INCLUDE_SBVT_DRUSH=true; break;;
            No ) INCLUDE_SBVT_DRUSH=false; break;;
        esac
    done

    if [ ${INCLUDE_SBVT_DRUSH} = true ]; then
        cp ${PATH_TO_SBVT}/templates/sbvt.aliases.drushrc.php $HOME/.drush/sbvt.aliases.drushrc.php
        sed -i '' -e "s|absolute_path_to_springboard_valet_sites_directory|${PATH_TO_SBVT}/sites|g"  $HOME/.drush/sbvt.aliases.drushrc.php
    fi;
fi

if [ -d $HOME/.drush ] && [ -f $HOME/.drush/drushrc.php ]; then

    echo "Do you wish to update drushrc.php with Springboard Valet's drush shell commands?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) INCLUDE_SBVT_DRUSH_ALIAS=true; break;;
            No ) INCLUDE_SBVT_DRUSH_ALIAS=false; break;;
        esac
    done

    if [[ ${INCLUDE_SBVT_DRUSH_ALIAS} = true ]]; then
        cat ${PATH_TO_SBVT}/templates/drushrc >> $HOME/.drush/drushrc.php
    fi;
fi

