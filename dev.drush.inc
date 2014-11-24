<?php

require_once DRUSH_BASE_PATH . '/commands/core/rsync.core.inc';

/**
 * Implementation of hook_drush_command().
 */
function dev_drush_command() {
  $items = array();

  $items['settings-copy'] = array(
    'description' => 'Copy settings file from remote host.',
    'allow-additional-options' => TRUE,
    'bootstrap' => DRUSH_BOOTSTRAP_DRUSH,
    'aliases' => array('sc'),
    'callback' => 'drush_settings_copy',
  );

  return $items;
}

function drush_settings_copy($source = '') {
  drush_core_rsync($source . ':sites/default/settings.php', '@self:sites/default');
}
