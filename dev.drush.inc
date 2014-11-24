<?php

require_once DRUSH_BASE_PATH . '/commands/core/rsync.core.inc';

/**
 * Implementation of hook_drush_command().
 */
function dev_drush_command() {
  $items = array();

  $items['dev'] = array(
    'description' => 'Perform package management and dependency tracking of your projects and libraries.',
    'arguments' => array(
      'command' => 'Run "drush dev" for a list of available commands.',
    ),
    'allow-additional-options' => TRUE,
    'examples' => array(
      'drush dev settings' => 'Settings file',
    ),
    'bootstrap' => DRUSH_BOOTSTRAP_DRUSH,
  );

  return $items;
}

function drush_dev() {
  $args = func_get_args();

  if (!isset($args[0])) {
    return drush_set_error(dt('Invalid arguments!'));
  }

  $command = $args[0];

  switch ($command) {
    case 'settings-sync':
    case 'ss':
      if (!isset($args[1])) {
        return drush_set_error(dt('Source alias required!'));
      }

      $source = $args[1];

      drush_core_rsync($source . ':sites/default/settings.php', '@self:sites/default');

      break;
  }
}
