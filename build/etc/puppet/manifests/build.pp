node default {
  file { '/run.sh':
    ensure => present,
    source => '/tmp/build/run.sh',
    mode => 755
  }

  file { '/app':
    ensure => present,
    source => '/tmp/build/app'
  }

  file { '/app/dev.js':
    mode => 755,
    require => File['/app']
  }
}