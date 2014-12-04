# dev

A combination of multiple development tools and a workflow for developing [Drupal](https://www.drupal.org/) based projects primarily on GNU/Linux (Debian/Ubuntu) operating system.

There is a plan to try to get this workflow to work on other platforms (e.g., Microsoft Windows, OS X and other GNU/Linux distributions) in the future as well.

## Proof of concept examples

A proof of concept examples for Drupal 6, 7 and 8 can be found in the `examples` directory.

These examples will be the basis for this document.

## Requirements

 * [Docker](http://docker.com/)
 * [Fig](http://www.fig.sh/)
 * [Drush](https://github.com/drush-ops/drush)
 * [Node.js](http://nodejs.org/)

## Set up your environment

This section will be converted to [Puppet](http://puppetlabs.com/) manifest eventually.

### OpenSSH

#### Installing OpenSSH

    sudo apt-get install -y openssh-server
    
#### Generating OpenSSH private/public keys

    cat /dev/zero | ssh-keygen -b 4096 -t rsa -N ""

Note: The command will create the keys automatically without the human interaction. It's strongly recommended that you protect your private key with a passphrase.

### Docker

#### Installing Docker

    sudo apt-get install -y curl
    
    curl -sSL https://get.docker.com/ubuntu/ | sudo sh

#### Updating Docker

    sudo apt-get upgrade lxc-docker

### nsenter

nssenter allows you to enter Docker containers with ease.

#### Installing nsenter

    sudo docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter

#### Using nsenter

### Fig

#### Installing Fig

    sudo apt-get install -y python-pip

    sudo pip install fig

#### Updating Fig

    sudo pip install -U fig

### PHP for Drush

#### Installing PHP

    sudo apt-get install -y php5-cli

    sudo apt-get install -y php5-mysql

    sudo apt-get install -y php5-gd
    
    sudo apt-get install -y php5-redis
    
    sudo apt-get install -y php5-ldap
    
    sudo apt-get install -y php5-memcached

### Drush

#### Installing Drush

To install Drush on your system, you have to first install [Composer](https://getcomposer.org/) (dependency manager for PHP).

To do that, execute the following command:

    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename composer

Now we are ready to install Drush.

    sed -i '1i export PATH="$HOME/.composer/vendor/bin:$PATH"' $HOME/.bashrc

    source $HOME/.bashrc
    
    composer global require drush/drush:6.*

#### Updating Drush

    sudo composer global update

### Node.js

#### Installing Node.js

    curl -sL https://deb.nodesource.com/setup | sudo bash -

    sudo apt-get install -y nodejs

    sudo apt-get install -y build-essential

### LESS compiler

#### Installing LESS compiler

    sudo npm install -g less

### Grunt

### Installing Grunt

    sudo npm install -g grunt
    
    sudo npm install -g grunt-cli

### Git

#### Installing Git

    sudo apt-get install -y git

### Subversion

#### Installing Subversion

    sudo apt-get install -y subversion

### MySQL client

#### Installing MySQL client

    sudo apt-get install -y mysql-client
    
### tmux
 
#### Installing tmux

    sudo apt-get install -y tmux

## Working with Docker

## Working with Fig
   
## Working with Drush

### Drush Bash completion

    sudo wget https://raw.githubusercontent.com/drush-ops/drush/master/drush.complete.sh -O /etc/bash_completion.d/drush.complete.sh

After executing this command you need to reinitialize your bash instance.

### Drush aliases

  1) Add file sites/all/drush/dev.aliases.drushrc.php to your Drupal project
  
    <?php
    
    $aliases['example.com'] = array(
      'root' => '/var/www/drupal',
      'uri' => 'http://example.com',
      'remote-host' => 'example.com',
      'remote-user' => exec('whoami'),
      'command-specific' => array(
        'sql-sync' => array(
          'create-db' => TRUE,
          'no-cache' => TRUE,
          'structure-tables' => array(
            'common' => array(
              'cache',
              'cache_filter',
              'cache_menu',
              'cache_page',
              'history',
              'sessions',
              'watchdog',
              'search_index',
            ),
          ),
        ),
        'sql-dump' => array(
          'structure-tables' => array(
            'common' => array(
              'cache',
              'cache_filter',
              'cache_menu',
              'cache_page',
              'history',
              'sessions',
              'watchdog',
              'search_index',
            ),
          ),
        ),
      ),
    );
   
## TODO

 * Logging
 * Backing up data volume containers

## Backlog

 * drush fig-init
 * drush mysqld [container_id]
 * drush settings-copy @dev.preprod (drush sc @dev.preprod)
 * drush site-alias (drush sa)
 * drush sql-drop
 * drush -y sql-sync @dev.preprod @self
 * drush -y rsync @dev.preprod:%files @self:%files
 * drush @dev.preprod ssh
 * drush cc
 * drush sql-dump > ~/sql-dump.sql
 * drush sql-drop
 * drush sql-cli < ~/sql-dump.sql
 * drush upwd admin --password="admin"

## License

**MIT**
