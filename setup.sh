#!/usr/bin/env bash

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
sudo apt-get install -y mysql-client
sudo apt-get install -y tmux
sudo apt-get install -y socat

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

mkdir -p "${HOME}/.bin"



echo 'export PATH="${HOME}/.bin:${PATH}"' >> ${HOME}/.bashrc

. ${HOME}/.bashrc
