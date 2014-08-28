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

  exec { 'bash -c "cd /app && npm install"':
    cwd => ['/bin'],
    require => File['/app']
  }

  file { '/app/dev.js':
    ensure => present,
    source => '/tmp/build/app/dev.js',
    mode => 755,
    require => File['/app']
  }
}