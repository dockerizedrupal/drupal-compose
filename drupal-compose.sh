#!/usr/bin/env bash

VERSION="1.4.3"

WORKING_DIR="$(pwd)"

help() {
  cat << EOF
Version: ${VERSION}

Usage: drupal-compose

Options:
  -f, --file FILE  Specify an alternate compose file (default: docker-compose.yml)
  -v, --version     Show version number
  -h, --help        Show help
EOF

  exit 1
}

version() {
  help
}

if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
  help
fi

if [ "${1}" == "-v" ] || [ "${1}" == "--version" ]; then
  version
fi

APACHE_22_VERSION_FILE_URL="https://raw.githubusercontent.com/dockerizedrupal/docker-apache-2.2/master/VERSION.md"
APACHE_22_TAG="$(wget ${APACHE_22_VERSION_FILE_URL} -q -O -)"

if [ -z "${APACHE_22_TAG}" ]; then
  APACHE_22_TAG="1.2.3"

  echo "drupal-compose: Couldn't retrieve the latest Apache 2.2 image version. Falling back to last known stable version: ${APACHE_22_TAG}."
fi

APACHE_24_VERSION_FILE_URL="https://raw.githubusercontent.com/dockerizedrupal/docker-apache-2.4/master/VERSION.md"
APACHE_24_TAG="$(wget ${APACHE_24_VERSION_FILE_URL} -q -O -)"

if [ -z "${APACHE_24_TAG}" ]; then
  APACHE_24_TAG="1.2.4"

  echo "drupal-compose: Couldn't retrieve the latest Apache 2.4 image version. Falling back to last known stable version: ${APACHE_24_TAG}."
fi

PHP_52_VERSION_FILE_URL="https://raw.githubusercontent.com/dockerizedrupal/docker-php-5.2/master/VERSION.md"
PHP_52_TAG="$(wget ${PHP_52_VERSION_FILE_URL} -q -O -)"

if [ -z "${PHP_52_TAG}" ]; then
  PHP_52_TAG="1.2.7"

  echo "drupal-compose: Couldn't retrieve the latest PHP 5.2 image version. Falling back to last known stable version: ${PHP_52_TAG}."
fi

PHP_53_VERSION_FILE_URL="https://raw.githubusercontent.com/dockerizedrupal/docker-php-5.3/master/VERSION.md"
PHP_53_TAG="$(wget ${PHP_53_VERSION_FILE_URL} -q -O -)"

if [ -z "${PHP_53_TAG}" ]; then
  PHP_53_TAG="1.2.11"

  echo "drupal-compose: Couldn't retrieve the latest PHP 5.3 image version. Falling back to last known stable version: ${PHP_53_TAG}."
fi

PHP_54_VERSION_FILE_URL="https://raw.githubusercontent.com/dockerizedrupal/docker-php-5.4/master/VERSION.md"
PHP_54_TAG="$(wget ${PHP_54_VERSION_FILE_URL} -q -O -)"

if [ -z "${PHP_54_TAG}" ]; then
  PHP_54_TAG="1.2.9"

  echo "drupal-compose: Couldn't retrieve the latest PHP 5.4 image version. Falling back to last known stable version: ${PHP_54_TAG}."
fi

PHP_55_VERSION_FILE_URL="https://raw.githubusercontent.com/dockerizedrupal/docker-php-5.5/master/VERSION.md"
PHP_55_TAG="$(wget ${PHP_55_VERSION_FILE_URL} -q -O -)"

if [ -z "${PHP_55_TAG}" ]; then
  PHP_55_TAG="1.2.11"

  echo "drupal-compose: Couldn't retrieve the latest PHP 5.5 image version. Falling back to last known stable version: ${PHP_55_TAG}."
fi

PHP_56_VERSION_FILE_URL="https://raw.githubusercontent.com/dockerizedrupal/docker-php-5.6/master/VERSION.md"
PHP_56_TAG="$(wget ${PHP_56_VERSION_FILE_URL} -q -O -)"

if [ -z "${PHP_56_TAG}" ]; then
  PHP_56_TAG="1.2.9"

  echo "drupal-compose: Couldn't retrieve the latest PHP 5.6 image version. Falling back to last known stable version: ${PHP_56_TAG}."
fi

PHP_70_VERSION_FILE_URL="https://raw.githubusercontent.com/dockerizedrupal/docker-php-7.0/master/VERSION.md"
PHP_70_TAG="$(wget ${PHP_70_VERSION_FILE_URL} -q -O -)"

if [ -z "${PHP_70_TAG}" ]; then
  PHP_70_TAG="1.1.2"

  echo "drupal-compose: Couldn't retrieve the latest PHP 7.0 image version. Falling back to last known stable version: ${PHP_70_TAG}."
fi

MYSQL_VERSION_FILE_URL="https://raw.githubusercontent.com/dockerizedrupal/docker-mysql/master/VERSION.md"
MYSQL_TAG="$(wget ${MYSQL_VERSION_FILE_URL} -q -O -)"

if [ -z "${MYSQL_TAG}" ]; then
  MYSQL_TAG="1.2.2"

  echo "drupal-compose: Couldn't retrieve the latest MySQL image version. Falling back to last known stable version: ${MYSQL_TAG}."
fi

MAILCATCHER_VERSION_FILE_URL="https://raw.githubusercontent.com/dockerizedrupal/docker-mailcatcher/master/VERSION.md"
MAILCATCHER_TAG="$(wget ${MAILCATCHER_VERSION_FILE_URL} -q -O -)"

if [ -z "${MAILCATCHER_TAG}" ]; then
  MAILCATCHER_TAG="1.1.1"

  echo "drupal-compose: Couldn't retrieve the latest MySQL image version. Falling back to last known stable version: ${MAILCATCHER_TAG}."
fi

PHPMYADMIN_VERSION_FILE_URL="https://raw.githubusercontent.com/dockerizedrupal/docker-phpmyadmin/master/VERSION.md"
PHPMYADMIN_TAG="$(wget ${PHPMYADMIN_VERSION_FILE_URL} -q -O -)"

if [ -z "${PHPMYADMIN_TAG}" ]; then
  PHPMYADMIN_TAG="1.1.1"

  echo "drupal-compose: Couldn't retrieve the latest PhpMyAdmin image version. Falling back to last known stable version: ${PHPMYADMIN_TAG}."
fi

ADMINER_VERSION_FILE_URL="https://raw.githubusercontent.com/dockerizedrupal/docker-adminer/master/VERSION.md"
ADMINER_TAG="$(wget ${ADMINER_VERSION_FILE_URL} -q -O -)"

if [ -z "${ADMINER_TAG}" ]; then
  ADMINER_TAG="1.1.1"

  echo "drupal-compose: Couldn't retrieve the latest Adminer image version. Falling back to last known stable version: ${ADMINER_TAG}."
fi

MEMCACHED_VERSION_FILE_URL="https://raw.githubusercontent.com/dockerizedrupal/docker-memcached/master/VERSION.md"
MEMCACHED_TAG="$(wget ${MEMCACHED_VERSION_FILE_URL} -q -O -)"

if [ -z "${MEMCACHED_TAG}" ]; then
  MEMCACHED_TAG="1.1.0"

  echo "drupal-compose: Couldn't retrieve the latest Memcached image version. Falling back to last known stable version: ${MEMCACHED_TAG}."
fi

MEMCACHEPHP_VERSION_FILE_URL="https://raw.githubusercontent.com/dockerizedrupal/docker-memcachephp/master/VERSION.md"
MEMCACHEPHP_TAG="$(wget ${MEMCACHEPHP_VERSION_FILE_URL} -q -O -)"

if [ -z "${MEMCACHEPHP_TAG}" ]; then
  MEMCACHEPHP_TAG="1.1.1"

  echo "drupal-compose: Couldn't retrieve the latest memcache.php image version. Falling back to last known stable version: ${MEMCACHEPHP_TAG}."
fi

DOCKER_COMPOSE_FILE="docker-compose.yml"

if [ "${1}" == "-f" ] || [ "${1}" == "--file" ]; then
  DOCKER_COMPOSE_FILE="${2}"

  set "${@:1}" > /dev/null 2>&1
  set "${@:2}" > /dev/null 2>&1
fi

docker_compose_file_path() {
  local DOCKER_COMPOSE_FILE_PATH=""

  while [ "$(pwd)" != '/' ]; do
    if [ "$(ls ${DOCKER_COMPOSE_FILE} 2> /dev/null)" == "${DOCKER_COMPOSE_FILE}" ]; then
      DOCKER_COMPOSE_FILE_PATH="$(pwd)"

      break
    fi

    cd ..
  done

  echo "${DOCKER_COMPOSE_FILE_PATH}"
}

general_docker_compose_template() {
  local PROJECT_NAME="${1}"

  cat <<EOF
# Configuration generated with Drupal Compose version ${VERSION}
apache:
  extends:
    file: host.yml
    service: apache
  image: dockerizedrupal/apache-2.4:${APACHE_24_TAG}
  hostname: apache
  volumes_from:
    - apache-data
  links:
    - php
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_PRIMARY_SERVICE=True
    - VHOST_SERVICE_NAME=apache
    - VHOST_VERSION_FILE_URL=${APACHE_24_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/apache-2.4/
apache-data:
  image: dockerizedrupal/apache-2.4:${APACHE_24_TAG}
  hostname: apache-data
  entrypoint: ["/bin/echo", "Data-only container for Apache."]
  volumes:
    - .:/apache/data
mysql:
  image: dockerizedrupal/mysql:${MYSQL_TAG}
  hostname: mysql
  volumes_from:
    - mysql-data
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=mysql
    - VHOST_VERSION_FILE_URL=${MYSQL_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/mysql/
mysql-data:
  image: dockerizedrupal/mysql:${MYSQL_TAG}
  hostname: mysql-data
  entrypoint: ["/bin/echo", "Data-only container for MySQL."]
  volumes:
    - /mysql
php:
  extends:
    file: host.yml
    service: php
  image: dockerizedrupal/php-7.0:${PHP_70_TAG}
  hostname: php
  volumes:
    - ~/.ssh:/home/container/.ssh
  volumes_from:
    - apache-data
  links:
    - mysql
    - mailcatcher:smtp
    - memcached
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=php
    - VHOST_VERSION_FILE_URL=${PHP_70_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/php-7.0/
mailcatcher:
  image: dockerizedrupal/mailcatcher:${MAILCATCHER_TAG}
  hostname: mailcatcher
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=mailcatcher
    - VHOST_VERSION_FILE_URL=${MAILCATCHER_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/mailcatcher/
phpmyadmin:
  image: dockerizedrupal/phpmyadmin:${PHPMYADMIN_TAG}
  hostname: phpmyadmin
  links:
    - mysql
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=phpmyadmin
    - VHOST_VERSION_FILE_URL=${PHPMYADMIN_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/phpmyadmin/
adminer:
  image: dockerizedrupal/adminer:${ADMINER_TAG}
  hostname: adminer
  links:
    - mysql
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=adminer
    - VHOST_VERSION_FILE_URL=${ADMINER_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/adminer/
memcached:
  image: dockerizedrupal/memcached:${MEMCACHED_TAG}
  hostname: memcached
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=memcached
    - VHOST_VERSION_FILE_URL=${MEMCACHED_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/memcached/
memcachephp:
  image: dockerizedrupal/memcachephp:${MEMCACHEPHP_TAG}
  hostname: memcachephp
  links:
    - memcached
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=memcachedphp
    - VHOST_VERSION_FILE_URL=${MEMCACHEPHP_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/memcachephp/
EOF
}

drupal_8_docker_compose_template() {
  local PROJECT_NAME="${1}"

  cat <<EOF
# Configuration generated with Drupal Compose version ${VERSION}
apache:
  extends:
    file: host.yml
    service: apache
  image: dockerizedrupal/apache-2.4:${APACHE_24_TAG}
  hostname: apache
  volumes_from:
    - apache-data
  links:
    - php
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_PRIMARY_SERVICE=True
    - VHOST_SERVICE_NAME=apache
    - VHOST_VERSION_FILE_URL=${APACHE_24_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/apache-2.4/
    - NO_GZIP=On
apache-data:
  image: dockerizedrupal/apache-2.4:${APACHE_24_TAG}
  hostname: apache-data
  entrypoint: ["/bin/echo", "Data-only container for Apache."]
  volumes:
    - .:/apache/data
mysql:
  image: dockerizedrupal/mysql:${MYSQL_TAG}
  hostname: mysql
  volumes_from:
    - mysql-data
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=mysql
    - VHOST_VERSION_FILE_URL=${MYSQL_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/mysql/
mysql-data:
  image: dockerizedrupal/mysql:${MYSQL_TAG}
  hostname: mysql-data
  entrypoint: ["/bin/echo", "Data-only container for MySQL."]
  volumes:
    - /mysql
php:
  extends:
    file: host.yml
    service: php
  image: dockerizedrupal/php-5.5:${PHP_55_TAG}
  hostname: php
  volumes:
    - ~/.ssh:/home/container/.ssh
  volumes_from:
    - apache-data
  links:
    - mysql
    - mailcatcher:smtp
    - memcached
  environment:
    - DRUPAL_VERSION=8
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=php
    - VHOST_VERSION_FILE_URL=${PHP_55_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/php-5.5/
mailcatcher:
  image: dockerizedrupal/mailcatcher:${MAILCATCHER_TAG}
  hostname: mailcatcher
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=mailcatcher
    - VHOST_VERSION_FILE_URL=${MAILCATCHER_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/mailcatcher/
phpmyadmin:
  image: dockerizedrupal/phpmyadmin:${PHPMYADMIN_TAG}
  hostname: phpmyadmin
  links:
    - mysql
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=phpmyadmin
    - VHOST_VERSION_FILE_URL=${PHPMYADMIN_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/phpmyadmin/
adminer:
  image: dockerizedrupal/adminer:${ADMINER_TAG}
  hostname: adminer
  links:
    - mysql
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=adminer
    - VHOST_VERSION_FILE_URL=${ADMINER_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/adminer/
memcached:
  image: dockerizedrupal/memcached:${MEMCACHED_TAG}
  hostname: memcached
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=memcached
    - VHOST_VERSION_FILE_URL=${MEMCACHED_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/memcached/
memcachephp:
  image: dockerizedrupal/memcachephp:${MEMCACHEPHP_TAG}
  hostname: memcachephp
  links:
    - memcached
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=memcachedphp
    - VHOST_VERSION_FILE_URL=${MEMCACHEPHP_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/memcachephp/
EOF
}

drupal_8_path() {
  local DRUPAL_8_PATH=""

  while [ "$(pwd)" != '/' ]; do
    if [ "$(ls index.php 2> /dev/null)" == "index.php" ]; then
      if [ -n "$(cat index.php | grep "^\$autoloader" 2> /dev/null)" ]; then
        DRUPAL_8_PATH="$(pwd)"

        break
      fi
    fi

    cd ..
  done

  echo "${DRUPAL_8_PATH}"
}

drupal_7_docker_compose_template() {
  local PROJECT_NAME="${1}"

  cat <<EOF
# Configuration generated with Drupal Compose version ${VERSION}
apache:
  extends:
    file: host.yml
    service: apache
  image: dockerizedrupal/apache-2.4:${APACHE_24_TAG}
  hostname: apache
  volumes_from:
    - apache-data
  links:
    - php
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_PRIMARY_SERVICE=True
    - VHOST_SERVICE_NAME=apache
    - VHOST_VERSION_FILE_URL=${APACHE_24_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/apache-2.4/
apache-data:
  image: dockerizedrupal/apache-2.4:${APACHE_24_TAG}
  hostname: apache-data
  entrypoint: ["/bin/echo", "Data-only container for Apache."]
  volumes:
    - .:/apache/data
mysql:
  image: dockerizedrupal/mysql:${MYSQL_TAG}
  hostname: mysql
  volumes_from:
    - mysql-data
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=mysql
    - VHOST_VERSION_FILE_URL=${MYSQL_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/mysql/
mysql-data:
  image: dockerizedrupal/mysql:${MYSQL_TAG}
  hostname: mysql-data
  entrypoint: ["/bin/echo", "Data-only container for MySQL."]
  volumes:
    - /mysql
php:
  extends:
    file: host.yml
    service: php
  image: dockerizedrupal/php-5.4:${PHP_54_TAG}
  hostname: php
  volumes:
    - ~/.ssh:/home/container/.ssh
  volumes_from:
    - apache-data
  links:
    - mysql
    - mailcatcher:smtp
    - memcached
  environment:
    - DRUPAL_VERSION=7
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=php
    - VHOST_VERSION_FILE_URL=${PHP_54_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/php-5.4/
mailcatcher:
  image: dockerizedrupal/mailcatcher:${MAILCATCHER_TAG}
  hostname: mailcatcher
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=mailcatcher
    - VHOST_VERSION_FILE_URL=${MAILCATCHER_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/mailcatcher/
phpmyadmin:
  image: dockerizedrupal/phpmyadmin:${PHPMYADMIN_TAG}
  hostname: phpmyadmin
  links:
    - mysql
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=phpmyadmin
    - VHOST_VERSION_FILE_URL=${PHPMYADMIN_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/phpmyadmin/
adminer:
  image: dockerizedrupal/adminer:${ADMINER_TAG}
  hostname: adminer
  links:
    - mysql
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=adminer
    - VHOST_VERSION_FILE_URL=${ADMINER_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/adminer/
memcached:
  image: dockerizedrupal/memcached:${MEMCACHED_TAG}
  hostname: memcached
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=memcached
    - VHOST_VERSION_FILE_URL=${MEMCACHED_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/memcached/
memcachephp:
  image: dockerizedrupal/memcachephp:${MEMCACHEPHP_TAG}
  hostname: memcachephp
  links:
    - memcached
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=memcachephp
    - VHOST_VERSION_FILE_URL=${MEMCACHEPHP_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/memcachephp/
EOF
}

drupal_7_path() {
  local DRUPAL_7_PATH=""

  while [ "$(pwd)" != '/' ]; do
    if [ "$(ls index.php 2> /dev/null)" == "index.php" ]; then
      if [ -n "$(cat index.php | grep "^menu_execute_active_handler" 2> /dev/null)" ]; then
        DRUPAL_7_PATH="$(pwd)"

        break
      fi
    fi

    cd ..
  done

  echo "${DRUPAL_7_PATH}"
}

drupal_6_docker_compose_template() {
  local PROJECT_NAME="${1}"

  cat <<EOF
# Configuration generated with Drupal Compose version ${VERSION}
apache:
  extends:
    file: host.yml
    service: apache
  image: dockerizedrupal/apache-2.2:${APACHE_22_TAG}
  hostname: apache
  volumes_from:
    - apache-data
  links:
    - php
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_PRIMARY_SERVICE=True
    - VHOST_SERVICE_NAME=apache
    - VHOST_VERSION_FILE_URL=${APACHE_22_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/apache-2.2/
apache-data:
  image: dockerizedrupal/apache-2.2:${APACHE_22_TAG}
  hostname: apache-data
  entrypoint: ["/bin/echo", "Data-only container for Apache."]
  volumes:
    - .:/apache/data
mysql:
  image: dockerizedrupal/mysql:${MYSQL_TAG}
  hostname: mysql
  volumes_from:
    - mysql-data
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=mysql
    - VHOST_VERSION_FILE_URL=${MYSQL_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/mysql/
mysql-data:
  image: dockerizedrupal/mysql:${MYSQL_TAG}
  hostname: mysql-data
  entrypoint: ["/bin/echo", "Data-only container for MySQL."]
  volumes:
    - /mysql
php:
  extends:
    file: host.yml
    service: php
  image: dockerizedrupal/php-5.2:${PHP_52_TAG}
  hostname: php
  volumes:
    - ~/.ssh:/home/container/.ssh
  volumes_from:
    - apache-data
  links:
    - mysql
    - mailcatcher:smtp
    - memcached
  environment:
    - DRUPAL_VERSION=6
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=php
    - VHOST_VERSION_FILE_URL=${PHP_52_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/php-5.2/
mailcatcher:
  image: dockerizedrupal/mailcatcher:${MAILCATCHER_TAG}
  hostname: mailcatcher
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=mailcatcher
    - VHOST_VERSION_FILE_URL=${MAILCATCHER_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/mailcatcher/
phpmyadmin:
  image: dockerizedrupal/phpmyadmin:${PHPMYADMIN_TAG}
  hostname: phpmyadmin
  links:
    - mysql
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=phpmyadmin
    - VHOST_VERSION_FILE_URL=${PHPMYADMIN_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/phpmyadmin/
adminer:
  image: dockerizedrupal/adminer:${ADMINER_TAG}
  hostname: adminer
  links:
    - mysql
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=adminer
    - VHOST_VERSION_FILE_URL=${ADMINER_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/adminer/
memcached:
  image: dockerizedrupal/memcached:${MEMCACHED_TAG}
  hostname: memcached
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=memcached
    - VHOST_VERSION_FILE_URL=${MEMCACHED_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/memcached/
memcachephp:
  image: dockerizedrupal/memcachephp:${MEMCACHEPHP_TAG}
  hostname: memcachephp
  links:
    - memcached
  environment:
    - VHOST_PROJECT_NAME=${PROJECT_NAME}
    - VHOST_SERVICE_NAME=memcachephp
    - VHOST_VERSION_FILE_URL=${MEMCACHEPHP_VERSION_FILE_URL}
    - VHOST_REPOSITORY_URL=https://hub.docker.com/r/dockerizedrupal/memcachephp/
EOF
}

drupal_6_path() {
  local DRUPAL_6_PATH=""

  while [ "$(pwd)" != '/' ]; do
    if [ "$(ls index.php 2> /dev/null)" == "index.php" ]; then
      if [ -n "$(cat index.php | grep "^drupal_page_footer" 2> /dev/null)" ]; then
        DRUPAL_6_PATH="$(pwd)"

        break
      fi
    fi

    cd ..
  done

  echo "${DRUPAL_6_PATH}"
}

host_docker_compose_template() {
  local USER_ID="$(id -u)"
  local GROUP_ID="$(id -g)"

  cat <<EOF
# Configuration generated with Drupal Compose version ${VERSION}
apache:
  environment:
    - USER_ID=${USER_ID}
    - GROUP_ID=${GROUP_ID}
php:
  environment:
    - USER_ID=${USER_ID}
    - GROUP_ID=${GROUP_ID}
EOF
}

DRUPAL_ROOT="$(docker_compose_file_path)"

case "${1}" in
  service)
    case "${2}" in
      php)
        case "${3}" in
          set)
            case "${4}" in
              version)
                case "${5}" in
                  5.2)
                    sed -i "s/dockerizedrupal\/php-.*/dockerizedrupal\/php-5.2:${PHP_52_TAG}/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"
                    sed -i "s/dockerizedrupal\/apache.*/dockerizedrupal\/apache-2.2:${APACHE_22_TAG}/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"
                    sed -i "s/dockerizedrupal\/docker-php-.*/dockerizedrupal\/docker-php-5.2\/master\/VERSION.md/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"

                    echo "drupal-compose: PHP version changed to 5.2."
                  ;;
                  5.3)
                    sed -i "s/dockerizedrupal\/php-.*/dockerizedrupal\/php-5.3:${PHP_53_TAG}/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"
                    sed -i "s/dockerizedrupal\/apache.*/dockerizedrupal\/apache-2.4:${APACHE_24_TAG}/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"
                    sed -i "s/dockerizedrupal\/docker-php-.*/dockerizedrupal\/docker-php-5.3\/master\/VERSION.md/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"

                    echo "drupal-compose: PHP version changed to 5.3."
                  ;;
                  5.4)
                    sed -i "s/dockerizedrupal\/php-.*/dockerizedrupal\/php-5.4:${PHP_54_TAG}/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"
                    sed -i "s/dockerizedrupal\/apache.*/dockerizedrupal\/apache-2.4:${APACHE_24_TAG}/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"
                    sed -i "s/dockerizedrupal\/docker-php-.*/dockerizedrupal\/docker-php-5.4\/master\/VERSION.md/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"

                    echo "drupal-compose: PHP version changed to 5.4."
                  ;;
                  5.5)
                    sed -i "s/dockerizedrupal\/php-.*/dockerizedrupal\/php-5.5:${PHP_55_TAG}/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"
                    sed -i "s/dockerizedrupal\/apache.*/dockerizedrupal\/apache-2.4:${APACHE_24_TAG}/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"
                    sed -i "s/dockerizedrupal\/docker-php-.*/dockerizedrupal\/docker-php-5.5\/master\/VERSION.md/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"

                    echo "drupal-compose: PHP version changed to 5.5."
                  ;;
                  5.6)
                    sed -i "s/dockerizedrupal\/php-.*/dockerizedrupal\/php-5.6:${PHP_56_TAG}/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"
                    sed -i "s/dockerizedrupal\/apache.*/dockerizedrupal\/apache-2.4:${APACHE_24_TAG}/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"
                    sed -i "s/dockerizedrupal\/docker-php-.*/dockerizedrupal\/docker-php-5.6\/master\/VERSION.md/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"

                    echo "drupal-compose: PHP version changed to 5.6."
                  ;;
                  7.0)
                    sed -i "s/dockerizedrupal\/php-.*/dockerizedrupal\/php-7.0:${PHP_70_TAG}/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"
                    sed -i "s/dockerizedrupal\/apache.*/dockerizedrupal\/apache-2.4:${APACHE_24_TAG}/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"
                    sed -i "s/dockerizedrupal\/docker-php-.*/dockerizedrupal\/docker-php-7.0\/master\/VERSION.md/g" "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"

                    echo "drupal-compose: PHP version changed to 7.0."
                  ;;
                  -h|--help)
                    cat << EOF
Version: ${VERSION}

Usage: drupal-compose service php set version <VERSION>

Supported versions:
  5.2
  5.3
  5.4
  5.5
  5.6
  7.0
EOF

                    exit 1
                  ;;
                  *)
                    echo "drupal-compose: Unknown command. See 'drupal-compose service php set version --help'"

                    exit 1
                  ;;
                esac
              ;;
              -h|--help)
                cat << EOF
Version: ${VERSION}

Usage: drupal-compose service php set <KEY> <VALUE>

Supported keys:
  version
EOF

                exit 1
              ;;
              *)
                echo "drupal-compose: Unknown command. See 'drupal-compose service php set --help'"

                exit 1
              ;;
            esac
          ;;
          -h|--help)
            cat << EOF
Version: ${VERSION}

Usage: drupal-compose service php <ACTION>

Supported actions:
  set
EOF

            exit 1
          ;;
          *)
            echo "drupal-compose: Unknown command. See 'drupal-compose service php --help'"

            exit 1
          ;;
        esac
      ;;
      -h|--help)
        cat << EOF
Version: ${VERSION}

Usage: drupal-compose service <SERVICE>

Supported services:
  php
EOF

        exit 1
      ;;
      *)
        echo "drupal-compose: Unknown command. See 'drupal-compose service --help'"

        exit 1
      ;;
    esac
  ;;
  *)
    if [ "${#}" -gt 2 ]; then
      echo "drupal-compose: Unknown command. See 'drupal-compose --help'"

      exit 1
    fi

    if [ -n "${DRUPAL_ROOT}" ]; then
      read -p "drupal-compose: ${DOCKER_COMPOSE_FILE} file already exists, would you like to override it? [Y/n]: " ANSWER

      if [ "${ANSWER}" == "n" ]; then
        if [ ! -f "${DRUPAL_ROOT}/host.yml" ]; then
          read -p "drupal-compose: host.yml file is missing, would you like to create it? [Y/n]: " ANSWER

          if [ "${ANSWER}" == "n" ]; then
            exit
          fi

          echo -n "$(host_docker_compose_template)" > "${DRUPAL_ROOT}/host.yml"

          echo "drupal-compose: host.yml file has been created. Please don't add it to VCS, since this file is specific to the host where it was generated."
        fi

        exit
      fi
    fi

    DRUPAL_ROOT="$(drupal_8_path)"

    if [ -n "${DRUPAL_ROOT}" ]; then
      read -p "drupal-compose: Enter project name: " PROJECT_NAME

      echo -n "$(drupal_8_docker_compose_template ${PROJECT_NAME})" > "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"

      echo "drupal-compose: ${DOCKER_COMPOSE_FILE} file has been created. Don't forget to add it to VCS alongside with Drupal."

      echo -n "$(host_docker_compose_template)" > "${DRUPAL_ROOT}/host.yml"

      echo "drupal-compose: host.yml file has been created. Please don't add it to VCS, since this file is specific to the host where it was generated."

      exit
    fi

    DRUPAL_ROOT="$(drupal_7_path)"

    if [ -n "${DRUPAL_ROOT}" ]; then
      read -p "drupal-compose: Enter project name: " PROJECT_NAME

      echo -n "$(drupal_7_docker_compose_template ${PROJECT_NAME})" > "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"

      echo "drupal-compose: ${DOCKER_COMPOSE_FILE} file has been created. Don't forget to add it to VCS alongside with Drupal."

      echo -n "$(host_docker_compose_template)" > "${DRUPAL_ROOT}/host.yml"

      echo "drupal-compose: host.yml file has been created. Please don't add it to VCS, since this file is specific to the host where it was generated."

      exit
    fi

    DRUPAL_ROOT="$(drupal_6_path)"

    if [ -n "${DRUPAL_ROOT}" ]; then
      read -p "drupal-compose: Enter project name: " PROJECT_NAME

      echo -n "$(drupal_6_docker_compose_template ${PROJECT_NAME})" > "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"

      echo "drupal-compose: ${DOCKER_COMPOSE_FILE} file has been created. Don't forget to add it to VCS alongside with Drupal."

      echo -n "$(host_docker_compose_template)" > "${DRUPAL_ROOT}/host.yml"

      echo "drupal-compose: host.yml file has been created. Please don't add it to VCS, since this file is specific to the host where it was generated."

      exit
    fi

    read -p "drupal-compose: Drupal installation path could not be found, would you like to create general purpose ${DOCKER_COMPOSE_FILE} file for your application anyways? [Y/n]: " ANSWER

    if [ "${ANSWER}" == "n" ]; then
      exit
    fi

    read -p "drupal-compose: Enter project name: " PROJECT_NAME

    echo -n "$(general_docker_compose_template ${PROJECT_NAME})" > "${WORKING_DIR}/${DOCKER_COMPOSE_FILE}"

    echo "drupal-compose: ${DOCKER_COMPOSE_FILE} file has been created. Don't forget to add it to VCS alongside with Drupal."

    echo -n "$(host_docker_compose_template)" > "${WORKING_DIR}/host.yml"

    echo "drupal-compose: host.yml file has been created. Please don't add it to VCS, since this file is specific to the host where it was generated."
  ;;
esac
