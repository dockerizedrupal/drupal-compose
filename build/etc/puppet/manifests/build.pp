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
      'libcloog-ppl0'
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

#class dev {
#  exec { 'mkdir /src':
#    path => ['/bin']
#  }
#
#  file { '/app':
#    ensure => present,
#    recurse => true,
#    source => '/tmp/build/app'
#  }
#
#  exec { '/bin/bash -l -c "cd /app && npm install"':
#    require => File['/app']
#  }
#
#  file { '/app/app.js':
#    ensure => present,
#    source => '/tmp/build/app/app.js',
#    mode => 755,
#    require => File['/app']
#  }
#}

class php {

}

node default {
  file { '/run.sh':
    ensure => present,
    source => '/tmp/build/run.sh',
    mode => 755
  }

  include packages
#  include dev

#  Class['packages'] -> Class['dev']

  exec { 'apt-get update':
    path => ['/usr/bin'],
    before => Class['packages']
  }
}
