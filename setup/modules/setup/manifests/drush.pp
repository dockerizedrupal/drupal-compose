class setup::drush {
  require setup::drush::packages
  require setup::drush::composer

  exec { '/bin/bash -c "source ${HOME}/.bashrc && composer global require drush/drush:6.*"': }
}
