#!/usr/bin/env bash

sudo apt-get install -y openssh-server
cat /dev/zero | ssh-keygen -b 4096 -t rsa -N ""

sudo apt-get install -y curl
curl -sSL https://get.docker.com/ubuntu/ | sudo sh

sudo docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter

sudo apt-get install -y python-pip
sudo pip install fig

sudo apt-get install -y php5-cli
sudo apt-get install -y php5-mysql
sudo apt-get install -y php5-gd
sudo apt-get install -y php5-redis
sudo apt-get install -y php5-ldap
sudo apt-get install -y php5-memcached

curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename composer
sed -i '1i export PATH="$HOME/.composer/vendor/bin:$PATH"' $HOME/.bashrc

. $HOME/.bashrc

composer global require drush/drush:6.*

curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential

sudo npm install -g less
sudo npm install -g grunt
sudo npm install -g grunt-cli

sudo apt-get install -y git
sudo apt-get install -y subversion
sudo apt-get install -y mysql-client
sudo apt-get install -y tmux

sudo wget https://raw.githubusercontent.com/drush-ops/drush/master/drush.complete.sh -O /etc/bash_completion.d/drush.complete.sh
