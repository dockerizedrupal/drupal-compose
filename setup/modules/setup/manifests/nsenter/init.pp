class setup::nsenter {
  require setup::docker

  exec { 'sudo docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter':
    timeout => 0,
    path => ['/usr/bin']
  }
}
