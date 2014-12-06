class setup::drush::composer {
  require setup::packages

  exec { '/bin/bash -c "curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename composer"':
    timeout => 0
  }

  exec { 'sed -i \'1i export PATH="${HOME}/.composer/vendor/bin:$PATH"\' ${HOME}/.bashrc':
    path => ['/bin'],
    require => Exec['/bin/bash -c "curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename composer"']
  }
}
