#!/usr/bin/env bash

script_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$script_dir" ]]; then script_dir="$PWD"; fi

source "$script_dir/parse-yaml.sh"
cd $script_dir
PATH_TO_SBVT=${PWD:0:${#PWD} - 8}
SBVT_SITES=${PATH_TO_SBVT}/sites

if [ ! -d ${PATH_TO_SBVT}/vendor/jacksonriver/springboard-composer/vendor ]; then
    cd ${PATH_TO_SBVT}/vendor/jacksonriver/springboard-composer
    git pull
    $HOME/composer.phar about 2> /dev/null
    if [ $? -eq 0 ]; then
        $HOME/composer.phar run-script dev-install
        else
            $HOME/composer about 2> /dev/null
            if [ $? -eq 0 ]; then
                $HOME/composer run-script dev-install
            else
                /usr/local/bin/composer about 2> /dev/null
                if [ $? -eq 0 ]; then
                    /usr/local/bin/composer run-script dev-install
                else
                    echo "Could not find composer"
            fi;
        fi;
    fi;
fi;

printf "\n\n Springboard Valet is installed.\n\n"
printf "Run the \"sbvt-make\" command to install Springboard.\n\n"
