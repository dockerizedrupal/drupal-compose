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

  file { '/app/dev.js':
    ensure => present,
    mode => 755,
    require => File['/app']
  }

  exec { '/usr/bin/npm install /app':
    require => File['/app/dev.js']
  }
}