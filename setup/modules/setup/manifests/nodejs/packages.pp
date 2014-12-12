class setup::nodejs::packages {
  require setup::packages

  exec { '/bin/bash -c "curl -sL https://deb.nodesource.com/setup | sudo bash -"':
    timeout => 0
  }

  package {[
      'nodejs',
      'build-essential'
    ]:
    ensure => present,
    require => Exec['/bin/bash -c "curl -sL https://deb.nodesource.com/setup | sudo bash -"']
  }
}
