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

if [ ! -f $HOME/.bashrc_sbvt ] && [ "$profiletype" != "none" ]; then
    echo "Do you wish to update .$profiletype with an include for Springboard Valet's shell commands?"
    INCLUDE_SBVT=true
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) INCLUDE_SBVT=true; break;;
            No ) INCLUDE_SBVT=false; break;;
        esac
    done

    if [ ${INCLUDE_SBVT} = true ]; then
        cp ${PATH_TO_SBVT}/templates/bashrc_sbvt $HOME/.bashrc_sbvt
        sed -i '' -e "s|absolute_path_to_springboard_valet|${PATH_TO_SBVT}|g"  $HOME/.bashrc_sbvt
        cat ${PATH_TO_SBVT}/templates/bash_profile_sbvt >> $HOME/.$profiletype
        source ~/.bash_profile
    fi;
fi

if [ -d $HOME/.drush ] && [ ! -f $HOME/.drush/sbvt.aliases.drushrc.php ]; then

    echo "Do you wish to copy Springboard Valet's drush aliases to your $HOME/.drush folder?"
    INCLUDE_SBVT_DRUSH=true
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) INCLUDE_SBVT_DRUSH=true; break;;
            No ) INCLUDE_SBVT_DRUSH=false; break;;
        esac
    done

    if [ ${INCLUDE_SBVT_DRUSH} = true ]; then
        cp ${PATH_TO_SBVT}/templates/sbvt.aliases.drushrc.php $HOME/.drush/sbvt.aliases.drushrc.php
        sed -i '' -e "s|valet_domain|${valet_domain}|g"  $HOME/.drush/sbvt.aliases.drushrc.php
        sed -i '' -e "s|drush_alias_prefix|${drush_alias_prefix}|g"  $HOME/.drush/sbvt.aliases.drushrc.php
        sed -i '' -e "s|absolute_path_to_springboard_valet_sites_directory|${PATH_TO_SBVT}/sites|g"  $HOME/.drush/sbvt.aliases.drushrc.php
    fi;
fi

if [ -d $HOME/.drush ] && [ -f $HOME/.drush/drushrc.php ]; then

    if [ ! -f $HOME/.config/springboard-valet/drushrc.updated ]; then
        echo "Do you wish to update drushrc.php with Springboard Valet's drush shell commands?"
        INCLUDE_SBVT_DRUSH_ALIAS=true
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) INCLUDE_SBVT_DRUSH_ALIAS=true; break;;
                No ) INCLUDE_SBVT_DRUSH_ALIAS=false; break;;
            esac
        done

        if [[ ${INCLUDE_SBVT_DRUSH_ALIAS} = true ]]; then
            cat ${PATH_TO_SBVT}/templates/drushrc >> $HOME/.drush/drushrc.php
            mkdir $HOME/.config/springboard-valet
            touch $HOME/.config/springboard-valet/drushrc.updated
        fi;
    fi;
fi

if [ -d $HOME/.config/valet ] && [ ! -f $HOME/.config/valet/Drivers/SpringboardValetDriver.php ]; then
    cp ${PATH_TO_SBVT}/templates/SpringboardValetDriver.php $HOME/.config/valet/Drivers/SpringboardValetDriver.php
fi

cd ${PATH_TO_SBVT}
if [ ! -d ${PATH_TO_SBVT}/vendor/jacksonriver/springboard-composer ]; then
    $HOME/composer.phar about 2> /dev/null
    if [ $? -eq 0 ]; then
        $HOME/composer.phar install
        else
            $HOME/composer about 2> /dev/null
            if [ $? -eq 0 ]; then
                $HOME/composer install
            else
                /usr/local/bin/composer about 2> /dev/null
                if [ $? -eq 0 ]; then
                    /usr/local/bin/composer install
                else
                    echo "Could not find composer"
            fi;
        fi;
    fi;
fi;
