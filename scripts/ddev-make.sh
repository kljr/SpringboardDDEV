#!/usr/bin/env bash
export COMPOSER_PROCESS_TIMEOUT=600;

# Find the absolute path to PSringboard Valet
script_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$script_dir" ]]; then script_dir="$PWD"; fi
source "$script_dir/parse-yaml.sh"
cd $script_dir
PATH_TO_DDEV=${PWD:0:${#PWD} - 8}
export PATH=$PWD:$PATH

cd ${PATH_TO_DDEV}

LOCAL_CONFIG_FILE=${PATH_TO_DDEV}/config/local.config.yml
eval $(parse_yaml ${LOCAL_CONFIG_FILE})

# Build the sites defined in Yaml.
if [ ! -d ${PATH_TO_DDEV}/sites ]; then
    mkdir ${PATH_TO_DDEV}/sites
fi;
#( set -o posix ; set ) | more

for project in ${!projects__projectroot*}
    do

        # Get the docroot directory name.
        directory=${!project}
        directory=${directory/__/\/}

        if [ ! -d ${PATH_TO_DDEV}/sites/$directory ]; then
            echo "Building new site into directory $directory"
            read -p "Repository name? (default: springboard): " repo
            [ -z "${repo}" ] && repo='springboard'
            if [ $repo = 'springboard' ]; then
                if [ -d ${PATH_TO_DDEV}/vendor/jacksonriver/springboard ]; then
                    cd ${PATH_TO_DDEV}/vendor/jacksonriver/springboard
                    git pull
                    cp -R ${PATH_TO_DDEV}/vendor/jacksonriver/springboard ${PATH_TO_DDEV}/sites/$directory
                fi;
            else
                git clone git@gitlab.com:togetherwork/mission/jacksonriver/springboard/$repo.git ${PATH_TO_DDEV}/sites/$directory
            fi;

            cd ${PATH_TO_DDEV}/sites/$directory;
            read -p "Branch name? (default: develop): " branch
            [ -z "${branch}" ] && branch='develop'
            git checkout $branch
            git pull
            $HOME/composer.phar about 2> /dev/null
            if [ $? -eq 0 ]; then
                $HOME/composer.phar run-script dev-update
                else
                    $HOME/composer about 2> /dev/null
                    if [ $? -eq 0 ]; then
                        $HOME/composer run-script dev-update
                    else
                        /usr/local/bin/composer about 2> /dev/null
                        if [ $? -eq 0 ]; then
                            /usr/local/bin/composer run-script dev-update
                        else
                            echo "Could not find composer"
                    fi;
                fi;
            fi;
        fi;
    done
