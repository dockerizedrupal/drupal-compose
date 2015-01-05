# dev

A combination of multiple development tools and a workflows for developing [Drupal](https://www.drupal.org/) based projects primarily on GNU/Linux (Debian/Ubuntu) operating system.

There is a plan to try to get this workflow to work on other platforms (e.g., Microsoft Windows, OS X and other GNU/Linux distributions) in the future as well.

## Working with Fig

### Start Docker containers

    fig up
    
By default `fig up` will stay in foreground, which will prevent you from using the same shell instance for other tasks. Add `-d` option to make it run in the background.

    fig up -d

### List all running containers

    fig ps

## Working with Drush

### List all the Drupal site aliases

     drush site-alias

Shortcut for this command is:

    drush sa

### Update database

    drush -y updatedb

Shortcut for this command is:

    drush -y updb

### Revert features

    drush -y features-revert-all

Shortcut for this command is:

    drush -y fra

### Copy settings file from a remote Drupal host

    drush -y rsync @example.com:sites/default/settings.php @self:sites/default

### Synchronize Drupal files directory between multiple Drupal instances

    drush -y rsync @example.com:%files @self:%files

### Synchronize Drupal database between multiple Drupal instances

     drush -y sql-sync @example.com @self

### Backing up a Drupal database

Clear Drupal cache tables before creating the database dump.

    drush -y cc all

Export Drupal database into a file.

    drush -y sql-dump > ~/dump.sql
    
Export gzipped Drupal database into a file.

    drush -y sql-dump --gzip > ~/dump.sql.gz

It's always a good practise to prepend a creation timestamp to your dump filename.

    drush -y sql-dump > ~/$(date "+%Y%m%d%H%M%S")_dump.sql

If you have multiple database connections in settings.php you have to provide the database connection key for the sql-dump command.

    drush -y sql-dump --database=drupal > ~/dump.sql

### Create empty Drupal database

    drush -y sql-create

    drush -y sql-create --database=default

### Restoring a Drupal database from a backup

Drop all the tables in your database before importing the dump.

    drush -y sql-drop

Import the database dump into MySQL server.

    drush sql-cli < ~/dump.sql

Import gzipped database dump into MySQL server.

    gunzip dump.sql.gz | drush sql-cli
    
If you have multiple database connections in settings.php you have to provide the database connection key for the sql-cli command.

    drush sql-dump --database=default > ~/dump.sql

### Change Drupal user password

    drush upwd admin --password="admin"

### SSH into remote Drupal instance

    drush @example.com site-ssh

Shortcut for this command is:

    drush @example.com ssh

### Go directly to MySQL CLI

    drush sql-cli

Shortcut for this command is:

    drush sqlc

## License

**MIT**
