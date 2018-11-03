#!/usr/bin/env bash

echo "Enter the project root of the site you want to update, followed by [ENTER]:"
read docroot

script_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$script_dir" ]]; then script_dir="$PWD"; fi
source "$script_dir/parse-yaml.sh"
cd $script_dir
PATH_TO_DDEV=${PWD:0:${#PWD} - 8}
docpath="${PATH_TO_DDEV}/sites/$docroot"

if [ ! -d $docpath ]; then
  echo "Can't find that directory."
  exit 0
fi

echo "Enter the foldername in the artifacts directory whose files and database you want to load. [ENTER]:"
read artifact

if [ ! -d ${PATH_TO_DDEV}/artifacts/sites/$artifact ]; then
  echo "Can't find the artifacts directory."
  exit 0
fi

echo "Do you wish to move artifact files"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) FILES=true; break;;
        No ) FILES=false; break;;
    esac
done


if [ ${FILES} = true ]; then
    if [ ! -f ${PATH_TO_DDEV}/artifacts/sites/$artifact/files.tar.gz ]; then
      echo "Can't find the files archive in that artifact."
      exit 0
    fi
    gunzip ${PATH_TO_DDEV}/artifacts/sites/$artifact/files.tar.gz
    mkdir ${PATH_TO_DDEV}/artifacts/sites/$artifact/files
    tar -xf ${PATH_TO_DDEV}/artifacts/sites/$artifact/files.tar -C ${PATH_TO_DDEV}/artifacts/sites/$artifact/files

    if [ -d ${PATH_TO_DDEV}/artifacts/sites/$artifact/files ] && [ "$(ls -A ${PATH_TO_DDEV}/artifacts/sites/$artifact/files)" ]; then
        echo "untarring"
        if [ -d $docpath/web/sites/default/files ]; then
            echo "Delete $docpath/web/sites/default/files"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes ) echo "removing files"; sudo rm -r $docpath/web/sites/default/files; break;;
                    No ) FILES=false; break;;
                esac
            done
        fi

        if [ -d $docpath/web/sites/default ]  && [ ${FILES} = true ]; then
              echo "moving files"
              sudo mv ${PATH_TO_DDEV}/artifacts/sites/$artifact/files $docpath/web/sites/default
              echo "files moved"
        else
              rm -r ${PATH_TO_DDEV}/artifacts/sites/$artifact/files; echo $PWD;
              echo "Can't find the file path, or you cancelled."
        fi
    gzip ${PATH_TO_DDEV}/artifacts/sites/$artifact/files.tar
    else
        exit 0;
    fi
fi

echo "Do you wish to load the artifact db"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) DB=true; break;;
        No ) DB=false; break;;
    esac
done

if [ ${DB} = true ]; then
    if [ ! -f ${PATH_TO_DDEV}/artifacts/sites/$artifact/dump.sql.gz ]; then
      echo "Can't find the sql dump in that artifact."
      exit 0
    fi
    echo "loading db"
    gunzip ${PATH_TO_DDEV}/artifacts/sites/$artifact/dump.sql.gz
    if [ -f ${PATH_TO_DDEV}/artifacts/sites/$artifact/dump.sql ]; then
       cd ${PATH_TO_DDEV}/sites/$docroot/web
       drush sql-drop
       echo "Importing db"
       drush sql-cli < ${PATH_TO_DDEV}/artifacts/sites/$artifact/dump.sql
       echo "DB finished"
       gzip ${PATH_TO_DDEV}/artifacts/sites/$artifact/dump.sql
    fi
fi
