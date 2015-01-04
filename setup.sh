#!/usr/bin/env bash

SERVER_NAME="localhost"

sudo apt-get install -y openssh-server
cat /dev/zero | ssh-keygen -b 4096 -t rsa -N ""

sudo apt-get install -y curl
curl -sSL https://get.docker.com/ubuntu/ | sudo sh

sudo apt-get install -y python-pip
sudo pip install fig

curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential

sudo npm install -g less
sudo npm install -g grunt
sudo npm install -g grunt-cli

sudo apt-get install -y git
sudo apt-get install -y subversion
sudo apt-get install -y tmux
sudo apt-get install -y socat

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

sudo wget http://gitlab.simpledrupalcloud.com/simpledrupalcloud/dev/raw/master/opt/docker.sh -O /opt/docker
sudo chmod +x /opt/docker

sudo wget http://gitlab.simpledrupalcloud.com/simpledrupalcloud/dev/raw/master/opt/fig.sh -O /opt/fig
sudo chmod +x /opt/fig

sudo wget http://gitlab.simpledrupalcloud.com/simpledrupalcloud/dev/raw/master/opt/drush.sh -O /opt/drush
sudo chmod +x /opt/drush

echo 'export PATH="/opt:${PATH}"' >> ${HOME}/.bashrc

sudo wget https://raw.githubusercontent.com/drush-ops/drush/master/drush.complete.sh -O /etc/bash_completion.d/drush.complete.sh

cat >> ${HOME}/.bashrc <<SCRIPT
if [ -f /etc/bash_completion.d/drush.complete.sh ]; then
  . /etc/bash_completion.d/drush.complete.sh
fi
SCRIPT

. ${HOME}/.bashrc

sudo wget http://gitlab.simpledrupalcloud.com/simpledrupalcloud/docker-vhost/raw/master/fig.yml -O /opt/vhost.yml
sudo sed -i "s/localhost/${SERVER_NAME}/g" /opt/vhost.yml
sudo wget http://gitlab.simpledrupalcloud.com/simpledrupalcloud/docker-vhost/raw/master/vhost.conf -O /etc/init/vhost.conf

sudo wget http://gitlab.simpledrupalcloud.com/simpledrupalcloud/docker-logs/raw/master/fig.yml -O /opt/logs.yml
sudo wget http://gitlab.simpledrupalcloud.com/simpledrupalcloud/docker-logs/raw/master/logs.conf -O /etc/init/logs.conf
