class setup::packages {
  exec { 'apt-get update':
    path => ['/usr/bin']
  }

  package {[
      'curl'
    ]:
    ensure => present,
    require => Exec['apt-get update']
  }
}
