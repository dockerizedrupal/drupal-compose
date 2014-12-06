class setup::openssh_server {
  require setup::openssh_server::packages

  exec { '/bin/bash -c "cat /dev/zero | ssh-keygen -b 4096 -t rsa -N \"\""':
    timeout => 0
  }
}
