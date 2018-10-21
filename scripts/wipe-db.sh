#!/usr/bin/env bash
script_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$script_dir" ]]; then script_dir="$PWD"; fi

source "$script_dir/parse-yaml.sh"
cd $script_dir
PATH_TO_SBVT=${PWD:0:${#PWD} - 8}

echo "Enter the project root directory of the site whose db you wish to replace [ENTER]:"
read dir

cd ${PATH_TO_SBVT}/sites/$dir/web
drush  sql-drop -y
gunzip < ${PATH_TO_SBVT}/sites/${dir}/.circleci/springboard.sql.gz | drush sql-cli
drush updb -y
drush upwd admin --password=admin -y
drush vset encrypt_secure_key_path ${PATH_TO_SBVT}/sites/${dir}/web/sites/default/files/
drush cc all
chmod 775 ${PATH_TO_SBVT}/sites/${dir}/web/sites/default