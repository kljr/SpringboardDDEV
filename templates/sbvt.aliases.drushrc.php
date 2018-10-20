<?php

/**
 * Drupal VM drush aliases.
 *
 * @see example.aliases.drushrc.php.
 */

$path = '/Users/a/desktop/springboard-valet/sites';

$dirs = array_diff(scandir($directory), array('..', '.'));

foreach ($dirs as $alias) {
  $aliases[$alias] = array(
    'uri' => $alias . '.test',
    'root' => '/Users/a/desktop/springboard-valet/sites/' . $alias . '/web',
    'path-aliases' => array(
      '%drush-script' => '/usr/local/bin/drush',
    ),
  );
}



