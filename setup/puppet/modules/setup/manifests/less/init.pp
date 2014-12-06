class setup::less {
  require setup::nodejs

  exec { 'npm install -g less':
    timeout => 0,
    path => ['/usr/bin']
  }
}
