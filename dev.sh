#!/usr/bin/env bash

apache_run() {
  sudo docker run \
    --name apache \
    --net host \
    -v /var/apache-2.2.22/conf.d:/apache-2.2.22/conf.d \
    -v /var/apache-2.2.22/data:/apache-2.2.22/data \
    -v /var/apache-2.2.22/log:/apache-2.2.22/log \
    -e APACHE_SERVERNAME=example.com \
    -d \
    simpledrupalcloud/apache:2.2.22
}

apache_stop() {
  sudo docker stop apache
}

apache_rm() {
  apache_stop

  sudo docker rm apache
}

apache_rmi() {
  apache_rm

  sudo docker rmi simpledrupalcloud/apache:2.2.22
}

apache_pull() {
  sudo docker pull simpledrupalcloud/apache:2.2.22
}

apache_update() {
  apache_rm
  apache_pull
  apache_run
}

apache_start() {
  apache_rm
  apache_run
}

apache_restart() {
  apache_rm
  apache_run
}

apache_destroy() {
  apache_rmi
}

php5217_run() {
  sudo docker run \
    --name php5217 \
    --net host \
    --volumes-from apache \
    -d \
    simpledrupalcloud/php:5.2.17
}

php5217_stop() {
  sudo docker stop php5217
}

php5217_rm() {
  php5217_stop

  sudo docker rm php5217
}

php5217_rmi() {
  php5217_rm

  sudo docker rmi simpledrupalcloud/php:5.2.17
}

php5217_pull() {
  sudo docker pull simpledrupalcloud/php:5.2.17
}

php5217_update() {
  php5217_rm
  php5217_pull
  php5217_run
}

php5217_start() {
  php5217_rm
  php5217_run
}

php5217_restart() {
  php5217_rm
  php5217_run
}

php5217_destroy() {
  php5217_rmi
}

php5328_run() {
  sudo docker run \
    --name php5328 \
    --net host \
    --volumes-from apache \
    -d \
    simpledrupalcloud/php:5.3.28
}

php5328_stop() {
  sudo docker stop php5328
}

php5328_rm() {
  php5328_stop

  sudo docker rm php5328
}

php5328_rmi() {
  php5328_rm

  sudo docker rmi simpledrupalcloud/php:5.3.28
}

php5328_pull() {
  sudo docker pull simpledrupalcloud/php:5.3.28
}

php5328_update() {
  php5328_rm
  php5328_pull
  php5328_run
}

php5328_start() {
  php5328_rm
  php5328_run
}

php5328_restart() {
  php5328_rm
  php5328_run
}

php5328_destroy() {
  php5328_rmi
}

php5431_run() {
  sudo docker run \
    --name php5431 \
    --net host \
    --volumes-from apache \
    -d \
    simpledrupalcloud/php:5.4.31
}

php5431_stop() {
  sudo docker stop php5431
}

php5431_rm() {
  php5431_stop

  sudo docker rm php5431
}

php5431_rmi() {
  php5431_rm

  sudo docker rmi simpledrupalcloud/php:5.4.31
}

php5431_pull() {
  sudo docker pull simpledrupalcloud/php:5.4.31
}

php5431_update() {
  php5431_rm
  php5431_pull
  php5431_run
}

php5431_start() {
  php5431_rm
  php5431_run
}

php5431_restart() {
  php5431_rm
  php5431_run
}

php5431_destroy() {
  php5431_rmi
}

php5515_run() {
  sudo docker run \
    --name php5515 \
    --net host \
    --volumes-from apache \
    -d \
    simpledrupalcloud/php:5.5.15
}

php5515_stop() {
  sudo docker stop php5515
}

php5515_rm() {
  php5515_stop

  sudo docker rm php5515
}

php5515_rmi() {
  php5515_rm

  sudo docker rmi simpledrupalcloud/php:5.5.15
}

php5515_pull() {
  sudo docker pull simpledrupalcloud/php:5.5.15
}

php5515_update() {
  php5515_rm
  php5515_pull
  php5515_run
}

php5515_start() {
  php5515_rm
  php5515_run
}

php5515_restart() {
  php5515_rm
  php5515_run
}

php5515_destroy() {
  php5515_rmi
}

mysql_run() {
  sudo docker run \
    --name mysql \
    --net host \
    -v /var/mysql-5.5.38/conf.d:/mysql-5.5.38/conf.d \
    -v /var/mysql-5.5.38/data:/mysql-5.5.38/data \
    -v /var/mysql-5.5.38/log:/mysql-5.5.38/log \
    -d \
    simpledrupalcloud/mysql:5.5.38
}

mysql_stop() {
  sudo docker stop mysql
}

mysql_rm() {
  mysql_stop

  sudo docker rm mysql
}

mysql_rmi() {
  mysql_rm

  sudo docker rmi simpledrupalcloud/mysql:5.5.38
}

mysql_pull() {
  sudo docker pull simpledrupalcloud/mysql:5.5.38
}

mysql_update() {
  mysql_rm
  mysql_pull
  mysql_run
}

mysql_start() {
  mysql_rm
  mysql_run
}

mysql_restart() {
  mysql_rm
  mysql_run
}

mysql_destroy() {
  mysql_rmi
}

install() {
  sudo apt-get install -y realpath

  SCRIPT=$(realpath -s $0)

  if [ "${SCRIPT}" = /usr/local/bin/dev ]; then
    cat << EOF
dev is already installed on this machine.

Type "dev update" to get the latest updates.
EOF
    exit
  fi

  sudo apt-get install -y curl

  curl -sSL https://get.docker.io/ubuntu/ | sudo bash

  apache_update

  cp ./php5-fcgi /var/apache-2.2.22/conf.d

  php5217_update
  php5328_update
  php5328_update
  php5431_update
  mysql_update

  sudo cp "${SCRIPT}" /usr/local/bin/dev
}

update() {
  TMP=$(mktemp -d)

  git clone http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git "${TMP}"

  "${TMP}"/dev.sh install
}

start() {
  apache_start
  php5217_start
  php5328_start
  php5431_start
  php5515_start
  mysql_start
}

restart() {
  apache_restart
  php5217_restart
  php5328_restart
  php5431_restart
  php5515_restart
  mysql_restart
}

destroy() {
  apache_destroy
  php5217_destroy
  php5328_destroy
  php5431_destroy
  php5515_destroy
  mysql_destroy
}

case "${1}" in
  install)
    install
    ;;
  update)
    update
    ;;
  start)
    start
    ;;
  restart)
    restart
    ;;
  destroy)
    destroy
    ;;
esac
