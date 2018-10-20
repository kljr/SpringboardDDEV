#!/usr/bin/env bash
script_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$script_dir" ]]; then script_dir="$PWD"; fi
source "$script_dir/parse-yaml.sh"
cd $script_dir
PATH_TO_SBVT=${PWD:0:${#PWD} - 8}
echo "Enter the project root directory of the site whose db you wish to replace [ENTER]:"
read dir
sa=@${dir}
drush $sa dm-wipe -y
drush $sa updb -y
drush $sa vset encrypt_secure_key_path ${PATH_TO_SBVT}/${dir}/web/sites/default/files/
drush $sa cc all

