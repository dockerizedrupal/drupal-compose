#!/usr/bin/env bash

LOG_DIR=/var/log/dev
LOG="${LOG_DIR}/dev.log"
LOG_ERROR="${LOG_DIR}/error.log"

if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
  cat << EOF
dev install
dev update
dev redis up
dev redis destroy
dev redis get [KEY]
dev redis set [KEY] [VALUE]
dev apache up
dev apache destroy
dev mysql up
dev mysql destroy
dev php up
dev php destroy
dev php52 up
dev php52 destroy
dev php53 up
dev php53 destroy
dev php54 up
dev php54 destroy
dev php55 up
dev php55 destroy
dev mailcatcher up
dev mailcatcher destroy
dev dev redis get [KEY]
dev dev redis set [KEY] [VALUE]
dev image [IMAGE] pull
dev image [IMAGE] destroy
dev container [CONTAINER] up [IMAGE]
dev container [CONTAINER] destroy
EOF

  exit 1
fi

log() {
  while read DATA; do
    echo "[$(date +"%D %T")] ${DATA}" >> "${LOG}"
  done
}

log_error() {
  while read DATA; do
    echo "[$(date +"%D %T")] ${DATA}" >> "${LOG_ERROR}"
  done
}

output() {
  local COLOR="${2}"

  if [ -z "${COLOR}" ]; then
    COLOR=2
  fi

  echo "$(tput setaf ${COLOR})${1}$(tput sgr 0)"
}

output_error() {
  >&2 output "${1}" 1
}

output_debug() {
  if [ ${DEBUG} ]; then
    output "${1}" 3
  fi
}

image_exists() {
  local RETURN=0

  if [ "$(sudo docker inspect "${1}" 2> /dev/null)" == "[]" ]; then
    RETURN=1
  fi

  return "${RETURN}"
}

image_build() {
  output_debug "FUNCTION: image_build ARGS: ${*}"

  local IMAGE="${1}"
  local CONTAINER="${2}"
  local CALLBACK="${CONTAINER}_build"

  if $(image_exists "${IMAGE}"); then
    image_destroy "${IMAGE}"
  fi

  output "Building image: ${IMAGE}"

  eval "${CALLBACK} ${IMAGE}"
}

image_pull() {
  output_debug "FUNCTION: image_pull ARGS: ${*}"

  local IMAGE="${1}"

  output "Pulling image: ${IMAGE}"

  sudo docker pull "${IMAGE}" > >(log) 2> >(log_error)
}

image_destroy() {
  output_debug "FUNCTION: image_destroy ARGS: ${*}"

  local IMAGE="${1}"

  if ! $(image_exists "${IMAGE}"); then
    output_error "No such image: ${IMAGE}"

    return 1
  fi

  for ID in $(sudo docker ps -aq); do
    if [ "$(sudo docker inspect -f "{{ .Config.Image }}" "${ID}" 2> /dev/null)" == "${IMAGE}" ]; then
      container "${ID}" destroy
    fi
  done

  output "Destroying image: ${IMAGE}"

  sudo docker rmi "${IMAGE}" > >(log) 2> >(log_error)
}

image() {
  output_debug "FUNCTION: image ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev image [NAME] build
dev image [NAME] pull
dev image [NAME] destroy
EOF

    exit 1
  fi

  local IMAGE="${1}"

  case "${2}" in
    build)
      local CONTAINER="${3}"

      image_build "${IMAGE}" "${CONTAINER}"
    ;;
    pull)
      image_pull "${IMAGE}"
    ;;
    destroy)
      image_destroy "${IMAGE}"
    ;;
    *)
      output_error "dev: Unknown command. See 'dev image --help'"

      exit 1
    ;;
  esac
}

container_exists() {
  local RETURN=0

  if [ "$(sudo docker inspect "${1}" 2> /dev/null)" == "[]" ]; then
    RETURN=1
  fi

  return "${RETURN}"
}

container_running() {
  local RETURN=1

  if [ "$(sudo docker inspect -f "{{ .State.Running }}" "${1}" 2> /dev/null)" == "true" ]; then
    RETURN=0
  fi

  return "${RETURN}"
}

container_name() {
  echo "$(sudo docker inspect -f "{{ .Name }}" "${1}" 2> /dev/null | cut -d "/" -f 2)"
}

container_up() {
  output_debug "FUNCTION: container_up ARGS: ${*}"

  local IMAGE="${1}"
  local CONTAINER="${2}"
  local CALLBACK="${CONTAINER}_up"

  if $(container_exists "${CONTAINER}"); then
    container "${CONTAINER}" destroy
  fi

  output "Starting container: ${CONTAINER}"

  eval "${CALLBACK} ${CONTAINER} ${IMAGE}"
}

container_cp() {
  output_debug "FUNCTION: container_cp ARGS: ${*}"

  local CONTAINER="${1}"
  local SOURCE="${2}"
  local DESTINATION="${3}"

  sudo docker cp "${CONTAINER}:${SOURCE}" "${DESTINATION}"
}

container_attach() {
  output_debug "FUNCTION: container_cp ARGS: ${*}"

  local CONTAINER="${1}"

  local PID="$(sudo docker inspect --format "{{ .State.Pid }}" "${CONTAINER}" 2> /dev/null)"

  sudo nsenter --target "${PID}" --mount --uts --ipc --net --pid
}

container() {
  output_debug "FUNCTION: container ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev container [CONTAINER] up
dev container [CONTAINER] destroy
EOF

    exit 1
  fi

  local CONTAINER="${1}"

  case "${2}" in
    up)
      local IMAGE="${3}"

      container_up "${IMAGE}" "${CONTAINER}"
    ;;
    destroy)
      if ! $(container_exists "${CONTAINER}"); then
        output_error "No such container: ${CONTAINER}"

        return 1
      fi

      CONTAINER=$(container_name "${CONTAINER}")

      if $(container_running "${CONTAINER}"); then
        output "Stopping container: ${CONTAINER}"

        sudo docker stop "${CONTAINER}" > >(log) 2> >(log_error)
      fi

      output "Destroying container: ${CONTAINER}"

      sudo docker rm "${CONTAINER}" > >(log) 2> >(log_error)
    ;;
    *)
      output_error "dev: Unknown command. See 'dev container --help'"

      exit 1
    ;;
  esac
}

dev_build() {
  output_debug "FUNCTION: dev_build ARGS: ${*}"

  local IMAGE="${1}"

  sudo docker build \
    -t "${IMAGE}" \
    http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git
}

dev_up() {
  output_debug "FUNCTION: dev_up ARGS: ${*}"

  local CONTAINER="${1}"
  local IMAGE="${2}"

  sudo docker run \
    --name "${CONTAINER}" \
    -h "${CONTAINER}" \
    -p 80:80 \
    -d \
    "${IMAGE}" > >(log) 2> >(log_error)
}

dev() {
  local CONTAINER=dev
  local IMAGE=simpledrupalcloud/dev

  output_debug "FUNCTION: dev ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev dev update
dev dev build
dev dev up
dev dev destroy
dev dev redis get [KEY]
dev dev redis set [KEY] [VALUE]
EOF

    exit 1
  fi

  local ACTION="${1}"

  case "${ACTION}" in
    update)
      image "${IMAGE}" pull
    ;;
    build)
      image "${IMAGE}" build "${CONTAINER}"
    ;;
    up)
      container "${CONTAINER}" up "${IMAGE}"
    ;;
    destroy)
      image "${IMAGE}" destroy
    ;;
    redis)
      case "${2}" in
        get)
          local KEY="${3}"

          echo -n "$(sudo docker run --net host --rm -i -t -a stdout "${IMAGE}" redis get "${KEY}" 2> >(log_error))"
        ;;
        set)
          local KEY="${3}"
          local VALUE="${4}"

          sudo docker run --net host --rm -i -t -a stdout "${IMAGE}" redis set "${KEY}" "${VALUE}" > >(log) 2> >(log_error)
        ;;
        *)
          output_error "dev: Unknown command. See 'dev dev --help'"

          exit 1
      esac
    ;;
  esac
}

redis_build() {
  output_debug "FUNCTION: redis_build ARGS: ${*}"

  local IMAGE="${1}"

  TMP=$(mktemp -d) \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-redis.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 2.8.14 \
    && sudo docker build -t "${IMAGE}" . \
    && cd -
}

redis_up() {
  output_debug "FUNCTION: redis_up ARGS: ${*}"

  local CONTAINER="${1}"
  local IMAGE="${2}"

  sudo docker run \
    --name "${CONTAINER}" \
    --net container:dev \
    -v /var/redis-2.8.14/data:/redis-2.8.14/data \
    -d \
    "${IMAGE}" > >(log) 2> >(log_error)
}

redis() {
  local CONTAINER=redis
  local IMAGE=simpledrupalcloud/redis:2.8.14

  output_debug "FUNCTION: redis ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev redis update
dev redis build
dev redis up
dev redis destroy
dev redis get [KEY]
dev redis set [KEY] [VALUE]
EOF

    exit 1
  fi

  local ACTION="${1}"

  case "${ACTION}" in
    update)
      image "${IMAGE}" pull
    ;;
    build)
      image "${IMAGE}" build "${CONTAINER}"
    ;;
    up)
      dev up

      container "${CONTAINER}" up "${IMAGE}"
    ;;
    destroy)
      image "${IMAGE}" destroy
    ;;
    get)
      local KEY="${2}"

      echo -n "$(dev redis get "${KEY}")"
    ;;
    set)
      local KEY="${2}"
      local VALUE="${3}"

      dev redis set "${KEY}" "${VALUE}"
    ;;
    *)
      output_error "dev: Unknown command. See 'dev redis --help'"

      exit 1
    ;;
  esac
}

apache_build() {
  output_debug "FUNCTION: apache_build ARGS: ${*}"

  local IMAGE="${1}"

  TMP=$(mktemp -d) \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-apache.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 2.2.22 \
    && sudo docker build -t "${IMAGE}" . \
    && cd -
}

apache_up() {
  output_debug "FUNCTION: apache_up ARGS: ${*}"

  local CONTAINER="${1}"
  local IMAGE="${2}"

  local APACHE_SERVERNAME=example.com

  sudo docker run \
    --name "${CONTAINER}" \
    --net container:dev \
    -v /var/apache-2.2.22/conf.d:/apache-2.2.22/conf.d \
    -v /var/apache-2.2.22/data:/apache-2.2.22/data \
    -v /var/apache-2.2.22/log:/apache-2.2.22/log \
    -e APACHE_SERVERNAME="${APACHE_SERVERNAME}" \
    -d \
    "${IMAGE}" > >(log) 2> >(log_error)
}

apache() {
  local CONTAINER=apache
  local IMAGE=simpledrupalcloud/apache:2.2.22

  output_debug "FUNCTION: apache ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev apache update
dev apache build
dev apache up
dev apache destroy
EOF

    exit 1
  fi

  local ACTION="${1}"

  case "${ACTION}" in
    update)
      image "${IMAGE}" pull
    ;;
    build)
      image "${IMAGE}" build "${CONTAINER}"
    ;;
    up)
      dev up

      container "${CONTAINER}" up "${IMAGE}"
    ;;
    destroy)
      image "${IMAGE}" destroy
    ;;
    *)
      output_error "dev: Unknown command. See 'dev apache --help'"

      exit 1
    ;;
  esac
}

mysql_build() {
  output_debug "FUNCTION: mysql_build ARGS: ${*}"

  local IMAGE="${1}"

  TMP=$(mktemp -d) \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-mysql.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 5.5.38 \
    && sudo docker build -t "${IMAGE}" . \
    && cd -
}

mysql_up() {
  output_debug "FUNCTION: mysql_up ARGS: ${*}"

  local CONTAINER="${1}"
  local IMAGE="${2}"

  sudo docker run \
    --name "${CONTAINER}" \
    --net container:dev \
    -v /var/mysql-5.5.38/conf.d:/mysql-5.5.38/conf.d \
    -v /var/mysql-5.5.38/data:/mysql-5.5.38/data \
    -v /var/mysql-5.5.38/log:/mysql-5.5.38/log \
    -d \
    "${IMAGE}" > >(log) 2> >(log_error)
}

mysql() {
  local CONTAINER=mysql
  local IMAGE=simpledrupalcloud/mysql:5.5.38

  output_debug "FUNCTION: mysql ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev mysql update
dev mysql build
dev mysql up
dev mysql destroy
EOF

    exit 1
  fi

  local ACTION="${1}"

  case "${ACTION}" in
    update)
      image "${IMAGE}" pull
    ;;
    build)
      image "${IMAGE}" build "${CONTAINER}"
    ;;
    up)
      dev up

      container "${CONTAINER}" up "${IMAGE}"
    ;;
    destroy)
      image "${IMAGE}" destroy
    ;;
    *)
      output_error "dev: Unknown command. See 'dev mysql --help'"

      exit 1
    ;;
  esac
}

php52_build() {
  output_debug "FUNCTION: php52_build ARGS: ${*}"

  local IMAGE="${1}"

  TMP=$(mktemp -d) \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-php.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 5.2.17 \
    && sudo docker build -t "${IMAGE}" . \
    && cd -
}

php52_up() {
  output_debug "FUNCTION: php52_up ARGS: ${*}"

  local CONTAINER="${1}"
  local IMAGE="${2}"

  sudo docker run \
    --name "${CONTAINER}" \
    --net container:dev \
    --volumes-from apache \
    -d \
    "${IMAGE}" > >(log) 2> >(log_error)
}

php52() {
  local CONTAINER=php52
  local IMAGE=simpledrupalcloud/php:5.2.17

  output_debug "FUNCTION: php52 ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev php52 update
dev php52 build
dev php52 up
dev php52 destroy
EOF

    exit 1
  fi

  local ACTION="${1}"

  case "${ACTION}" in
    update)
      image "${IMAGE}" pull
    ;;
    build)
      image "${IMAGE}" build "${CONTAINER}"
    ;;
    up)
      dev up
      apache up

      container "${CONTAINER}" up "${IMAGE}"
    ;;
    destroy)
      image "${IMAGE}" destroy
    ;;
    *)
      output_error "dev: Unknown command. See 'dev php52 --help'"

      exit 1
    ;;
  esac
}

php53_build() {
  output_debug "FUNCTION: php53_build ARGS: ${*}"

  local IMAGE="${1}"

  TMP=$(mktemp -d) \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-php.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 5.3.28 \
    && sudo docker build -t "${IMAGE}" . \
    && cd -
}

php53_up() {
  output_debug "FUNCTION: php53_up ARGS: ${*}"

  local CONTAINER="${1}"
  local IMAGE="${2}"

  sudo docker run \
    --name "${CONTAINER}" \
    --net container:dev \
    --volumes-from apache \
    -d \
    "${IMAGE}" > >(log) 2> >(log_error)
}

php53() {
  local CONTAINER=php53
  local IMAGE=simpledrupalcloud/php:5.3.28

  output_debug "FUNCTION: php53 ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev php53 update
dev php53 build
dev php53 up
dev php53 destroy
EOF

    exit 1
  fi

  local ACTION="${1}"

  case "${ACTION}" in
    update)
      image "${IMAGE}" pull
    ;;
    build)
      image "${IMAGE}" build "${CONTAINER}"
    ;;
    up)
      dev up
      apache up

      container "${CONTAINER}" up "${IMAGE}"
    ;;
    destroy)
      image "${IMAGE}" destroy
    ;;
    *)
      output_error "dev: Unknown command. See 'dev php53 --help'"

      exit 1
    ;;
  esac
}

php54_build() {
  output_debug "FUNCTION: php53_build ARGS: ${*}"

  local IMAGE="${1}"

  TMP=$(mktemp -d) \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-php.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 5.4.31 \
    && sudo docker build -t "${IMAGE}" . \
    && cd -
}

php54_up() {
  output_debug "FUNCTION: php54_up ARGS: ${*}"

  local CONTAINER="${1}"
  local IMAGE="${2}"

  sudo docker run \
    --name "${CONTAINER}" \
    --net container:dev \
    --volumes-from apache \
    -d \
    "${IMAGE}" > >(log) 2> >(log_error)
}

php54() {
  local CONTAINER=php54
  local IMAGE=simpledrupalcloud/php:5.4.31

  output_debug "FUNCTION: php54 ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev php54 update
dev php54 build
dev php54 up
dev php54 destroy
EOF

    exit 1
  fi

  local ACTION="${1}"

  case "${ACTION}" in
    update)
      image "${IMAGE}" pull
    ;;
    build)
      image "${IMAGE}" build "${CONTAINER}"
    ;;
    up)
      dev up
      apache up

      container "${CONTAINER}" up "${IMAGE}"
    ;;
    destroy)
      image "${IMAGE}" destroy
    ;;
    *)
      output_error "dev: Unknown command. See 'dev php54 --help'"

      exit 1
    ;;
  esac
}

php55_build() {
  output_debug "FUNCTION: php53_build ARGS: ${*}"

  local IMAGE="${1}"

  TMP=$(mktemp -d) \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-php.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 5.5.15 \
    && sudo docker build -t "${IMAGE}" . \
    && cd -
}

php55_up() {
  output_debug "FUNCTION: php55_up ARGS: ${*}"

  local CONTAINER="${1}"
  local IMAGE="${2}"

  sudo docker run \
    --name "${CONTAINER}" \
    --net container:dev \
    --volumes-from apache \
    -d \
    "${IMAGE}" > >(log) 2> >(log_error)
}

php55() {
  local CONTAINER=php55
  local IMAGE=simpledrupalcloud/php:5.5.15

  output_debug "FUNCTION: php55 ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev php55 update
dev php55 build
dev php55 up
dev php55 destroy
EOF

    exit 1
  fi

  local ACTION="${1}"

  case "${ACTION}" in
    update)
      image "${IMAGE}" pull
    ;;
    build)
      image "${IMAGE}" build "${CONTAINER}"
    ;;
    up)
      dev up
      apache up

      container "${CONTAINER}" up "${IMAGE}"
    ;;
    destroy)
      image "${IMAGE}" destroy
    ;;
    *)
      output_error "dev: Unknown command. See 'dev php55 --help'"

      exit 1
    ;;
  esac
}

php() {
  output_debug "FUNCTION: php ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev php update
dev php build
dev php up
dev php destroy
EOF

    exit 1
  fi

  local ACTION="${1}"

  case "${ACTION}" in
    update)
      php52 update
      php53 update
      php54 update
      php55 update
    ;;
    build)
      php52 build
      php53 build
      php54 build
      php55 build
    ;;
    up)
      php52 up
      php53 up
      php54 up
      php55 up
    ;;
    destroy)
      php52 destroy
      php53 destroy
      php54 destroy
      php55 destroy
    ;;
    *)
      output_error "dev: Unknown command. See 'dev php --help'"

      exit 1
    ;;
  esac
}

mailcatcher_build() {
  output_debug "FUNCTION: php53_build ARGS: ${*}"

  local IMAGE="${1}"

  TMP=$(mktemp -d) \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-mailcatcher.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 0.5.12 \
    && sudo docker build -t "${IMAGE}" . \
    && cd -
}

mailcatcher_up() {
  output_debug "FUNCTION: mailcatcher_up ARGS: ${*}"

  local CONTAINER="${1}"
  local IMAGE="${2}"

  sudo docker run \
    --name "${CONTAINER}" \
    --net container:dev \
    -d \
    "${IMAGE}" > >(log) 2> >(log_error)
}

mailcatcher() {
  local CONTAINER=mailcatcher
  local IMAGE=simpledrupalcloud/mailcatcher:0.5.12

  output_debug "FUNCTION: mailcatcher ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev mailcatcher update
dev mailcatcher build
dev mailcatcher up
dev mailcatcher destroy
EOF

    exit 1
  fi

  local ACTION="${1}"

  case "${ACTION}" in
    update)
      image "${IMAGE}" pull
    ;;
    build)
      image "${IMAGE}" build "${CONTAINER}"
    ;;
    up)
      dev up

      container "${CONTAINER}" up "${IMAGE}"
    ;;
    destroy)
      image "${IMAGE}" destroy
    ;;
    *)
      output_error "dev: Unknown command. See 'dev mailcatcher --help'"

      exit 1
    ;;
  esac
}

#phpmyadmin() {
#  TMP=$(mktemp -d)
#
#  sudo wget http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/4.2.8/phpMyAdmin-4.2.8-english.zip -O "${TMP}/phpMyAdmin-4.2.8-english.zip"
#
#  sudo apt-get install -y unzip
#
#  sudo unzip "${TMP}/phpMyAdmin-4.2.8-english.zip" -d /var/apache-2.2.22/data
#
#  sudo rm -rf /var/apache-2.2.22/data/phpmyadmin
#
#  sudo mv /var/apache-2.2.22/data/phpMyAdmin-4.2.8-english /var/apache-2.2.22/data/phpmyadmin
#}

install() {
  sudo mkdir -p "${LOG_DIR}"

  if [ ! -f /usr/local/bin/dev ]; then
    sudo apt-get install -y realpath
  fi

  SCRIPT=$(realpath -s "${0}")

  if [ "${SCRIPT}" = /usr/local/bin/dev ]; then
    cat << EOF
dev is already installed on this machine.

Type "dev update" to get the latest updates.
EOF
    exit
  fi

  if [ ! -f /usr/local/bin/dev ]; then
    sudo apt-get install -y curl

    curl -sSL https://get.docker.io/ubuntu/ | sudo bash

    sudo docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter
  fi

#  sudo docker stop redis2814
#  sudo docker rm redis2814
#  sudo docker stop apache
#  sudo docker rm apache
#  sudo docker stop mysql
#  sudo docker rm mysql
#
#  docker_dev_update
#  docker_config_update
#  docker_apache2222_update
#
#  sudo cp $(dirname "${0}")/php5-fcgi /var/apache-2.2.22/conf.d
#
#  docker_apache2222_update
#
#  docker_php5217_update
#  docker_php5328_update
#  docker_php5328_update
#  docker_php5431_update
#  docker_php5515_update
#  docker_mysql5538_update
#  docker_mailcatcher0512_update
#
#  phpmyadmin
#
#  sudo cp $(dirname "${0}")/config.inc.php /var/apache-2.2.22/data/phpmyadmin
#
#  sudo chown www-data.www-data /var/apache-2.2.22/data/phpmyadmin -R

  sudo cp "${SCRIPT}" /usr/local/bin/dev
}

update() {
  TMP=$(mktemp -d)

  git clone http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git "${TMP}"

  "${TMP}"/dev.sh install
}

up() {
  dev up
  redis up
  apache up
  mysql up
  php up
  mailcatcher up
}

destroy() {
  dev destroy
  redis destroy
  apache destroy
  mysql destroy
  php destroy
  mailcatcher destroy
}

case "${1}" in
  install)
    install
    ;;
  update)
    update
    ;;
  up)
    up
    ;;
  destroy)
    destroy
    ;;
  dev)
    dev "${@:2}"
  ;;
  redis)
    case "${2}" in
      get)
        echo -n "$(redis get "${@:3}")"
      ;;
      *)
        redis "${@:2}"
      ;;
    esac
  ;;
  apache)
    apache "${@:2}"
  ;;
  mysql)
    mysql "${@:2}"
  ;;
  php)
    php "${@:2}"
  ;;
  php52)
    php52 "${@:2}"
  ;;
  php53)
    php53 "${@:2}"
  ;;
  php54)
    php54 "${@:2}"
  ;;
  php55)
    php55 "${@:2}"
  ;;
  mailcatcher)
    mailcatcher "${@:2}"
  ;;
  image)
    image "${@:2}"
  ;;
  container)
    container "${@:2}"
  ;;
  *)
    output_error "dev: Unknown command. See 'dev --help'"

    exit 1
  ;;
esac
