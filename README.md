# Springboard Valet

A Springboard development environment built with Composer, Codeception, Laravel Valet and Bash.

Provides multiple fully-configured Springboard sites - each with working copies
of the Springboard repositories - and quick, pain-free provisioning, management and updates.

## Prerequisites

- MacOS
- Composer.phar installed globally, preferably renamed and moved to /usr/local/bin/composer.
- Drush 8 installed globally (see Drush notes below)
- Bash
- Homebrew

# Usage

Install Homebrew, or update Homebrew to the latest version using `brew update`.

Install PHP 7.1 using Homebrew via brew install php@7.1. Springboard is not compatible with PHP 7.2, so you'll need to remove that if you have it linked.

Install Valet with Composer via `composer global require laravel/valet`. Make sure the ~/.composer/vendor/bin directory is in your system's "PATH".

Run the `valet install` command. This will configure and install Valet and DnsMasq, and register Valet's daemon to launch when your system starts.

Then clone this repository.

Copy `example.local.config.yml` to `local.config.yml`.

Run `composer update` from inside the repository folder

Copy the contents of `templates/bashrc` to your .bashrc file,
and set the correct path for the PATH_TO_SB_VALET constant. This will provide the
aliases and shortcuts that make it easier to manage Springboard Valet
and navigate among multiple sites. 

After the initial install, if you want to create additional Springboard sites besides the two
default sites, update local.config.yml with your new site info.
 Then run `scripts/make-sbvt.sh` (alias 'sbvt-make')
 
## What does Springboard Valet do?

* Downloads Springboard-Composer and its vendor dependencies.
* Creates and manages multiple virtual hosts and site databases.
* Allows sites to be automatically installed in
sites/{projectroot}, with a projectroot you define in config/local.config.yml.
* Configures the acceptance tests to work out of the box.
* Automates replacing generic site databases and file assets with
reference site assets.
* Automates replacing any site database with a fresh copy of QA master.
* Provides a Drush alias to quickly install and configure developer
modules: `drush dm-prep` installs admin_menu, module_filter, and devel,
and disables toolbar menu, configures devel and the views admin UI, and
sets the admin password to "admin".
* Provides shell aliases and functions to quickly navigate the directory hierarchy and perform tasks.
* Creates Drush aliases which match your project_root folder name: `drush @`[`project_root`], allowing you to
keep your aliases short and simple.

## Updating virtual hosts and adding new sites.

If you want to add a new site to a previously provisioned Springboard Valet,
then you need to:
* Define the project in local.config.yml
* Run `scripts/make-sbvt.sh` (alias sbvt-make)

Adding too many sites at once can cause PHP timeouts, so be reasonable.

## Updating existing Springboard sites

* Updating sites is easy with springboard-composer, and not covered here, but if you want to replace all code in a site, including any repositories and databases, just delete the site root folder, and
run `scripts/make-sbvt.sh` (alias sbvt-make).

## Replacing default content with reference databases and files

There's not a direct connection to S3, but if you place gzipped files and dbs in
the `artifacts/sites` folder according to the instructions in the
 [readme,](https://github.com/kljr/springboard-valet/blob/master/artifacts/README.md)
you can automatically replace any site's files and/or database with those items
 by running `scripts/artifact.sh.` (alias sbvt-art)

## Running tests

Configuration templates for codeception are copied from the
templates/tests directory into each sites 'tests' directory. They
should be ready to go.

To start tests, move into the tests directory and then
 `vendor/bin/codecept run`
 
To wipe and reload the db:

* To use the QA master db: `scripts/wipe-test-db.sh` (alias sbvt-wipe)
* To use make a clean springboard db: `scripts/wipe-test-db-clean.sh` (alias sbvt-wipe-clean)
* To use any other db, follow the instruction for loading artifacts.

## Useful shell aliases and functions

Most of these are available by default on the virtual machine. See templates/bashrc for a template formatted to
copy and paste to your computer's .bashrc file.

> Directory switching

* `sbvt` - Go to Springboard Valet install directory.
* `cdv [project_root/path]` - switch to project_root or any path in a project_root.
* `cdvm [project_root]` - switch to the Springboard modules directory of site with [project_root]
* `cdvt [project_root]` - switch to the Springboard themes directory of site with [project_root]
* `cdvl [project_root]` - switch to the libraries directory of site with [project_root]
* If you're already in a site directory context, the above commands will work without arguments.

>  Managing sites

* `sbvt-make` - create new springboard site installations based on local.config.yml settings. The command will prompt you for the springboard version.

> DB

* `sbvt-wipe` - prompts for a springboard root directory, replaces the associated db with master QA db. Resets the encryption key path to the local default.
* `sbvt-wipe-clean` - prompts for a springboard root directory, replaces the associated db with a clean springboard db. Resets the encryption key path to the local default.

## Drush global install

You could install Drush globally with Composer (`composer require global drush/drush`), but that is likely to lead to conflicts
if you have other global projects with conflicting dependencies.

Instead use [cgr](https://github.com/consolidation/cgr) to manage all your global packages
(requires that composer be renamed from "composer.phar" to "composer"
and installed globally, preferably as /usr/local/bin/composer).

Or take the steps below to manually install drush globally:

    php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > drush
    php drush core-status
    chmod +x drush
    sudo mv drush /usr/local/bin
