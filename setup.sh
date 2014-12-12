#!/usr/bin/env bash

#sudo apt-get update
#
#sudo apt-get install -y lsb-release
#sudo apt-get install -y openssl
#sudo apt-get install -y ca-certificates
#sudo apt-get install -y wget
#
#PACKAGE="puppetlabs-release-$(lsb_release -sc).deb"
#
#wget "https://apt.puppetlabs.com/${PACKAGE}" -O "/tmp/${PACKAGE}"
#
#sudo dpkg -i "/tmp/${PACKAGE}"
#
#sudo apt-get update
#
#sudo apt-get install -y puppet
#
## https://tickets.puppetlabs.com/browse/PUP-2566
#sudo sed -i '/templatedir=\$confdir\/templates/d' /etc/puppet/puppet.conf
#
#sudo puppet module install puppetlabs/stdlib
#
#sudo puppet apply --modulepath=setup/modules setup/setup.pp

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
echo 'export PATH="${HOME}/.composer/vendor/bin:${PATH}"' >> ${HOME}/.bashrc
. ${HOME}/.bashrc
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
sudo apt-get install -y socat

sudo wget https://raw.githubusercontent.com/drush-ops/drush/master/drush.complete.sh -O /etc/bash_completion.d/drush.complete.sh

git clone http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git "${HOME}/.drush/dev"

sudo groupadd docker
sudo usermod -a -G docker $(whoami)
sudo wget http://gitlab.simpledrupalcloud.com/simpledrupalcloud/dev/raw/master/etc/sudoers.d/docker -O /etc/sudoers.d/docker
sudo chown root.root /etc/sudoers.d/docker
sudo chmod 440 /etc/sudoers.d/docker
sudo groupadd fig
sudo usermod -a -G fig $(whoami)
sudo wget http://gitlab.simpledrupalcloud.com/simpledrupalcloud/dev/raw/master/etc/sudoers.d/fig -O /etc/sudoers.d/fig
sudo chown root.root /etc/sudoers.d/fig
sudo chmod 440 /etc/sudoers.d/fig
sudo service sudo restart
echo 'export PATH="${HOME}/.drush/dev/bin:${PATH}"' >> ${HOME}/.bashrc
. ${HOME}/.bashrc

sudo apt-get install -y pv
drush dl drush_sql_sync_pipe --destination="${HOME}/.drush"
