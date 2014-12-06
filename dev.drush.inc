<?php

define('DEV_FIG_FILE_BASE_PATH', 'http://gitlab.simpledrupalcloud.com/simpledrupalcloud/fig-drupal/raw');

require_once DRUSH_BASE_PATH . '/commands/core/rsync.core.inc';
require_once DRUSH_BASE_PATH . '/commands/pm/pm.drush.inc';

/**
 * Implementation of hook_drush_command().
 */
function dev_drush_command() {
  $items = array();

  $items['ftp-export-backup'] = array(
    'description' => 'Bind mysqld container TCP/IP socket connection to local Unix domain socket.',
    'allow-additional-options' => TRUE,
    'bootstrap' => DRUSH_BOOTSTRAP_DRUSH,
    'aliases' => array('feb'),
    'callback' => 'drush_ftp_export_backup',
  );

  $items['mysqld'] = array(
    'description' => 'Bind mysqld container TCP/IP socket connection to local Unix domain socket.',
    'allow-additional-options' => TRUE,
    'bootstrap' => DRUSH_BOOTSTRAP_DRUSH,
    'callback' => 'drush_mysqld',
  );

  $items['fig-template'] = array(
    'description' => 'Fetch preconfigured Fig configuration file for Drupal.',
    'allow-additional-options' => TRUE,
    'bootstrap' => DRUSH_BOOTSTRAP_DRUSH,
    'aliases' => array('ft'),
    'callback' => 'dev_fig_template',
  );

  $items['alias-template'] = array(
    'description' => 'Fetch preconfigured Fig configuration file for Drupal.',
    'allow-additional-options' => TRUE,
    'bootstrap' => DRUSH_BOOTSTRAP_DRUSH,
    'aliases' => array('at'),
    'callback' => 'dev_alias_template',
  );

  $items['backup-volume'] = array(
    'description' => 'Backup Docker container volume.',
    'allow-additional-options' => TRUE,
    'bootstrap' => DRUSH_BOOTSTRAP_DRUSH,
    'aliases' => array('bv'),
    'callback' => 'drush_backup_volume',
  );

  $items['restore-volume'] = array(
    'description' => 'Restore Docker container volume.',
    'allow-additional-options' => TRUE,
    'bootstrap' => DRUSH_BOOTSTRAP_DRUSH,
    'aliases' => array('rv'),
    'callback' => 'drush_restore_volume',
  );

  return $items;
}

function ends_with($haystack, $needle, $case = true) {
  if ($case) {
    return strcmp(substr($haystack, strlen($haystack) - strlen($needle)), $needle) === 0;
  }

  return strcasecmp(substr($haystack, strlen($haystack) - strlen($needle)), $needle) === 0;
}

function drush_ftp_export_backup($exported_files_path, $host, $username, $password, $backup_path, $base_path = '') {
  $base_path = rtrim($base_path, '/');

  if (!file_exists($exported_files_path)) {
    return drush_set_error('Could not find exported files path: ' . $exported_files_path);
  }

  if (!is_dir($exported_files_path)) {
    return drush_set_error('Exported files path is a file: ' . $exported_files_path);
  }

  $conn_id = ftp_connect($host);
  $login_result = ftp_login($conn_id, $username, $password);

  if (!$login_result) {
    return drush_set_error('FTP login failed');
  }

  ftp_pasv($conn_id, TRUE);

  if (file_exists($backup_path)) {
    return drush_set_error('Backup directory already exists');
  }

  if (!mkdir($backup_path, 0777, TRUE)) {
    return drush_set_error('Could not create backup directory: ' . $backup_path);
  }

  $errors = array();

  $path = realpath($exported_files_path);
  $objects = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path), RecursiveIteratorIterator::SELF_FIRST);

  foreach($objects as $name => $object) {
    $exploded = explode($exported_files_path, $name);
    $relative_name = $exploded[1];

    if ($relative_name == '.') {
      continue;
    }

    if ($relative_name == '..') {
      continue;
    }

    if (ends_with($relative_name, '/.', FALSE) || ends_with($relative_name, '/..', FALSE)) {
      continue;
    }

    if (is_dir($name)) {
      continue;
    }

    $relative_name = ltrim($relative_name, '/');
    $exploded = explode('/', $relative_name);

    unset($exploded[count($exploded) - 1]);

    $join = implode('/', $exploded);
    $remote_file = $base_path . '/' . $relative_name;
    $contents = ftp_nlist($conn_id, $remote_file);

    if (!in_array($base_path . '/' . $relative_name, $contents)) {
      continue;
    }

    if (!file_exists($backup_path . '/' . $join)) {
      mkdir($backup_path . '/' . $join, 0777, TRUE);
    }

    $local_file = $backup_path . '/' . $relative_name;

    if (!ftp_get($conn_id, $local_file, $remote_file, FTP_BINARY)) {
      $errors[] = $local_file;

      continue;
    }

    drush_log("Successfully backed up: $local_file", 'success');
  }

  ftp_close($conn_id);

  foreach ($errors as $error) {
    drush_set_error("Backing up file $error failed");
  }
}

function drush_backup_volume($volume, $container) {
  $pwd = getcwd();

  $command = <<<COMMAND
sudo docker run --rm --volumes-from $container -v $pwd:/backup simpledrupalcloud/base:latest tar czvf /backup/data.tar.gz $volume
COMMAND;

  drush_shell_exec($command);
}

function drush_restore_volume($container) {
  $pwd = getcwd();

  $command = <<<COMMAND
sudo docker run --rm --volumes-from $container -v $pwd:/backup simpledrupalcloud/base:latest tar xzvf /backup/data.tar.gz
COMMAND;

  drush_shell_exec($command);
}

function drush_mysqld($container) {
  $ip_address = _drush_mysqld_container_ip_address_get($container);

  if (!$ip_address) {
    return drush_set_error(dt("Unable to query container's IP Address.\nThe specific errors are below:\n!errors", array(
      '!errors' => implode("\n", drush_shell_exec_output()),
    )));
  }

  $port = _drush_mysqld_container_port_get($container);

  if (!$port) {
    return drush_set_error(dt("Unable to query container's port.\nThe specific errors are below:\n!errors", array(
      '!errors' => implode("\n", drush_shell_exec_output()),
    )));
  }

  _drush_mysqld_unix_domain_socket_path_create();

  _drush_mysql_socat_run($ip_address, $port);
}

function _drush_mysqld_container_ip_address_get($container) {
  $command = <<<COMMAND
sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' $container;
COMMAND;

  drush_shell_exec($command);

  $output = drush_shell_exec_output();

  return isset($output[0]) ? $output[0] : NULL;
}

function _drush_mysqld_container_port_get($container) {
  $command = <<<COMMAND
sudo docker inspect --format '{{(index (index .NetworkSettings.Ports "3306/tcp") 0).HostPort}}' $container
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

function dev_fig_template() {
  $destination = '@self';

  $additional_options = array();

  $destination_settings = drush_sitealias_evaluate_path($destination, $additional_options, TRUE);

  if (!isset($destination_settings['evaluated-path'])) {
    return drush_set_error('DRUSH_BAD_PATH', dt('Could not evaluate destination path !path.', array(
      '!path' => $destination,
    )));
  }

  $destination_path = $destination_settings['evaluated-path'];

  $drupal_version = drush_drupal_major_version($destination_path);

  if ($drupal_version == 6) {
    $fig_file_path = DEV_FIG_FILE_BASE_PATH . '/6.x/fig.yml';
  }
  elseif ($drupal_version == 7) {
    $fig_file_path = DEV_FIG_FILE_BASE_PATH . '/7.x/fig.yml';
  }
  elseif ($drupal_version == 8) {
    $fig_file_path = DEV_FIG_FILE_BASE_PATH . '/8.x/fig.yml';
  }
  else {
    return drush_set_error(dt('Unsupported Drupal version.'));
  }

  $command = <<<COMMAND
wget $fig_file_path -O "${destination_path}fig.yml"
COMMAND;

  drush_shell_exec($command);
}

function dev_alias_template() {
  $destination = '@self';

  $additional_options = array();

  $destination_settings = drush_sitealias_evaluate_path($destination, $additional_options, TRUE);

  if (!isset($destination_settings['evaluated-path'])) {
    return drush_set_error('DRUSH_BAD_PATH', dt('Could not evaluate destination path !path.', array(
      '!path' => $destination,
    )));
  }

  $destination_path = $destination_settings['evaluated-path'];
  $destination_path .= '/sites/all/drush';

  if (!file_exists($destination_path)) {
    mkdir($destination_path, 0777, TRUE);
  }

  copy(getenv("HOME") . '/.drush/dev/src/sites/all/drush/aliases.drushrc.php', $destination_path . '/aliases.drushrc.php');
}
