#!/usr/bin/env bash

WORKING_DIR="$(pwd)"

help() {
  cat << EOF
Usage: drupal-compose
EOF

  exit 1
}

if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
  help
fi

unknown_command() {
  echo "drupal-compose: Unknown command. See 'drupal-compose --help'"

  exit 1
}

if [ "${#}" -gt 0 ]; then
  unknown_command
fi

docker_compose_file_path() {
  local DOCKER_COMPOSE_FILE_PATH=""

  while [ "$(pwd)" != '/' ]; do
    if [ "$(ls docker-compose.yml 2> /dev/null)" == "docker-compose.yml" ]; then
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
httpd:
  extends:
    file: host.yml
    service: httpd
  image: fenomen/httpd:2.4
  hostname: httpd
  ports:
    - "80"
    - "443"
  volumes_from:
    - httpdata
  links:
    - php
  environment:
    - VHOST=${PROJECT_NAME}
httpdata:
  image: fenomen/data:latest
  hostname: httpdata
  volumes:
    - .:/httpd/data
mysqld:
  image: fenomen/mysqld:latest
  hostname: mysqld
  volumes_from:
    - mysqlddata
mysqlddata:
  image: fenomen/data:latest
  hostname: mysqlddata
  volumes:
    - /mysqld
php:
  extends:
    file: host.yml
    service: php
  image: fenomen/php:5.4
  hostname: php
  volumes:
    - ~/.ssh:/root/.ssh
  volumes_from:
    - httpdata
  links:
    - mysqld
    - mailcatcher:smtp
    - memcached
  environment:
    - DRUPAL_VERSION=6
mailcatcher:
  image: fenomen/mailcatcher:latest
  hostname: mailcatcher
  ports:
    - "80"
    - "443"
  environment:
    - VHOST=${PROJECT_NAME}
phpmyadmin:
  image: fenomen/phpmyadmin:latest
  hostname: phpmyadmin
  ports:
    - "80"
    - "443"
  links:
    - mysqld
  environment:
    - VHOST=${PROJECT_NAME}
adminer:
  image: fenomen/adminer:latest
  hostname: adminer
  ports:
    - "80"
    - "443"
  links:
    - mysqld
  environment:
    - VHOST=${PROJECT_NAME}
memcached:
  image: fenomen/memcached:latest
  hostname: memcached
memcachephp:
  image: fenomen/memcachephp:latest
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
httpd:
  extends:
    file: host.yml
    service: httpd
  image: fenomen/httpd:2.4
  hostname: httpd
  ports:
    - "80"
    - "443"
  volumes_from:
    - httpdata
  links:
    - php
  environment:
    - VHOST=${PROJECT_NAME}
httpdata:
  image: fenomen/data:latest
  hostname: httpdata
  volumes:
    - .:/httpd/data
mysqld:
  image: fenomen/mysqld:latest
  hostname: mysqld
  volumes_from:
    - mysqlddata
mysqlddata:
  image: fenomen/data:latest
  hostname: mysqlddata
  volumes:
    - /mysqld
php:
  extends:
    file: host.yml
    service: php
  image: fenomen/php:5.3
  hostname: php
  volumes:
    - ~/.ssh:/root/.ssh
  volumes_from:
    - httpdata
  links:
    - mysqld
    - mailcatcher:smtp
    - memcached
  environment:
    - DRUPAL_VERSION=7
mailcatcher:
  image: fenomen/mailcatcher:latest
  hostname: mailcatcher
  ports:
    - "80"
    - "443"
  environment:
    - VHOST=${PROJECT_NAME}
phpmyadmin:
  image: fenomen/phpmyadmin:latest
  hostname: phpmyadmin
  ports:
    - "80"
    - "443"
  links:
    - mysqld
  environment:
    - VHOST=${PROJECT_NAME}
adminer:
  image: fenomen/adminer:latest
  hostname: adminer
  ports:
    - "80"
    - "443"
  links:
    - mysqld
  environment:
    - VHOST=${PROJECT_NAME}
memcached:
  image: fenomen/memcached:latest
  hostname: memcached
memcachephp:
  image: fenomen/memcachephp:latest
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
httpd:
  extends:
    file: host.yml
    service: httpd
  image: fenomen/httpd:2.2
  hostname: httpd
  ports:
    - "80"
    - "443"
  volumes_from:
    - httpdata
  links:
    - php
  environment:
    - VHOST=${PROJECT_NAME}
httpdata:
  image: fenomen/data:latest
  hostname: httpdata
  volumes:
    - .:/httpd/data
mysqld:
  image: fenomen/mysqld:latest
  hostname: mysqld
  volumes_from:
    - mysqlddata
mysqlddata:
  image: fenomen/data:latest
  hostname: mysqlddata
  volumes:
    - /mysqld
php:
  extends:
    file: host.yml
    service: php
  image: fenomen/php:5.2
  hostname: php
  volumes:
    - ~/.ssh:/root/.ssh
  volumes_from:
    - httpdata
  links:
    - mysqld
    - mailcatcher:smtp
    - memcached
  environment:
    - DRUPAL_VERSION=6
mailcatcher:
  image: fenomen/mailcatcher:latest
  hostname: mailcatcher
  ports:
    - "80"
    - "443"
  environment:
    - VHOST=${PROJECT_NAME}
phpmyadmin:
  image: fenomen/phpmyadmin:latest
  hostname: phpmyadmin
  ports:
    - "80"
    - "443"
  links:
    - mysqld
  environment:
    - VHOST=${PROJECT_NAME}
adminer:
  image: fenomen/adminer:latest
  hostname: adminer
  ports:
    - "80"
    - "443"
  links:
    - mysqld
  environment:
    - VHOST=${PROJECT_NAME}
memcached:
  image: fenomen/memcached:latest
  hostname: memcached
memcachephp:
  image: fenomen/memcachephp:latest
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
httpd:
  environment:
    - USER_ID=${USER_ID}
    - GROUP_ID=${GROUP_ID}
php:
  environment:
    - PHP_INI_XDEBUG=On
    - PHP_INI_XDEBUG_REMOTE_PORT=9000
    - PHP_INI_XDEBUG_REMOTE_HOST=127.0.0.1
    - PHP_INI_XDEBUG_REMOTE_CONNECT_BACK=On
    - PHP_INI_XDEBUG_IDEKEY=PHPSTORM
    - PHP_INI_BLACKFIRE=On
    - PHP_INI_BLACKFIRE_SERVER_ID=
    - PHP_INI_BLACKFIRE_SERVER_TOKEN=
    - USER_ID=${USER_ID}
    - GROUP_ID=${GROUP_ID}
EOF
}

DRUPAL_ROOT="$(docker_compose_file_path)"

if [ -n "${DRUPAL_ROOT}" ]; then
  read -p "drupal-compose: docker-compose.yml file already exists, would you like to override it? [Y/n]: " ANSWER

  if [ "${ANSWER}" == "n" ]; then
    if [ ! -f "${DRUPAL_ROOT}/host.yml" ]; then
      read -p "drupal-compose: host.yml file is missing, would you like to create it? [Y/n]: " ANSWER

      if [ "${ANSWER}" == "n" ]; then
        exit
      fi

      echo -n "$(host_docker_compose_template)" > "${DRUPAL_ROOT}/host.yml"

      echo "drupal-compose: host.yml file has been created. Please don't add it to VCS, since this file is specific the host where it was generated."
    fi

    exit
  fi
fi

DRUPAL_ROOT="$(drupal_8_path)"

if [ -n "${DRUPAL_ROOT}" ]; then
  read -p "drupal-compose: Enter project name: " PROJECT_NAME

  echo -n "$(drupal_8_docker_compose_template ${PROJECT_NAME})" > "${DRUPAL_ROOT}/docker-compose.yml"
else
  DRUPAL_ROOT="$(drupal_7_path)"

  if [ -n "${DRUPAL_ROOT}" ]; then
    read -p "drupal-compose: Enter project name: " PROJECT_NAME

    echo -n "$(drupal_7_docker_compose_template ${PROJECT_NAME})" > "${DRUPAL_ROOT}/docker-compose.yml"
  else
    DRUPAL_ROOT="$(drupal_6_path)"

    if [ -n "${DRUPAL_ROOT}" ]; then
      read -p "drupal-compose: Enter project name: " PROJECT_NAME

      echo -n "$(drupal_6_docker_compose_template ${PROJECT_NAME})" > "${DRUPAL_ROOT}/docker-compose.yml"
    else
      echo "drupal-compose: Drupal installation path could not be found."

      exit 1
    fi
  fi
fi

echo "drupal-compose: docker-compose.yml file has been created. Don't forget to add it to VCS alongside with Drupal."

echo -n "$(host_docker_compose_template)" > "${DRUPAL_ROOT}/host.yml"

echo "drupal-compose: host.yml file has been created. Please don't add it to VCS, since this file is specific the host where it was generated."
