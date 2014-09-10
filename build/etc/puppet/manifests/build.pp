class packages {
  package {[
      'build-essential'
    ]:
    ensure => present
  }
}

class dev {
  file { '/app':
    ensure => present,
    recurse => true,
    source => '/tmp/build/app'
  }

  exec { '/bin/bash -l -c "cd /app && npm install"':
    require => File['/app']
  }

  file { '/app/app.js':
    ensure => present,
    source => '/tmp/build/app/app.js',
    mode => 755,
    require => File['/app']
  }
}

node default {
  file { '/run.sh':
    ensure => present,
    source => '/tmp/build/run.sh',
    mode => 755
  }

  include packages
  include dev

  Class['packages'] -> Class['dev']

  exec { 'apt-get update':
    path => ['/usr/bin'],
    before => Class['packages']
  }
}