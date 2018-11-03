#!/usr/bin/env bash
script_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$script_dir" ]]; then script_dir="$PWD"; fi

source "$script_dir/parse-yaml.sh"
cd $script_dir
PATH_TO_SBVT=${PWD:0:${#PWD} - 8}

echo "Enter the project root directory of the site whose db you wish to replace [ENTER]:"
read dir

cd ${PATH_TO_SBVT}/sites/$dir/web
ddev import-db --src=${PATH_TO_SBVT}/sites/${dir}/.circleci/springboard.sql.gz | drush sql-cli
