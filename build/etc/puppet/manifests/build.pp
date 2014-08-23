node default {
  file { '/opt/run.sh':
    ensure => present,
    source => '/tmp/build/run.sh',
    mode => 755
  }
}