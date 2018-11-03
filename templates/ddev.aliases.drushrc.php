<?php

/**
 * Drupal VM drush aliases.
 *
 * @see example.aliases.drushrc.php.
 */

$path = 'absolute_path_to_springboard_ddev_sites_directory';

$dirs = array_diff(scandir($path), array('..', '.'));

foreach ($dirs as $alias) {
  $dir = $path . '/' . $alias;
  if (file_exists($dir) && is_dir($dir)) {
    $aliases['drush_alias_prefix' . $alias] = array(
      'uri' => $alias . '.valet_domain',
      'root' => $path . '/' . $alias . '/web',
      'path-aliases' => array(
        '%drush-script' => '/usr/local/bin/drush',
      ),
    );
  }
}