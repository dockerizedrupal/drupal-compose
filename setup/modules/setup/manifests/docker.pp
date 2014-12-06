class setup::docker {
  require setup::packages

  exec { '/bin/bash -c "curl -sSL https://get.docker.com/ubuntu/ | sudo sh"':
    timeout => 0
  }
}
