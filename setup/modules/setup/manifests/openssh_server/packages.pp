class setup::openssh_server::packages {
  package {[
      'openssh-server'
    ]:
    ensure => present
  }
}
