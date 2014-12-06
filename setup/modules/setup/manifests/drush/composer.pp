class setup::drush::composer {
  require setup::packages

  exec { '/bin/bash -c "curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename composer"':
    timeout => 0
  }

  exec { '/bin/bash -l -c "sed -i \'1i export PATH="${HOME}/.composer/vendor/bin:$PATH"\' ${HOME}/.bashrc"':
    require => Exec['/bin/bash -c "curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename composer"']
  }
}
