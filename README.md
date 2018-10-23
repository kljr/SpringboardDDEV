# Springboard Valet

A Springboard development environment built with Composer, Laravel Valet,
 Codeception and Bash.

Provides multiple fully-configured Springboard sites - each with working 
copies of the Springboard repositories - and quick, pain-free 
provisioning, management and updates.

## Prerequisites

- MacOS
- Composer.phar installed globally, preferably renamed and moved 
to /usr/local/bin/composer.
- Drush 8 installed globally (see Drush notes below)
- Bash
- Homebrew

# Usage

1. Install Homebrew, or update Homebrew to the latest version using 
`brew update`.

2. Install PHP 7.1 using Homebrew via `brew install php@7.1`. Then
you'll need to link php71 with the --force option. `brew link php@7.1 --force`

    Springboard is 
not compatible with PHP 7.2, so you'll need to remove that if you 
already have it linked: `brew remove php@7.2` A restart may be required
to completely remove 7.2 if you already have Laravel Valet installed.

3. Install Valet with Composer via `composer global require laravel/valet`. 
Make sure the ~/.composer/vendor/bin directory is in your system's 
"PATH".

4. Run the `valet install` command. This will configure and install Valet 
and DnsMasq, and register Valet's daemon to launch when your system 
starts.

6. Clone this repository, then, from the repository root folder, 
run `scripts/sbvt-install.sh`  and follow the prompts. 
This script updates your drush and bash 
configuration after you confirm the changes. 

    You can review the changes by looking at the files in the /templates 
directory: bashrc_sbvt, bash_profile_sbvt, sbvt.aliases.drushrc.php 
and drushrc.

    If you don't want to automatically install the shell 
commands and drush aliases, you'll need to manually copy the files 
from the templates directory to the correct locations.

8. Run `composer install` from the Springboard Valet root folder. This will
pull down Springboard-Composer into your vendor folder.

7. Copy `example.local.config.yml` to `local.config.yml` and modify it to
match your mySQL configuration. Define a project following the example
project definitions, then run `sbvt-make` 
(or scripts/sbvt-make.sh). Follow the prompts to install the projects 
you defined in the yaml config.

After the initial install, if you want to create additional Springboard 
sites, update local.config.yml with your new project info. Then 
run `sbvt-make` (or scripts/make-sbvt.sh).

Laravel Valet by default serves all sites with the ".test" domain. 
Springboard Valet serves all sites at [projectroot].test. Configuring 
 Valet to serve a different top-level domain will break integration
 with Springboard Valet.
 
## What does Springboard Valet do?

* Downloads Springboard-Composer and its vendor dependencies.
* Creates and manages multiple virtual hosts and site databases.
* Configures the codeception tests to work out of the box.
* Automates replacing generic site databases and file assets with
reference site assets.
* Configures encrypt and sustainer keys.
* Automates replacing any site database with a fresh copy of QA master.
* Provides shell aliases and functions to quickly navigate the directory
hierarchy and perform tasks.
* Creates Drush aliases which match your project_root folder name:
`drush @sbvt-`[`project_root_folder_name`].

## Useful shell aliases and functions

The install script activates custom shell commands, drush shell aliases,
and bash aliases to project management.

> Directory switching

* `sbvt` - Go to Springboard Valet install directory.
* `cdv [project_root_folder_name/path]` - switch to project_root_folder_name or any path in a 
project_root_folder_name.
* `cdw [project_root_folder_name]` - switch to the web directory of project_root_folder_name.
* `cdvm [project_root_folder_name]` - switch to the Springboard modules directory 
of site.
* `cdvt [project_root_folder_name]` - switch to the Springboard themes directory 
of site.
* `cdvl [project_root_folder_name]` - switch to the libraries directory of site.
* If you're already in a site directory context, the above commands will
work without arguments.

>  Managing sites

* `sbvt-make` - create new springboard site installations based on 
local.config.yml settings. The command will prompt you for the 
springboard version.
* `sbvt-prep [project_root_folder_name]` - Installs admin_menu, 
admin_menu_toolbar, devel, views_ui, module_filter, token_filter, and springboard_token
modules. Turns off caches and aggregations, and configures devel error 
settings. When executed from inside a project folder hierarchy, the 
projectroot argument is not needed.

> DB

* `sbvt-wipe` - prompts for a project root directory,  replaces the
 associated db with master QA db. Resets the encryption key path to the 
 local default.
* `sbvt-wipe-clean` - prompts for a project root directory, replaces
 the associated db with a clean springboard db. Resets the encryption 
 key path to the local default.

## Updating virtual hosts and adding new sites.

If you want to add a new site to Springboard Valet, then you need to:
* Define the project in local.config.yml
* Run `sbvt-make` (or scripts/sbvt-make.sh)

Adding too many sites at once can cause PHP timeouts, so be reasonable.

## Updating existing Springboard sites

Updating sites is easy with springboard-composer, and not covered 
here, but if you want to replace all code in a site and re-create it, 
just delete the site root folder, and run `sbvt-make`.  If you delete
the database prior to that, it will be recreated, otherwise the same
db will be used.

## Replacing default content with reference databases and files

If you place gzipped files and dbs in the `artifacts/sites` folder 
according to the instructions in the [readme,](https://github.com/kljr/springboard-valet/blob/master/artifacts/README.md)
you can automatically replace any site's files and/or database with those items
by running `sbvt-art` (or scripts/sbvt-atrifact.sh )

## Running tests

Configuration templates for codeception are copied from the
templates/tests directory into each sites 'tests' directory. They
should be ready to go. 

Some tests use mailhog to test email functions - you'll want to install
 mailhog using homebrew:
 * `brew update && brew install mailhog`
 * `brew services start mailhog`
 * Access mailhog at http://127.0.0.1:8025.

To start tests, move into the tests directory and then
 `vendor/bin/codecept run`
 
To wipe and reload the db:

* To use the QA master db: `sbvt-wipe` (scripts/wipe-test-db.sh)
* To use make a clean springboard db: `sbvt-wipe-clean` (scripts/wipe-test-db-clean.sh) 
* To use any other db, follow the instruction for loading artifacts.

## Drush global install

You could install Drush globally with Composer (`composer require 
global drush/drush`), but that is likely to lead to conflicts
if you have other global projects with conflicting dependencies.

Instead use [cgr](https://github.com/consolidation/cgr) to manage all 
your global packages (requires that composer be renamed from 
"composer.phar" to "composer" and installed globally, preferably 
as /usr/local/bin/composer).

Or take the steps below to manually install drush globally:

    php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > drush
    php drush core-status
    chmod +x drush
    sudo mv drush /usr/local/bin
