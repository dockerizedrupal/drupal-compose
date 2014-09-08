#!/usr/bin/env bash

docker_mailcatcher_run() {
  sudo docker run \
    --name mailcatcher \
    --net host \
    -d \
    simpledrupalcloud/mailcatcher:0.5.12
}

docker_mailcatcher_stop() {
  sudo docker stop mailcatcher
}

docker_mailcatcher_rm() {
  docker_mailcatcher_stop

  sudo docker rm mailcatcher
}

docker_mailcatcher_rmi() {
  docker_mailcatcher_rm

  sudo docker rmi simpledrupalcloud/mailcatcher:0.5.12
}

docker_mailcatcher_pull() {
  sudo docker pull simpledrupalcloud/mailcatcher:0.5.12
}

docker_mailcatcher_update() {
  docker_mailcatcher_rm
  docker_mailcatcher_pull
  docker_mailcatcher_run
}

docker_mailcatcher_start() {
  docker_mailcatcher_rm
  docker_mailcatcher_run
}

docker_mailcatcher_restart() {
  docker_mailcatcher_rm
  docker_mailcatcher_run
}

docker_mailcatcher_destroy() {
  docker_mailcatcher_rmi
}

docker_apache_run() {
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

docker_apache_stop() {
  sudo docker stop apache
}

docker_apache_rm() {
  docker_apache_stop

  sudo docker rm apache
}

docker_apache_rmi() {
  docker_apache_rm

  sudo docker rmi simpledrupalcloud/apache:2.2.22
}

docker_apache_pull() {
  sudo docker pull simpledrupalcloud/apache:2.2.22
}

docker_apache_update() {
  docker_apache_rm
  docker_apache_pull
  docker_apache_run
}

docker_apache_start() {
  docker_apache_rm
  docker_apache_run
}

docker_apache_restart() {
  docker_apache_rm
  docker_apache_run
}

docker_apache_destroy() {
  docker_apache_rmi
}

docker_php5217_run() {
  sudo docker run \
    --name php5217 \
    --net host \
    --volumes-from apache \
    -d \
    simpledrupalcloud/php:5.2.17
}

docker_php5217_stop() {
  sudo docker stop php5217
}

docker_php5217_rm() {
  docker_php5217_stop

  sudo docker rm php5217
}

docker_php5217_rmi() {
  docker_php5217_rm

  sudo docker rmi simpledrupalcloud/php:5.2.17
}

docker_php5217_pull() {
  sudo docker pull simpledrupalcloud/php:5.2.17
}

docker_php5217_update() {
  docker_php5217_rm
  docker_php5217_pull
  docker_php5217_run
}

docker_php5217_start() {
  docker_php5217_rm
  docker_php5217_run
}

docker_php5217_restart() {
  docker_php5217_rm
  docker_php5217_run
}

docker_php5217_destroy() {
  docker_php5217_rmi
}

docker_php5328_run() {
  sudo docker run \
    --name php5328 \
    --net host \
    --volumes-from apache \
    -d \
    simpledrupalcloud/php:5.3.28
}

docker_php5328_stop() {
  sudo docker stop php5328
}

docker_php5328_rm() {
  docker_php5328_stop

  sudo docker rm php5328
}

docker_php5328_rmi() {
  docker_php5328_rm

  sudo docker rmi simpledrupalcloud/php:5.3.28
}

docker_php5328_pull() {
  sudo docker pull simpledrupalcloud/php:5.3.28
}

docker_php5328_update() {
  docker_php5328_rm
  docker_php5328_pull
  docker_php5328_run
}

docker_php5328_start() {
  docker_php5328_rm
  docker_php5328_run
}

docker_php5328_restart() {
  docker_php5328_rm
  docker_php5328_run
}

docker_php5328_destroy() {
  docker_php5328_rmi
}

docker_php5431_run() {
  sudo docker run \
    --name php5431 \
    --net host \
    --volumes-from apache \
    -d \
    simpledrupalcloud/php:5.4.31
}

docker_php5431_stop() {
  sudo docker stop php5431
}

docker_php5431_rm() {
  docker_php5431_stop

  sudo docker rm php5431
}

docker_php5431_rmi() {
  docker_php5431_rm

  sudo docker rmi simpledrupalcloud/php:5.4.31
}

docker_php5431_pull() {
  sudo docker pull simpledrupalcloud/php:5.4.31
}

docker_php5431_update() {
  docker_php5431_rm
  docker_php5431_pull
  docker_php5431_run
}

docker_php5431_start() {
  docker_php5431_rm
  docker_php5431_run
}

docker_php5431_restart() {
  docker_php5431_rm
  docker_php5431_run
}

docker_php5431_destroy() {
  docker_php5431_rmi
}

docker_php5515_run() {
  sudo docker run \
    --name php5515 \
    --net host \
    --volumes-from apache \
    -d \
    simpledrupalcloud/php:5.5.15
}

docker_php5515_stop() {
  sudo docker stop php5515
}

docker_php5515_rm() {
  docker_php5515_stop

  sudo docker rm php5515
}

docker_php5515_rmi() {
  docker_php5515_rm

  sudo docker rmi simpledrupalcloud/php:5.5.15
}

docker_php5515_pull() {
  sudo docker pull simpledrupalcloud/php:5.5.15
}

docker_php5515_update() {
  docker_php5515_rm
  docker_php5515_pull
  docker_php5515_run
}

docker_php5515_start() {
  docker_php5515_rm
  docker_php5515_run
}

docker_php5515_restart() {
  docker_php5515_rm
  docker_php5515_run
}

docker_php5515_destroy() {
  docker_php5515_rmi
}

docker_mysql_run() {
  sudo docker run \
    --name mysql \
    --net host \
    -v /var/mysql-5.5.38/conf.d:/mysql-5.5.38/conf.d \
    -v /var/mysql-5.5.38/data:/mysql-5.5.38/data \
    -v /var/mysql-5.5.38/log:/mysql-5.5.38/log \
    -d \
    simpledrupalcloud/mysql:5.5.38
}

docker_mysql_stop() {
  sudo docker stop mysql
}

docker_mysql_rm() {
  docker_mysql_stop

  sudo docker rm mysql
}

docker_mysql_rmi() {
  docker_mysql_rm

  sudo docker rmi simpledrupalcloud/mysql:5.5.38
}

docker_mysql_pull() {
  sudo docker pull simpledrupalcloud/mysql:5.5.38
}

docker_mysql_update() {
  docker_mysql_rm
  docker_mysql_pull
  docker_mysql_run
}

docker_mysql_start() {
  docker_mysql_rm
  docker_mysql_run
}

docker_mysql_restart() {
  docker_mysql_rm
  docker_mysql_run
}

docker_mysql_destroy() {
  docker_mysql_rmi
}

phpmyadmin() {
  TMP=$(mktemp -d)

  sudo wget http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/4.2.8/phpMyAdmin-4.2.8-english.zip -O "${TMP}/phpMyAdmin-4.2.8-english.zip"

  sudo apt-get install -y unzip

  sudo unzip "${TMP}/phpMyAdmin-4.2.8-english.zip" -d /var/apache-2.2.22/data

  sudo rm -rf /var/apache-2.2.22/data/phpmyadmin

  sudo mv /var/apache-2.2.22/data/phpMyAdmin-4.2.8-english /var/apache-2.2.22/data/phpmyadmin
}

install() {
  sudo apt-get install -y realpath

  SCRIPT=$(realpath -s "${0}")

  if [ "${SCRIPT}" = /usr/local/bin/dev ]; then
    cat << EOF
dev is already installed on this machine.

Type "dev update" to get the latest updates.
EOF
    exit
  fi

  sudo apt-get install -y curl

  curl -sSL https://get.docker.io/ubuntu/ | sudo bash

  docker_apache_update

  sudo cp $(dirname "${0}")/php5-fcgi /var/apache-2.2.22/conf.d

  docker_apache_update

  docker_php5217_update
  docker_php5328_update
  docker_php5328_update
  docker_php5431_update
  docker_php5515_update
  docker_mysql_update
  docker_mailcatcher_update

  phpmyadmin

  sudo cp $(dirname "${0}")/config.inc.php /var/apache-2.2.22/data/phpmyadmin

  sudo chown www-data.www-data /var/apache-2.2.22/data -R

  sudo cp "${SCRIPT}" /usr/local/bin/dev
}

update() {
  TMP=$(mktemp -d)

  git clone http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git "${TMP}"

  "${TMP}"/dev.sh install
}

start() {
  docker_apache_start
  docker_php5217_start
  docker_php5328_start
  docker_php5431_start
  docker_php5515_start
  docker_mysql_start
  docker_mailcatcher_start
}

restart() {
  docker_apache_restart
  docker_php5217_restart
  docker_php5328_restart
  docker_php5431_restart
  docker_php5515_restart
  docker_mysql_restart
  docker_mailcatcher_restart
}

destroy() {
  docker_apache_destroy
  docker_php5217_destroy
  docker_php5328_destroy
  docker_php5431_destroy
  docker_php5515_destroy
  docker_mysql_destroy
  docker_mailcatcher_destroy
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
    restart "${2}"
    ;;
  destroy)
    destroy
    ;;
esac
