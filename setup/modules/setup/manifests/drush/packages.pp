class setup::drush::packages {
  package {[
      'php5-cli',
      'php5-mysql',
      'php5-gd',
      'php5-redis',
      'php5-ldap',
      'php5-memcached'
    ]:
    ensure => present
  }
}
