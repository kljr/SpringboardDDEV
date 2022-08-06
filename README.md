# Springboard DDEV

A Springboard development wrapper for DDEV
.
Installs DDEV and provides a framework for creating multiple 
Springboard sites - and quick, pain-free provisioning, management 
and updates.

## Prerequisites

- Composer.phar installed globally, preferably renamed and moved 
to /usr/local/bin/composer.
- Bash
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

#### Use Springboard DDEV

Now you're ready to create Springboard instances. Run `sbdd-make [ProjectName]`. This command will install Springboard at __~/springboardDDEV/sites/\[ProjectName]__, and start DDEV.

Don't use the names of any pre-existing DDEV projects. Only letters, numbers and hyphens are allowed in DDEV project names, no underscores.
 
## What does Springboard DDEV do?

* Installs DDEV
* Downloads Springboard and its vendor dependencies.
* Accelerates creation and management of multiple Springboard sites:
  * Provides shell aliases and functions to create sites, navigate the directory
hierarchy and perform command-line tasks.
  * Creates Drush aliases which match your project folder name:
`drush @dd-`[`project_folder_name`].
  * Keeps a fully-built, cached copy of Springboard's develop branch as a base for
  new site creation.
  * Enables quick db dumps and restores of any project, as an alternative to DDEV's automatic backups.

## Useful shell aliases and functions

The install script creates custom shell commands, drush shell aliases,
and bash aliases to ease project management.

* `sbdd-make [projectName]` - create a new Springboard site and start serving the site via DDEV.
* `sbdd` - Go to the SpringboardDDEV directory.
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

DDEV has a per-project db snapshot feature. SpringboardDDEV has a
 global db backup and restore feature which allows easy sharing of a single
 db among projects or easy restoration of a db to a single project:

* `sbdd-export [backupName] [optionalProjectName]` - Backup a db to the artifacts folder. Omitting the project name will default to the current project.
* `sbdd-import [backupName] [optionalProjectName]` - Import a db from the artifacts folder. Omitting the project name will default to the current project.

## Uninstalling Springboard DDEV

* Remove the bashrc_ddev include lines from your .profile, .login_profile or
.bash_profile file.
* Delete ~/.bashrc_ddev
* Delete ~/.drush/dd.aliases.drushrc.php
