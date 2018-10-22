#!/usr/bin/env bash
export COMPOSER_PROCESS_TIMEOUT=600;

# Find the absolute path to PSringboard Valet
script_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$script_dir" ]]; then script_dir="$PWD"; fi
source "$script_dir/parse-yaml.sh"
cd $script_dir
PATH_TO_SBVT=${PWD:0:${#PWD} - 8}
SBVT_SITES=${PATH_TO_SBVT}/sites
export PATH=$PWD:$PATH

cd ${PATH_TO_SBVT}

LOCAL_CONFIG_FILE=${PATH_TO_SBVT}/config/local.config.yml
eval $(parse_yaml ${LOCAL_CONFIG_FILE})

# Build the sites defined in Yaml.
if [ ! -d ${PATH_TO_SBVT}/sites ]; then
    mkdir ${PATH_TO_SBVT}/sites
fi;

for project in ${!projects__projectroot*}
    do

        # Get the docroot directory name.
        directory=${!project}
        directory=${directory/__/\/}

        if [ ! -d ${PATH_TO_SBVT}/sites/$directory ]; then
            echo "Building new site into directory $directory"
            read -p "Repository name? (default: springboard-composer): " repo
            [ -z "${repo}" ] && repo='springboard-composer'
            if [ $repo = 'springboard-composer' ]; then
                if [ -d ${PATH_TO_SBVT}/vendor/jacksonriver/springboard-composer ]; then
                    cp -R ${PATH_TO_SBVT}/vendor/jacksonriver/springboard-composer sites/$directory
                fi;
            else
                git clone git@github.com:JacksonRiver/$repo.git ${PATH_TO_SBVT}/sites/$directory
            fi;

            cd ${PATH_TO_SBVT}/sites/$directory;
            read -p "Branch name? (default: develop): " branch
            [ -z "${branch}" ] && branch='develop'
            git pull
            git checkout $branch
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
        cd ${SBVT_SITES}/$directory/web;
        if [ ! -f ${SBVT_SITES}/$directory/web/sites/default/settings.php ]; then
            cp ${PATH_TO_SBVT}/templates/settings.php ${SBVT_SITES}/$directory/web/sites/default/settings.php
            sed -i '' -e "s/sbvtuser/${mysql_user}/g" ${SBVT_SITES}/$directory/web/sites/default/settings.php
            sed -i '' -e "s/sbvtpass/${mysql_password}/g" ${SBVT_SITES}/$directory/web/sites/default/settings.php
            sed -i '' -e "s/sbvtdb/${directory}/g" ${SBVT_SITES}/$directory/web/sites/default/settings.php
            sed -i '' -e "s/'.sbvt.test'/'.${directory}.test'/g" ${SBVT_SITES}/$directory/web/sites/default/settings.php
        fi;

        $(mysql -u${mysql_user} -p${mysql_password} -e "exit") || exit 1;
        default_db_populated=$(mysql -u${mysql_user} -p${mysql_password} $directory -e 'show tables;' | grep system );
        if [ ! $default_db_populated ]; then
            drush sql-create -y
            gunzip < ${SBVT_SITES}/$directory/.circleci/springboard.sql.gz | drush sql-cli
            drush vset encrypt_secure_key_path ${SBVT_SITES}/$directory/sites/default/files/
            drush upwd admin --password=admin -y
        fi;
        # Create a sustainer.key file in sites/default/files
        if [ ! -f ${SBVT_SITES}/$directory/sites/default/files ]; then
            mkdir -p ${SBVT_SITES}/$directory/sites/default/files
        fi
        if [ ! -e ${SBVT_SITES}/$directory/sites/default/files/sustainer.key ]; then
          echo $directory.test > ${SBVT_SITES}/sbvt/sites/default/files/sustainer.key
        fi
        echo "23fe4ba7660eba65c8634fd41e18f2300eb2a1bcbbc6e81f1bde82448016890" > ${SBVT_SITES}/$directory/sites/default/files/encrypt_key.key

        if [ -d ${SBVT_SITES}/$directory ] && [ ! -f ${SBVT_SITES}/$directory/tests/codeception.yml ]; then
            \cp ${PATH_TO_SBVT}/templates/codeception/codeception.yml ${SBVT_SITES}/$directory/tests
            sed -i '' -e "s/sbvtdb/${directory}/g" ${SBVT_SITES}/$directory/tests/codeception.yml
            sed -i '' -e "s/sbvtuser/${mysql_user}/g" ${SBVT_SITES}/$directory/tests/codeception.yml
            sed -i '' -e "s/sbvtpass/${mysql_pass}/g" ${SBVT_SITES}/$directory/tests/codeception.yml

        fi;
        if [ -d ${SBVT_SITES}/$directory ] && [ ! -f ${SBVT_SITES}/$directory/tests/functional.suite.yml ]; then
            \cp ${PATH_TO_SBVT}/templates/codeception/functional.suite.yml ${SBVT_SITES}/$directory/tests
            sed -i '' -e "s/sbvt\.test/${directory}/g" ${SBVT_SITES}/$directory/tests/functional.suite.yml
            sed -i '' -e "s/sbvt/${directory}/g" ${SBVT_SITES}/$directory/tests/functional.suite.yml
        fi;
        if [ -d ${SBVT_SITES}/$directory ] && [ ! -f ${SBVT_SITES}/$directory/tests/acceptance.suite.yml ]; then
            \cp ${PATH_TO_SBVT}/templates/codeception/acceptance.suite.yml ${SBVT_SITES}/$directory/tests
        fi;
        if [ ! -d ~/.config/valet/Sites/$directory ]; then
          ln -s ${SBVT_SITES}/$directory/web ~/.config/valet/Sites/$directory
        fi;
    done
