# Springboard Valet

A Springboard development environment built with Laravel Valet,
 Composer, Codeception and Bash.

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

#### Set up Homebrew and Laravel Valet

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

#### Set up Springboard Valet

6. Clone this repository. Copy `example.local.config.yml` 
to `local.config.yml` and modify it to
match your mySQL configuration. Define projects following the example
project definitions. 

  Laravel Valet by default serves all sites with the ".test" domain. 
  Springboard Valet by default serves all sites at [projectroot].test. 
  You can configure Springboard Valet to serve from an alternate domain
  if Valet is using one. Don't change this value after Springboard Valet 
  has been installed. 

7. There are two ways to install Springboard Valet:
 
 * __Interactive install__: from the Springboard Valet root directory
 run `scripts/sbvt-install.sh` 
 and follow the prompts. This script runs composer install,
 and updates your drush and bash configuration after you 
 confirm the proposed changes. 
 
      You can review the changes by looking at the files in the /templates 
directory: bashrc_sbvt, bash_profile_sbvt, sbvt.aliases.drushrc.php 
and drushrc.

      If you don't want to automatically install the shell 
commands and drush aliases, you'll need to manually copy the files 
from the templates directory to the correct locations.

 * __Non-interactive install__: from the Springboard Valet root directory run 
 `composer install` This will update your drush and 
 bash configuration without asking. 

7. Now you're ready to create Springboard instances. Run `sbvt-make` 
(or scripts/sbvt-make.sh). Follow the prompts to install the projects 
you defined in the yaml config.

After the initial install, if you want to create additional Springboard 
sites, update local.config.yml with your new project info. Then 
run `sbvt-make` (or scripts/make-sbvt.sh).
 
## What does Springboard Valet do?

* Downloads Springboard-Composer and its vendor dependencies.
* Creates and manages multiple virtual hosts and site databases.
* Configures the codeception tests to work out of the box.
* Automates replacing a site's database with a fresh copy of QA master.
* Automates replacing a site's database and file assets with
a reference site db and file assets.
* Configures encrypt and sustainer keys to QA master defaults.
* Provides shell aliases and functions to quickly navigate the directory
hierarchy and perform commandline tasks.
* Creates Drush aliases which match your project folder name:
`drush @sbvt-`[`project_folder_name`].

## Useful shell aliases and functions

The install script creates custom shell commands, drush shell aliases,
and bash aliases to ease project management.

> Directory switching

* `sbvt` - Go to the Springboard Valet directory.
* `cdv [project_folder_name/path]` - switch to a project root folder or any path in a 
project.
* `cdvw [project_folder_name]` - switch to the web directory of the project.
* `cdvm [project_folder_name]` - switch to the Springboard modules directory 
of the project.
* `cdvt [project_folder_name]` - switch to the Springboard themes directory 
of the project.
* `cdvl [project_folder_name]` - switch to the libraries directory of the project.

    If the command prompt is already in a project hierarchy, the above commands will
work without arguments.


>  Managing sites

* `sbvt-make` - create new springboard site installations based on 
local.config.yml settings. The command will prompt you for the 
springboard version.
* `sbvt-prep [project_folder_name]` - Installs admin_menu, 
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

You may have to configure Postfix to send mail locally. See instructions [here](https://www.joshstauffer.com/send-test-emails-on-a-mac-with-mailhog/).
Alternatively, you can install [Mailhog Sendmail.](https://jonchristopher.us/blog/mylocaldev-part-3-mailhog-mhsendmail-os-x/).


To start tests, move into a project root directory and then
 `vendor/bin/codecept run`
 
To wipe and reload the db:

* To use the QA master db: `sbvt-wipe` (scripts/wipe-test-db.sh)
* To use a clean springboard db: `sbvt-wipe-clean` (scripts/wipe-test-db-clean.sh) 
* To use any other db, follow the instruction for loading artifacts.

## Updating existing Springboard sites

If you want to replace all code in a site and re-create it, 
just delete the site root folder, and run `sbvt-make`.  If you delete
the database prior to that, it will be recreated, otherwise the same
db will be used.

## Uninstalling Springboard Valet

* Delete the springboard-valet directory
* Remove the bashrc_sbvt include lines from your .profile, .login_profile or
.bash_profile file.
* Delete ~/.bashrc_sbvt
* Remove the sbvt custom shell commands from ~/.drush/drushrc.php
* Delete ~/.drush/sbvt.aliases.drushrc.php

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
