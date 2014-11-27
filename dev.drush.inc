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

  $items['mysqld'] = array(
    'description' => 'Copy settings file from remote host.',
    'allow-additional-options' => TRUE,
    'bootstrap' => DRUSH_BOOTSTRAP_DRUSH,
    'callback' => 'drush_mysqld',
  );

  $items['fig-init'] = array(
    'description' => 'Copy settings file from remote host.',
    'allow-additional-options' => TRUE,
    'bootstrap' => DRUSH_BOOTSTRAP_DRUSH,
    'aliases' => array('fi'),
    'callback' => 'drush_fig_init',
  );

  return $items;
}

function drush_settings_copy($source, $destination) {
  drush_core_rsync($source . ':sites/default/settings.php', '@self:sites/default');
}

function drush_mysqld($container_id) {
  drush_shell_exec('ls');

  $ip_address = _drush_mysqld_container_ip_address_get($container_id);

  if (!$ip_address) {
    return drush_set_error(dt("Unable to query container's IP Address.\nThe specific errors are below:\n!errors", array(
      '!errors' => implode("\n", drush_shell_exec_output()),
    )));
  }

  $port = _drush_mysqld_container_port_get($container_id);

  if (!$port) {
    return drush_set_error(dt("Unable to query container's port.\nThe specific errors are below:\n!errors", array(
      '!errors' => implode("\n", drush_shell_exec_output()),
    )));
  }

  _drush_mysqld_unix_domain_socket_path_create();

  _drush_mysql_socat_run($ip_address, $port);

  print_r(drush_shell_exec_output());
}

function _drush_mysqld_container_ip_address_get($container_id) {
  $command = <<<COMMAND
sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' $container_id;
COMMAND;

  drush_shell_exec($command);

  $output = drush_shell_exec_output();

  return isset($output[0]) ? $output[0] : NULL;
}

function _drush_mysqld_container_port_get($container_id) {
  $command = <<<COMMAND
sudo docker inspect --format '{{(index (index .NetworkSettings.Ports "3306/tcp") 0).HostPort}}' $container_id
COMMAND;

  drush_shell_exec($command);

  $output = drush_shell_exec_output();

  return isset($output[0]) ? $output[0] : NULL;
}

function _drush_mysqld_unix_domain_socket_path_create() {
  $command = <<<COMMAND
sudo mkdir -p /var/run/mysqld
COMMAND;

  drush_shell_exec($command);

  return !drush_shell_exec_output() ? TRUE : FALSE;
}

function _drush_mysql_socat_run($ip_address, $port) {
  $command = <<<COMMAND
sudo socat UNIX-LISTEN:/var/run/mysqld/mysqld.sock,fork,reuseaddr,unlink-early,user=www-data,group=www-data,mode=777 TCP:$ip_address:$port
COMMAND;

  drush_shell_exec($command);

  return !drush_shell_exec_output() ? TRUE : FALSE;
}

function drush_fig_init() {
  $command = <<<COMMAND
git clone
COMMAND;

  drush_shell_exec($command);

  return !drush_shell_exec_output() ? TRUE : FALSE;
}
