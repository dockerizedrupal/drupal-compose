# dev

[Drush](https://github.com/drush-ops/drush) commands for interacting with [dev-workflow](http://gitlab.simpledrupalcloud.com/simpledrupalcloud/dev-workflow/blob/master/README.md)

## Install dev

    DESTINATION="~/.drush/dev" \
      && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git "${DESTINATION}" \
      && cd "${DESTINATION}" \
      && git checkout dev \
      && cd -

## Drush commands

    drush settings-copy @dev.preprod
    drush mysqld mysqld
    drush fig-init

## License

**MIT**
