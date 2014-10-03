class packages {
  package {[
      'git',
      'curl',
      'build-essential',
      'libxml2-dev',
      'libssl-dev',
      'libbz2-dev',
      'libcurl4-gnutls-dev',
      'libjpeg-dev',
      'libpng12-dev',
      'libmcrypt-dev',
      'libmhash-dev',
      'libmysqlclient-dev',
      'libpspell-dev',
      'autoconf',
      'libcloog-ppl0',
      'apache2',
      'libapache2-mod-fastcgi'
    ]:
    ensure => present
  }
}

class phpfarm {
  include packages

  exec { 'git clone git://git.code.sf.net/p/phpfarm/code phpfarm':
    cwd => '/',
    path => ['/usr/bin'],
    require => Class['packages']
  }
}

class php_supervisor {
  file { '/etc/supervisor/conf.d/php.conf':
    ensure => present,
    source => '/tmp/build/etc/supervisor/conf.d/php.conf'
  }
}

class php {
  include phpfarm
  include php_supervisor

  file { '/phpfarm/src/custom-options-5.4.33.sh':
    ensure => present,
    source => '/tmp/build/phpfarm/src/custom-options-5.4.33.sh',
    mode => 755,
    require => Class['phpfarm']
  }

  exec { '/phpfarm/src/compile.sh 5.4.33':
    timeout => 0,
    require => File['/phpfarm/src/custom-options-5.4.33.sh']
  }

  exec { 'rm -rf /phpfarm/src/php-5.4.33':
    path => ['/bin'],
    require => Exec['/phpfarm/src/compile.sh 5.4.33']
  }

  file { '/phpfarm/inst/php-5.4.33/etc/php-fpm.conf':
    ensure => present,
    source => '/tmp/build/phpfarm/inst/php-5.4.33/etc/php-fpm.conf',
    mode => 644,
    require => Exec['/phpfarm/src/compile.sh 5.4.33']
  }

  file { '/phpfarm/inst/php-5.4.33/lib/php.ini':
    ensure => present,
    source => '/tmp/build/phpfarm/inst/php-5.4.33/lib/php.ini',
    mode => 644,
    require => Exec['/phpfarm/src/compile.sh 5.4.33']
  }

  file { '/etc/profile.d/phpfarm.sh':
    ensure => present,
    source => '/tmp/build/etc/profile.d/phpfarm.sh',
    mode => 755,
    require => Exec['/phpfarm/src/compile.sh 5.4.33']
  }

  exec { '/bin/bash -l -c "switch-phpfarm 5.4.33"':
    require => File['/etc/profile.d/phpfarm.sh']
  }
}

class apache_supervisor {
  file { '/etc/supervisor/conf.d/apache.conf':
    ensure => present,
    source => '/tmp/build/etc/supervisor/conf.d/apache.conf'
  }
}

class apache {
  include apache_supervisor

  exec { '/bin/bash -c "a2enmod actions"': }
  exec { '/bin/bash -c "a2enmod fastcgi"': }
  exec { '/bin/bash -c "a2enmod vhost_alias"': }
  exec { '/bin/bash -c "a2enmod rewrite"': }
  exec { '/bin/bash -c "a2enmod ssl"': }

  file { '/etc/apache2/apache2.conf':
    ensure => present,
    source => '/tmp/build/etc/apache2/apache2.conf',
    mode => 644
  }

  file { '/etc/apache2/conf.d/php':
    ensure => present,
    source => '/tmp/build/etc/apache2/conf.d/php',
    mode => 644
  }

  file { '/etc/apache2/sites-enabled/000-default':
    ensure => absent
  }

  file { '/etc/apache2/sites-available/default':
    ensure => present,
    source => '/tmp/build/etc/apache2/sites-available/default',
    mode => 644
  }

  file { '/etc/apache2/sites-enabled/default':
    ensure => link,
    target => '/etc/apache2/sites-available/default',
    require => File['/etc/apache2/sites-available/default']
  }

  file { '/etc/apache2/sites-available/default-ssl':
    ensure => present,
    source => '/tmp/build/etc/apache2/sites-available/default-ssl',
    mode => 644
  }

  file { '/etc/apache2/sites-enabled/default-ssl':
    ensure => link,
    target => '/etc/apache2/sites-available/default-ssl',
    require => File['/etc/apache2/sites-available/default-ssl']
  }
}

node default {
  file { '/run.sh':
    ensure => present,
    source => '/tmp/build/run.sh',
    mode => 755
  }

  include packages
  include php
  include apache

  Class['packages'] -> Class['php'] -> Class['apache']

  file { '/etc/apt/sources.list.d/non-free.list':
    ensure => present,
    source => '/tmp/build/etc/apt/sources.list.d/non-free.list',
    mode => 644,
    before => Class['packages']
  }

  exec { 'apt-get update':
    path => ['/usr/bin'],
    require => File['/etc/apt/sources.list.d/non-free.list']
  }
}
