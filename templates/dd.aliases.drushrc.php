<?php


$path = 'absolute_path_to_springboard_ddev';

$vars = get_defined_vars();
$directory = explode('.', $vars['aliasname'])[1];

$aliases['*'] = array(
  'uri' => 'https://' . $directory . '.ddev.local:8444',
  'root' => $path . '/sites/' . $directory . '/web',
  'path-aliases' => array(
    '%drush-script' => '/usr/local/bin/drush',
  ),
  '#env-vars' => array(
    'IS_DDEV_PROJECT' => TRUE,
  ),
);

