#!/usr/bin/env bash

VERSION="1.0.4"

WORKING_DIR="$(pwd)"

help() {
  cat << EOF
Version: ${VERSION}

Usage: drupal-compose

Options:
  -f, --file FILE  Specify an alternate compose file (default: docker-compose.yml)
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

unknown_command() {
  echo "drupal-compose: Unknown command. See 'drupal-compose --help'"

  exit 1
}

if [ "${#}" -gt 2 ]; then
  unknown_command
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

drupal_8_docker_compose_template() {
  local PROJECT_NAME="${1}"

  cat <<EOF
# Configuration generated with Drupal Compose version ${VERSION}
apache:
  extends:
    file: host.yml
    service: apache
  image: dockerizedrupal/apache-2.4:1.0.6
  hostname: apache
  ports:
    - "80"
    - "443"
  volumes_from:
    - apache-data
  links:
    - php
  environment:
    - VHOST=${PROJECT_NAME}
apache-data:
  image: dockerizedrupal/data:1.0.2
  hostname: apache-data
  volumes:
    - .:/apache/data
mysql:
  image: dockerizedrupal/mysql:1.0.3
  hostname: mysql
  volumes_from:
    - mysql-data
mysql-data:
  image: dockerizedrupal/data:1.0.2
  hostname: mysql-data
  volumes:
    - /mysql
php:
  extends:
    file: host.yml
    service: php
  image: dockerizedrupal/php-5.4:1.0.2
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
mailcatcher:
  image: dockerizedrupal/mailcatcher:1.0.1
  hostname: mailcatcher
  ports:
    - "80"
    - "443"
  environment:
    - VHOST=${PROJECT_NAME}
phpmyadmin:
  image: dockerizedrupal/phpmyadmin:1.0.2
  hostname: phpmyadmin
  ports:
    - "80"
    - "443"
  links:
    - mysql
  environment:
    - VHOST=${PROJECT_NAME}
adminer:
  image: dockerizedrupal/adminer:1.0.2
  hostname: adminer
  ports:
    - "80"
    - "443"
  links:
    - mysql
  environment:
    - VHOST=${PROJECT_NAME}
memcached:
  image: dockerizedrupal/memcached:1.0.1
  hostname: memcached
memcachephp:
  image: dockerizedrupal/memcachephp:1.0.1
  hostname: memcachephp
  ports:
    - "80"
    - "443"
  links:
    - memcached
  environment:
    - VHOST=${PROJECT_NAME}
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
  image: dockerizedrupal/apache-2.4:1.0.6
  hostname: apache
  ports:
    - "80"
    - "443"
  volumes_from:
    - apache-data
  links:
    - php
  environment:
    - VHOST=${PROJECT_NAME}
apache-data:
  image: dockerizedrupal/data:1.0.2
  hostname: apache-data
  volumes:
    - .:/apache/data
mysql:
  image: dockerizedrupal/mysql:1.0.3
  hostname: mysql
  volumes_from:
    - mysql-data
mysql-data:
  image: dockerizedrupal/data:1.0.2
  hostname: mysql-data
  volumes:
    - /mysql
php:
  extends:
    file: host.yml
    service: php
  image: dockerizedrupal/php-5.3:1.0.2
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
mailcatcher:
  image: dockerizedrupal/mailcatcher:1.0.1
  hostname: mailcatcher
  ports:
    - "80"
    - "443"
  environment:
    - VHOST=${PROJECT_NAME}
phpmyadmin:
  image: dockerizedrupal/phpmyadmin:1.0.2
  hostname: phpmyadmin
  ports:
    - "80"
    - "443"
  links:
    - mysql
  environment:
    - VHOST=${PROJECT_NAME}
adminer:
  image: dockerizedrupal/adminer:1.0.2
  hostname: adminer
  ports:
    - "80"
    - "443"
  links:
    - mysql
  environment:
    - VHOST=${PROJECT_NAME}
memcached:
  image: dockerizedrupal/memcached:1.0.1
  hostname: memcached
memcachephp:
  image: dockerizedrupal/memcachephp:1.0.1
  hostname: memcachephp
  ports:
    - "80"
    - "443"
  links:
    - memcached
  environment:
    - VHOST=${PROJECT_NAME}
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
  image: dockerizedrupal/apache-2.2:1.0.3
  hostname: apache
  ports:
    - "80"
    - "443"
  volumes_from:
    - apache-data
  links:
    - php
  environment:
    - VHOST=${PROJECT_NAME}
apache-data:
  image: dockerizedrupal/data:1.0.2
  hostname: apache-data
  volumes:
    - .:/apache/data
mysql:
  image: dockerizedrupal/mysql:1.0.3
  hostname: mysql
  volumes_from:
    - mysql-data
mysql-data:
  image: dockerizedrupal/data:1.0.2
  hostname: mysql-data
  volumes:
    - /mysql
php:
  extends:
    file: host.yml
    service: php
  image: dockerizedrupal/php-5.2:1.0.1
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
mailcatcher:
  image: dockerizedrupal/mailcatcher:1.0.1
  hostname: mailcatcher
  ports:
    - "80"
    - "443"
  environment:
    - VHOST=${PROJECT_NAME}
phpmyadmin:
  image: dockerizedrupal/phpmyadmin:1.0.2
  hostname: phpmyadmin
  ports:
    - "80"
    - "443"
  links:
    - mysql
  environment:
    - VHOST=${PROJECT_NAME}
adminer:
  image: dockerizedrupal/adminer:1.0.2
  hostname: adminer
  ports:
    - "80"
    - "443"
  links:
    - mysql
  environment:
    - VHOST=${PROJECT_NAME}
memcached:
  image: dockerizedrupal/memcached:1.0.1
  hostname: memcached
memcachephp:
  image: dockerizedrupal/memcachephp:1.0.1
  hostname: memcachephp
  ports:
    - "80"
    - "443"
  links:
    - memcached
  environment:
    - VHOST=${PROJECT_NAME}
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
else
  DRUPAL_ROOT="$(drupal_7_path)"

  if [ -n "${DRUPAL_ROOT}" ]; then
    read -p "drupal-compose: Enter project name: " PROJECT_NAME

    echo -n "$(drupal_7_docker_compose_template ${PROJECT_NAME})" > "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"
  else
    DRUPAL_ROOT="$(drupal_6_path)"

    if [ -n "${DRUPAL_ROOT}" ]; then
      read -p "drupal-compose: Enter project name: " PROJECT_NAME

      echo -n "$(drupal_6_docker_compose_template ${PROJECT_NAME})" > "${DRUPAL_ROOT}/${DOCKER_COMPOSE_FILE}"
    else
      echo "drupal-compose: Drupal installation path could not be found."

      exit 1
    fi
  fi
fi

echo "drupal-compose: ${DOCKER_COMPOSE_FILE} file has been created. Don't forget to add it to VCS alongside with Drupal."

echo -n "$(host_docker_compose_template)" > "${DRUPAL_ROOT}/host.yml"

echo "drupal-compose: host.yml file has been created. Please don't add it to VCS, since this file is specific to the host where it was generated."
