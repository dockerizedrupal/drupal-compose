node default {
  file { '/run.sh':
    ensure => present,
    source => '/tmp/build/run.sh',
    mode => 755
  }

  file { '/app':
    ensure => present,
    recurse => true,
    source => '/tmp/build/app'
  }

  exec { '/bin/bash -c "cd /app && npm install"':
    require => File['/app']
  }

  file { '/app/dev.js':
    ensure => present,
    mode => 755,
    require => File['/app']
  }
}