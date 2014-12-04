<?php

$aliases['example.com'] = array(
  'root' => '/var/www/drupal',
  'uri' => 'http://example.com',
  'remote-host' => 'example.com',
  'remote-user' => exec('whoami'),
  'command-specific' => array(
    'sql-sync' => array(
      'create-db' => TRUE,
      'no-cache' => TRUE,
      'structure-tables' => array(
        'common' => array(
          'cache',
          'cache_filter',
          'cache_menu',
          'cache_page',
          'history',
          'sessions',
          'watchdog',
          'search_index',
        ),
      ),
    ),
    'sql-dump' => array(
      'structure-tables' => array(
        'common' => array(
          'cache',
          'cache_filter',
          'cache_menu',
          'cache_page',
          'history',
          'sessions',
          'watchdog',
          'search_index',
        ),
      ),
    ),
  ),
);
