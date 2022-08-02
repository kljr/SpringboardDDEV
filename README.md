# Springboard DDEV

A Springboard development wrapper for DDEV
.
Provides multiple fully-configured Springboard sites - each with working 
copies of the Springboard repositories - and quick, pain-free 
provisioning, management and updates.

## Prerequisites

- Composer.phar installed globally, preferably renamed and moved 
to /usr/local/bin/composer.
- Bash
- DDEV
- drush installed globally.

# Usage


#### Set up Springboard DDEV

1. Clone this repository.

2. There are two ways to install Springboard DDEV:

 * __Interactive install__: from the Springboard DDEV root directory
 run `scripts/ddev-install.sh` 
 and follow the prompts. This script runs composer install,
 and updates your drush and bash configuration after you 
 confirm the proposed changes. 
 
      You can review the changes by looking at the files in the /templates 
directory: bashrc_ddev, bash_profile_ddev, and dd.aliases.drushrc.php.

      If you don't want to automatically install the shell 
commands and drush aliases, you'll need to manually copy the files 
from the templates directory to the correct locations.

 * __Non-interactive install__: from the Springboard DDEV root directory run 
 `composer install` This will update your drush and 
 bash configuration without asking. 

3. Now you're ready to create Springboard instances. Run `sbdd-make [project_name]` 

    Alternatively, you can copy `example.local.config.yml` 
to `local.config.yml` and modify it. Define projects following the example
project definitions. Don't use the names of any pre-existing DDEV projects. run ``sbdd-make` without any arguments.
 
## What does Springboard DDEV do?

* Downloads springboard and its vendor dependencies.
* Creates and manages multiple DDEV sites
* Provides shell aliases and functions to quickly navigate the directory
hierarchy and perform commandline tasks.
* Creates Drush aliases which match your project folder name:
`drush @dd-`[`project_folder_name`].

## Useful shell aliases and functions

The install script creates custom shell commands, drush shell aliases,
and bash aliases to ease project management.

> Directory switching

* `sbdd` - Go to the Springboard DDDEV directory.
* `ddv [project_folder_name/path]` - switch to a project root folder or any path in a 
project.
* `ddvw [project_folder_name]` - switch to the web directory of the project.
* `ddvm [project_folder_name]` - switch to the Springboard modules directory 
of the project.
* `ddvt [project_folder_name]` - switch to the Springboard themes directory 
of the project.
* `ddvl [project_folder_name]` - switch to the libraries directory of the project.

    If the command prompt is already in a project hierarchy, the above commands will
work without arguments.

## Uninstalling Springboard DDEV

* Delete the springboardDDEV directory
* Remove the bashrc_ddev include lines from your .profile, .login_profile or
.bash_profile file.
* Delete ~/.bashrc_ddev
* Remove the ddev custom shell commands from ~/.drush/drushrc.php
* Delete ~/.drush/dd.aliases.drushrc.php
