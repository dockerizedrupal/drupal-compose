class setup::fig {
  require setup::fig::packages

  exec { 'pip install fig':
    timeout => 0,
    path => ['/usr/bin']
  }
}
