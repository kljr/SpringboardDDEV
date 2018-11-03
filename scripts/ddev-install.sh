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
    INCLUDE_DDEV=true
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) INCLUDE_DDEV=true; break;;
            No ) INCLUDE_DDEV=false; break;;
        esac
    done

    if [ ${INCLUDE_DDEV} = true ]; then
        cp ${PATH_TO_DDEV}/templates/bashrc_ddev $HOME/.bashrc_ddev
        sed -i '' -e "s|absolute_path_to_springboard_ddev|${PATH_TO_DDEV}|g"  $HOME/.bashrc_ddev
        cat ${PATH_TO_DDEV}/templates/bash_profile_ddev >> $HOME/.$profiletype
        source ~/.bash_profile
    fi;
fi

if [ -d $HOME/.drush ] && [ ! -f $HOME/.drush/sbvt.aliases.drushrc.php ]; then

    echo "Do you wish to copy Springboard DDEV's drush aliases to your $HOME/.drush folder?"
    INCLUDE_DDEV_DRUSH=true
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) INCLUDE_DDEV_DRUSH=true; break;;
            No ) INCLUDE_DDEV_DRUSH=false; break;;
        esac
    done

    if [ ${INCLUDE_DDEV_DRUSH} = true ]; then
        cp ${PATH_TO_DDEV}/templates/sbvt.aliases.drushrc.php $HOME/.drush/sbvt.aliases.drushrc.php
        sed -i '' -e "s|valet_domain|${valet_domain}|g"  $HOME/.drush/sbvt.aliases.drushrc.php
        sed -i '' -e "s|drush_alias_prefix|${drush_alias_prefix}|g"  $HOME/.drush/sbvt.aliases.drushrc.php
        sed -i '' -e "s|absolute_path_to_springboard_ddev_sites_directory|${PATH_TO_DDEV}/sites|g"  $HOME/.drush/sbvt.aliases.drushrc.php
    fi;
fi

if [ -d $HOME/.drush ] && [ -f $HOME/.drush/drushrc.php ]; then

    if [ ! -f $HOME/.config/springboard-ddev/drushrc.updated ]; then
        echo "Do you wish to update drushrc.php with Springboard DDEV's drush shell commands?"
        INCLUDE_DDEV_DRUSH_ALIAS=true
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) INCLUDE_DDEV_DRUSH_ALIAS=true; break;;
                No ) INCLUDE_DDEV_DRUSH_ALIAS=false; break;;
            esac
        done

        if [[ ${INCLUDE_DDEV_DRUSH_ALIAS} = true ]]; then
            cat ${PATH_TO_DDEV}/templates/drushrc >> $HOME/.drush/drushrc.php
            mkdir $HOME/.config/springboard-ddev
            touch $HOME/.config/springboard-ddev/drushrc.updated
        fi;
    fi;
fi

cd ${PATH_TO_DDEV}
if [ ! -d ${PATH_TO_DDEV}/vendor/jacksonriver/springboard-composer ]; then
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
