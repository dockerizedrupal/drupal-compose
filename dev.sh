#!/usr/bin/env bash

LOG_DIR=/var/log/dev

sudo mkdir -p "${LOG_DIR}"

LOG="${LOG_DIR}/dev.log"
LOG_DEBUG="${LOG_DIR}/debug.log"
LOG_ERROR="${LOG_DIR}/error.log"

if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
  cat << EOF

Stable commands:

    dev install
    dev update
    dev build
    dev start
    dev restart
    dev stop

    dev dev attach
    dev dev update
    dev dev build
    dev dev start
    dev dev restart
    dev dev stop
    dev dev destroy

    dev redis attach
    dev redis update
    dev redis build
    dev redis start
    dev redis restart
    dev redis stop
    dev redis destroy
    dev redis get <KEY]>
    dev redis set <KEY> <VALUE>

    dev apache attach
    dev apache update
    dev apache build
    dev apache start
    dev apache restart
    dev apache stop
    dev apache destroy

    dev mysql attach
    dev mysql update
    dev mysql build
    dev mysql start
    dev mysql restart
    dev mysql stop
    dev mysql destroy

    dev php56 enable
    dev php56 attach
    dev php56 update
    dev php56 build
    dev php56 start
    dev php56 restart
    dev php56 stop
    dev php56 destroy

    dev php55 enable
    dev php55 attach
    dev php55 update
    dev php55 build
    dev php55 start
    dev php55 restart
    dev php55 stop
    dev php55 destroy

    dev php54 enable
    dev php54 attach
    dev php54 update
    dev php54 build
    dev php54 start
    dev php54 restart
    dev php54 stop
    dev php54 destroy

    dev php53 enable
    dev php53 attach
    dev php53 update
    dev php53 build
    dev php53 start
    dev php53 restart
    dev php53 stop
    dev php53 destroy

    dev php52 enable
    dev php52 attach
    dev php52 update
    dev php52 build
    dev php52 start
    dev php52 restart
    dev php52 stop
    dev php52 destroy

    dev mailcatcher attach
    dev mailcatcher update
    dev mailcatcher build
    dev mailcatcher start
    dev mailcatcher restart
    dev mailcatcher stop
    dev mailcatcher destroy

    dev phpmyadmin install
    dev phpmyadmin update
    dev phpmyadmin destroy

Unstable or not implemented commands:

    dev status

    dev ports 80 127.0.0.1:3360

    dev php56 enable
    dev php55 enable
    dev php54 enable
    dev php53 enable
    dev php52 enable

    dev svn export [REPOSITORY] <REVISION_FROM:REVISION_TO> <TARGET>

    dev ssh <ENVIRONMENT> [PATH]
EOF

  exit 1
fi

log() {
  while read DATA; do
    echo "[$(date +"%D %T")] ${DATA}" | sudo tee -a "${LOG}" > /dev/null
  done
}

log_error() {
  while read DATA; do
    echo "[$(date +"%D %T")] ${DATA}" | sudo tee -a "${LOG_ERROR}" > /dev/null
  done
}

log_debug() {
  while read DATA; do
    echo "[$(date +"%D %T")] ${DATA}" | sudo tee -a "${LOG_DEBUG}" > /dev/null
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
  local COLOR=3

  if [ ${DEBUG} ]; then
    local MESSAGE="${1}"

    echo "${MESSAGE}" > >(log_debug)
    echo "$(tput setaf "${COLOR}")${MESSAGE}$(tput sgr 0)"
  fi
}

WORKING_DIR="$(pwd)"

output_debug "\${WORKING_DIR}: ${WORKING_DIR}"

interface_ip() {
  local INTERFACE="${1}"

  echo "$(ip addr show "${INTERFACE}" 2> /dev/null | grep "inet " | awk -F " " '{ print $2 }' | sed -e 's/\/.*$//')"
}

docker0_ip() {
  echo "$(interface_ip "docker0")"
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
  local CALLBACK="${2}_build"

  if $(image_exists "${IMAGE}"); then
    image_destroy "${IMAGE}"
  fi

  output "Building image: ${IMAGE}"

  "${CALLBACK}"
}

image_update() {
  output_debug "FUNCTION: image_update ARGS: ${*}"

  local IMAGE="${1}"
  local CONTAINER="${2}"
  local CONTAINER_STOPPED=false

  if $(container_running "${CONTAINER}" || $(container_exists "${CONTAINER}")); then
    container_destroy "${CONTAINER}"

    CONTAINER_STOPPED=true
  fi

  if $(image_exists "${IMAGE}"); then
    output "Updating image: ${IMAGE}"
  else
    output "Downloading image: ${IMAGE}"
  fi

  sudo docker pull "${IMAGE}" > >(log) 2> >(log_error)

  if ${CONTAINER_STOPPED}; then
    container_start "${CONTAINER}" "${IMAGE}"
  fi
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
      container_destroy "${ID}"
    fi
  done

  output "Destroying image: ${IMAGE}"

  sudo docker rmi "${IMAGE}" > >(log) 2> >(log_error)
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

container_start() {
  output_debug "FUNCTION: container_start ARGS: ${*}"

  local CONTAINER="${1}"
  local IMAGE="${2}"
  local CALLBACK="${CONTAINER}_start"

  if $(container_exists "${CONTAINER}"); then
    if $(container_running "${CONTAINER}"); then
      output_error "Container is already running: ${CONTAINER}"

      return 1
    fi

    container_destroy "${CONTAINER}"
  fi

  if ! $(image_exists "${IMAGE}"); then
    image_update "${IMAGE}"
  fi

  output "Starting container: ${CONTAINER}"

  "${CALLBACK}"
}

container_cp() {
  output_debug "FUNCTION: container_cp ARGS: ${*}"

  local CONTAINER="${1}"
  local SOURCE="${2}"
  local DESTINATION="${3}"

  sudo docker cp "${CONTAINER}:${SOURCE}" "${DESTINATION}" > >(log) 2> >(log_error)
}

container_attach() {
  output_debug "FUNCTION: container_attach ARGS: ${*}"

  local CONTAINER="${1}"

  if ! $(container_exists "${CONTAINER}"); then
    output_error "No such container: ${CONTAINER}"

    exit 1
  fi

  if ! $(container_running "${CONTAINER}"); then
    output_error "Container is not running: ${CONTAINER}"

    exit 1
  fi

  local PID="$(sudo docker inspect -f "{{ .State.Pid }}" "${CONTAINER}" 2> /dev/null)"

  sudo nsenter --target "${PID}" --mount --uts --ipc --net --pid
}

container_destroy() {
  output_debug "FUNCTION: container_destroy ARGS: ${*}"

  local CONTAINER="${1}"

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
}

svn_archive() {
    #-v $(pwd):/src \
    #-v ~/.subversion:/root/.subversion \

    echo "dev_svn_archive"
}

svn() {
  output_debug "FUNCTION: svn ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev svn archive ...
EOF

    exit 1
  fi

  case "${1}" in
    archive)
      svn_archive
    ;;
    *)
      output_error "dev: Unknown command. See 'dev svn --help'"

      exit 1
    ;;
  esac
}

dev_get() {
  local KEY="${1}"

  echo -n "$(sudo docker run --net host --rm -i -t -a stdout simpledrupalcloud/dev redis get "${KEY}" 2> >(log_error))"
}

dev_set() {
  local KEY="${1}"
  local VALUE="${2}"

  sudo docker run --net host --rm -i -t -a stdout simpledrupalcloud/dev redis set "${KEY}" "${VALUE}" > >(log) 2> >(log_error)
}

dev_build() {
  output_debug "FUNCTION: dev_build ARGS: ${*}"

  sudo docker build \
    -t simpledrupalcloud/dev \
    http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git
}

dev_start() {
  output_debug "FUNCTION: dev_start ARGS: ${*}"

  sudo docker run \
    --name dev \
    -h dev \
    -p 80:80 \
    -p 443:443 \
    -p 3306:3306 \
    -p 1080:1080 \
    -d \
    simpledrupalcloud/dev > >(log) 2> >(log_error)
}

dev() {
  local CONTAINER=dev
  local IMAGE=simpledrupalcloud/dev

  output_debug "FUNCTION: dev ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev dev attach
dev dev update
dev dev build
dev dev start
dev dev restart
dev dev stop
dev dev destroy
EOF

    exit 1
  fi

  case "${1}" in
#    status)
#      if $(container_exists "${CONTAINER}"); then
#        output_error "No such container: ${CONTAINER}"
#
#        return 0
#      else
#        output_error "No such container: ${CONTAINER}"
#
#        return 1
#      fi
#    ;;
    attach)
      container_attach "${CONTAINER}"
    ;;
    update)
      local CONTAINER_STOPPED=false

      if $(container_running "${CONTAINER}" || $(container_exists "${CONTAINER}")); then
        dev stop

        CONTAINER_STOPPED=true
      fi

      image_update "${IMAGE}"

      if ${CONTAINER_STOPPED}; then
        dev start
      fi
    ;;
    build)
      image_build "${IMAGE}" "${CONTAINER}"
    ;;
    start)
      container_start "${CONTAINER}" "${IMAGE}"
    ;;
    restart)
      dev stop
      dev start
    ;;
    stop)
      container_destroy "${CONTAINER}"
    ;;
    destroy)
      image_destroy "${IMAGE}"
    ;;
    *)
      output_error "dev: Unknown command. See 'dev dev --help'"

      exit 1
    ;;
  esac
}

redis_build() {
  output_debug "FUNCTION: redis_build ARGS: ${*}"

  local TMP="$(mktemp -d)" \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-redis.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 2.8.14 \
    && sudo docker build -t simpledrupalcloud/redis:2.8.14 . \
    && cd -
}

redis_start() {
  output_debug "FUNCTION: redis_start ARGS: ${*}"

  sudo docker run \
    --name redis \
    --net container:dev \
    -v /var/redis-2.8.14/data:/redis-2.8.14/data \
    -d \
    simpledrupalcloud/redis:2.8.14 > >(log) 2> >(log_error)
}

redis() {
  local CONTAINER=redis
  local IMAGE=simpledrupalcloud/redis:2.8.14

  output_debug "FUNCTION: redis ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev redis attach
dev redis update
dev redis build
dev redis start
dev redis restart
dev redis stop
dev redis destroy
dev redis get [KEY]
dev redis set [KEY] [VALUE]
EOF

    exit 1
  fi

  case "${1}" in
    attach)
      container_attach "${CONTAINER}"
    ;;
    update)
      local CONTAINER_STOPPED=false

      if $(container_running "${CONTAINER}" || $(container_exists "${CONTAINER}")); then
        redis stop

        CONTAINER_STOPPED=true
      fi

      image_update "${IMAGE}"

      if ${CONTAINER_STOPPED}; then
        redis start
      fi
    ;;
    build)
      image_build "${IMAGE}" "${CONTAINER}"
    ;;
    start)
      if ! $(container_exists "dev") || ! $(container_running "dev"); then
        dev start
      fi

      container_start "${CONTAINER}" "${IMAGE}"
    ;;
    restart)
      redis stop
      redis start
    ;;
    stop)
      container_destroy "${CONTAINER}"
    ;;
    destroy)
      image_destroy "${IMAGE}"
    ;;
    get)
      local KEY="${2}"

      echo -n "$(dev_get "${KEY}")"
    ;;
    set)
      local KEY="${2}"
      local VALUE="${3}"

      dev_set "${KEY}" "${VALUE}"
    ;;
    *)
      output_error "dev: Unknown command. See 'dev redis --help'"

      exit 1
    ;;
  esac
}

skydns_start() {
  output_debug "FUNCTION: skydns_start ARGS: ${*}"

  APACHE_SERVERNAME=example.com

  CONTAINER="apache" && sudo docker run \
    --name "${CONTAINER}" \
    -h "${CONTAINER}" \
    --dns "$(docker0_ip)" \
    -p 80:80 \
    -p 443:443 \
    -v /var/apache-2.2.22/conf.d:/apache-2.2.22/conf.d \
    -v /var/apache-2.2.22/data:/apache-2.2.22/data \
    -v /var/apache-2.2.22/log:/apache-2.2.22/log \
    -e APACHE_SERVERNAME="${APACHE_SERVERNAME}" \
    -d \
    simpledrupalcloud/apache:2.2.22 > >(log) 2> >(log_error)
}

skydns() {
  local CONTAINER=skydns
  local IMAGE=crosbymichael/skydns:latest

  output_debug "FUNCTION: skydns ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev apache attach
dev apache update
dev apache build
dev apache start
dev apache restart
dev apache stop
dev apache destroy
EOF

    exit 1
  fi

  case "${1}" in
    attach)
      container_attach "${CONTAINER}"
    ;;
    update)
      image_update "${IMAGE}" "${CONTAINER}"
    ;;
    build)
      image_build "${IMAGE}" "${CONTAINER}"
    ;;
    start)
      if ! $(container_exists "dev") || ! $(container_running "dev"); then
        dev start
      fi

      container_start "${CONTAINER}" "${IMAGE}"
    ;;
    restart)
      apache stop
      apache start
    ;;
    stop)
      container_destroy "${CONTAINER}"
    ;;
    destroy)
      image_destroy "${IMAGE}"
    ;;
    *)
      output_error "dev: Unknown command. See 'dev apache --help'"

      exit 1
    ;;
  esac
}

apache_build() {
  output_debug "FUNCTION: apache_build ARGS: ${*}"

  local TMP="$(mktemp -d)" \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-apache.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 2.2.22 \
    && sudo docker build -t simpledrupalcloud/apache:2.2.22 . \
    && cd -
}

apache_start() {
  output_debug "FUNCTION: apache_start ARGS: ${*}"

  APACHE_SERVERNAME=example.com

  CONTAINER="apache" && sudo docker run \
    --name "${CONTAINER}" \
    -h "${CONTAINER}" \
    --dns "$(docker0_ip)" \
    -p 80:80 \
    -p 443:443 \
    -v /var/apache-2.2.22/conf.d:/apache-2.2.22/conf.d \
    -v /var/apache-2.2.22/data:/apache-2.2.22/data \
    -v /var/apache-2.2.22/log:/apache-2.2.22/log \
    -e APACHE_SERVERNAME="${APACHE_SERVERNAME}" \
    -d \
    simpledrupalcloud/apache:2.2.22 > >(log) 2> >(log_error)
}

apache() {
  local CONTAINER=apache
  local IMAGE=simpledrupalcloud/apache:2.2.22

  output_debug "FUNCTION: apache ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev apache attach
dev apache update
dev apache build
dev apache start
dev apache restart
dev apache stop
dev apache destroy
EOF

    exit 1
  fi

  case "${1}" in
    attach)
      container_attach "${CONTAINER}"
    ;;
    update)
      local CONTAINER_STOPPED=false

      if $(container_running "${CONTAINER}" || $(container_exists "${CONTAINER}")); then
        apache stop

        CONTAINER_STOPPED=true
      fi

      image_update "${IMAGE}"

      if ${CONTAINER_STOPPED}; then
        apache start
      fi
    ;;
    build)
      image_build "${IMAGE}" "${CONTAINER}"
    ;;
    start)
      if ! $(container_exists "dev") || ! $(container_running "dev"); then
        dev start
      fi

      container_start "${CONTAINER}" "${IMAGE}"
    ;;
    restart)
      apache stop
      apache start
    ;;
    stop)
      container_destroy "${CONTAINER}"
    ;;
    destroy)
      image_destroy "${IMAGE}"
    ;;
    *)
      output_error "dev: Unknown command. See 'dev apache --help'"

      exit 1
    ;;
  esac
}

mysql_build() {
  output_debug "FUNCTION: mysql_build ARGS: ${*}"

  local TMP="$(mktemp -d)" \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-mysql.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 5.5.38 \
    && sudo docker build -t simpledrupalcloud/mysql:5.5.38 . \
    && cd -
}

mysql_start() {
  output_debug "FUNCTION: mysql_start ARGS: ${*}"

  sudo docker run \
    --name mysql \
    --net container:dev \
    -v /var/mysql-5.5.38/conf.d:/mysql-5.5.38/conf.d \
    -v /var/mysql-5.5.38/data:/mysql-5.5.38/data \
    -v /var/mysql-5.5.38/log:/mysql-5.5.38/log \
    -d \
    simpledrupalcloud/mysql:5.5.38 > >(log) 2> >(log_error)
}

mysql() {
  local CONTAINER=mysql
  local IMAGE=simpledrupalcloud/mysql:5.5.38

  output_debug "FUNCTION: mysql ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev mysql attach
dev mysql update
dev mysql build
dev mysql start
dev mysql restart
dev mysql stop
dev mysql destroy
EOF

    exit 1
  fi

  case "${1}" in
    attach)
      container_attach "${CONTAINER}"
    ;;
    update)
      local CONTAINER_STOPPED=false

      if $(container_running "${CONTAINER}" || $(container_exists "${CONTAINER}")); then
        mysql stop

        CONTAINER_STOPPED=true
      fi

      image_update "${IMAGE}"

      if ${CONTAINER_STOPPED}; then
        mysql start
      fi
    ;;
    build)
      image_build "${IMAGE}" "${CONTAINER}"
    ;;
    start)
      if ! $(container_exists "dev") || ! $(container_running "dev"); then
        dev start
      fi

      container_start "${CONTAINER}" "${IMAGE}"
    ;;
    restart)
      mysql stop
      mysql start
    ;;
    stop)
      container_destroy "${CONTAINER}"
    ;;
    destroy)
      image_destroy "${IMAGE}"
    ;;
    *)
      output_error "dev: Unknown command. See 'dev mysql --help'"

      exit 1
    ;;
  esac
}

php52_build() {
  output_debug "FUNCTION: php52_build ARGS: ${*}"

  local TMP="$(mktemp -d)" \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-php.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 5.2.17 \
    && sudo docker build -t simpledrupalcloud/php:5.2.17 . \
    && cd -
}

php52_start() {
  output_debug "FUNCTION: php52_start ARGS: ${*}"

  sudo docker run \
    --name php52 \
    --net container:dev \
    --volumes-from apache \
    -d \
    simpledrupalcloud/php:5.2.17 > >(log) 2> >(log_error)
}

php52() {
  local CONTAINER=php52
  local IMAGE=simpledrupalcloud/php:5.2.17

  output_debug "FUNCTION: php52 ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev php52 enable
dev php52 attach
dev php52 update
dev php52 build
dev php52 start
dev php52 restart
dev php52 stop
dev php52 destroy
EOF

    exit 1
  fi

  case "${1}" in
    enable)
      php_enable "${CONTAINER}"
    ;;
    attach)
      container_attach "${CONTAINER}"
    ;;
    update)
      local CONTAINER_STOPPED=false

      if $(container_running "${CONTAINER}" || $(container_exists "${CONTAINER}")); then
        php52 stop

        CONTAINER_STOPPED=true
      fi

      image_update "${IMAGE}"

      if ${CONTAINER_STOPPED}; then
        php52 start
      fi
    ;;
    build)
      image_build "${IMAGE}" "${CONTAINER}"
    ;;
    start)
      if ! $(container_exists "dev") || ! $(container_running "dev"); then
        dev start
      fi

      if ! $(container_exists "apache") || ! $(container_running "apache"); then
        apache start
      fi

      container_start "${CONTAINER}" "${IMAGE}"
    ;;
    restart)
      php52 stop
      php52 start
    ;;
    stop)
      container_destroy "${CONTAINER}"
    ;;
    destroy)
      image_destroy "${IMAGE}"
    ;;
    *)
      output_error "dev: Unknown command. See 'dev php52 --help'"

      exit 1
    ;;
  esac
}

php53_build() {
  output_debug "FUNCTION: php53_build ARGS: ${*}"

  local TMP="$(mktemp -d)" \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-php.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 5.3.28 \
    && sudo docker build -t simpledrupalcloud/php:5.3.28 . \
    && cd -
}

php53_start() {
  output_debug "FUNCTION: php53_start ARGS: ${*}"

  sudo docker run \
    --name php53 \
    --net container:dev \
    --volumes-from apache \
    -d \
    simpledrupalcloud/php:5.3.28 > >(log) 2> >(log_error)
}

php53() {
  local CONTAINER=php53
  local IMAGE=simpledrupalcloud/php:5.3.28

  output_debug "FUNCTION: php53 ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev php53 enable
dev php53 attach
dev php53 update
dev php53 build
dev php53 start
dev php53 restart
dev php53 stop
dev php53 destroy
EOF

    exit 1
  fi

  case "${1}" in
    enable)
      php_enable "${CONTAINER}"
    ;;
    attach)
      container_attach "${CONTAINER}"
    ;;
    update)
      local CONTAINER_STOPPED=false

      if $(container_running "${CONTAINER}" || $(container_exists "${CONTAINER}")); then
        php53 stop

        CONTAINER_STOPPED=true
      fi

      image_update "${IMAGE}"

      if ${CONTAINER_STOPPED}; then
        php53 start
      fi
    ;;
    build)
      image_build "${IMAGE}" "${CONTAINER}"
    ;;
    start)
      if ! $(container_exists "dev") || ! $(container_running "dev"); then
        dev start
      fi

      if ! $(container_exists "apache") || ! $(container_running "apache"); then
        apache start
      fi

      container_start "${CONTAINER}" "${IMAGE}"
    ;;
    restart)
      php53 stop
      php53 start
    ;;
    stop)
      container_destroy "${CONTAINER}"
    ;;
    destroy)
      image_destroy "${IMAGE}"
    ;;
    *)
      output_error "dev: Unknown command. See 'dev php53 --help'"

      exit 1
    ;;
  esac
}

php54_build() {
  output_debug "FUNCTION: php53_build ARGS: ${*}"

  local TMP="$(mktemp -d)" \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-php.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 5.4.31 \
    && sudo docker build -t simpledrupalcloud/php:5.4.31 . \
    && cd -
}

php54_start() {
  output_debug "FUNCTION: php54_start ARGS: ${*}"

  sudo docker run \
    --name php54 \
    --net container:dev \
    --volumes-from apache \
    -d \
    simpledrupalcloud/php:5.4.31 > >(log) 2> >(log_error)
}

php54() {
  local CONTAINER=php54
  local IMAGE=simpledrupalcloud/php:5.4.31

  output_debug "FUNCTION: php54 ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev php54 enable
dev php54 attach
dev php54 update
dev php54 build
dev php54 start
dev php54 restart
dev php54 stop
dev php54 destroy
EOF

    exit 1
  fi

  case "${1}" in
    enable)
      php_enable "${CONTAINER}"
    ;;
    attach)
      container_attach "${CONTAINER}"
    ;;
    update)
      local CONTAINER_STOPPED=false

      if $(container_running "${CONTAINER}" || $(container_exists "${CONTAINER}")); then
        php54 stop

        CONTAINER_STOPPED=true
      fi

      image_update "${IMAGE}"

      if ${CONTAINER_STOPPED}; then
        php54 start
      fi
    ;;
    build)
      image_build "${IMAGE}" "${CONTAINER}"
    ;;
    start)
      if ! $(container_exists "dev") || ! $(container_running "dev"); then
        dev start
      fi

      if ! $(container_exists "apache") || ! $(container_running "apache"); then
        apache start
      fi

      container_start "${CONTAINER}" "${IMAGE}"
    ;;
    restart)
      php54 stop
      php54 start
    ;;
    stop)
      container_destroy "${CONTAINER}"
    ;;
    destroy)
      image_destroy "${IMAGE}"
    ;;
    *)
      output_error "dev: Unknown command. See 'dev php54 --help'"

      exit 1
    ;;
  esac
}

php55_update_1() {
  output_debug "FUNCTION: php55_update_1 ARGS: ${*}"

  local IMAGE=simpledrupalcloud/php:5.5.15

  if $(image_exists "${IMAGE}"); then
    image_destroy "${IMAGE}"
  fi
}

php55_build() {
  output_debug "FUNCTION: php55_build ARGS: ${*}"

  local TMP="$(mktemp -d)" \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-php.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 5.5.17 \
    && sudo docker build -t simpledrupalcloud/php:5.5.17 . \
    && cd -
}

php55_start() {
  output_debug "FUNCTION: php55_start ARGS: ${*}"

  sudo docker run \
    --name php55 \
    --net container:dev \
    --volumes-from apache \
    -d \
    simpledrupalcloud/php:5.5.17 > >(log) 2> >(log_error)
}

php55() {
  local CONTAINER=php55
  local IMAGE=simpledrupalcloud/php:5.5.17

  output_debug "FUNCTION: php55 ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev php55 enable
dev php55 attach
dev php55 update
dev php55 build
dev php55 start
dev php55 restart
dev php55 stop
dev php55 destroy
EOF

    exit 1
  fi

  case "${1}" in
    enable)
      php_enable "${CONTAINER}"
    ;;
    attach)
      container_attach "${CONTAINER}"
    ;;
    update)
      php55_update_1

      local CONTAINER_STOPPED=false

      if $(container_running "${CONTAINER}" || $(container_exists "${CONTAINER}")); then
        php55 stop

        CONTAINER_STOPPED=true
      fi

      image_update "${IMAGE}"

      if ${CONTAINER_STOPPED}; then
        php55 start
      fi
    ;;
    build)
      image_build "${IMAGE}" "${CONTAINER}"
    ;;
    start)
      if ! $(container_exists "dev") || ! $(container_running "dev"); then
        dev start
      fi

      if ! $(container_exists "apache") || ! $(container_running "apache"); then
        apache start
      fi

      container_start "${CONTAINER}" "${IMAGE}"
    ;;
    restart)
      php55 stop
      php55 start
    ;;
    stop)
      container_destroy "${CONTAINER}"
    ;;
    destroy)
      image_destroy "${IMAGE}"
    ;;
    *)
      output_error "dev: Unknown command. See 'dev php55 --help'"

      exit 1
    ;;
  esac
}

php56_build() {
  output_debug "FUNCTION: php56_build ARGS: ${*}"

  local TMP="$(mktemp -d)" \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-php.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 5.6.0 \
    && sudo docker build -t simpledrupalcloud/php:5.6.0 . \
    && cd -
}

php56_start() {
  output_debug "FUNCTION: php56_start ARGS: ${*}"

  sudo docker run \
    --name php56 \
    --net container:dev \
    --volumes-from apache \
    -d \
    simpledrupalcloud/php:5.6.0 > >(log) 2> >(log_error)
}

php56() {
  local CONTAINER=php56
  local IMAGE=simpledrupalcloud/php:5.6.0

  output_debug "FUNCTION: php56 ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev php56 enable
dev php56 attach
dev php56 update
dev php56 build
dev php56 start
dev php56 restart
dev php56 stop
dev php56 destroy
EOF

    exit 1
  fi

  case "${1}" in
    enable)
      php_enable "${CONTAINER}"
    ;;
    attach)
      container_attach "${CONTAINER}"
    ;;
    update)
      local CONTAINER_STOPPED=false

      if $(container_running "${CONTAINER}" || $(container_exists "${CONTAINER}")); then
        php56 stop

        CONTAINER_STOPPED=true
      fi

      image_update "${IMAGE}"

      if ${CONTAINER_STOPPED}; then
        php56 start
      fi
    ;;
    build)
      image_build "${IMAGE}" "${CONTAINER}"
    ;;
    start)
      if ! $(container_exists "dev") || ! $(container_running "dev"); then
        dev start
      fi

      if ! $(container_exists "apache") || ! $(container_running "apache"); then
        apache start
      fi

      container_start "${CONTAINER}" "${IMAGE}"
    ;;
    restart)
      php56 stop
      php56 start
    ;;
    stop)
      container_destroy "${CONTAINER}"
    ;;
    destroy)
      image_destroy "${IMAGE}"
    ;;
    *)
      output_error "dev: Unknown command. See 'dev php56 --help'"

      exit 1
    ;;
  esac
}

php_enable() {
  if [ ! -f "${WORKING_DIR}/.htaccess" ]; then
    touch "${WORKING_DIR}/.htaccess"
  fi
}

mailcatcher_build() {
  output_debug "FUNCTION: php53_build ARGS: ${*}"

  local TMP="$(mktemp -d)" \
    && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-mailcatcher.git "${TMP}" \
    && cd "${TMP}" \
    && git checkout 0.5.12 \
    && sudo docker build -t simpledrupalcloud/mailcatcher:0.5.12 . \
    && cd -
}

mailcatcher_start() {
  output_debug "FUNCTION: mailcatcher_start ARGS: ${*}"

  sudo docker run \
    --name mailcatcher \
    --net container:dev \
    -d \
    simpledrupalcloud/mailcatcher:0.5.12 > >(log) 2> >(log_error)
}

mailcatcher() {
  local CONTAINER=mailcatcher
  local IMAGE=simpledrupalcloud/mailcatcher:0.5.12

  output_debug "FUNCTION: mailcatcher ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev mailcatcher attach
dev mailcatcher update
dev mailcatcher build
dev mailcatcher start
dev mailcatcher restart
dev mailcatcher stop
dev mailcatcher destroy
EOF

    exit
  fi

  case "${1}" in
    attach)
      container_attach "${CONTAINER}"
    ;;
    update)
      local CONTAINER_STOPPED=false

      if $(container_running "${CONTAINER}" || $(container_exists "${CONTAINER}")); then
        mailcatcher stop

        CONTAINER_STOPPED=true
      fi

      image_update "${IMAGE}"

      if ${CONTAINER_STOPPED}; then
        mailcatcher start
      fi
    ;;
    build)
      image_build "${IMAGE}" "${CONTAINER}"
    ;;
    start)
      if ! $(container_exists "dev") || ! $(container_running "dev"); then
        dev start
      fi

      container_start "${CONTAINER}" "${IMAGE}"
    ;;
    restart)
      mailcatcher stop
      mailcatcher start
    ;;
    stop)
      container_destroy "${CONTAINER}"
    ;;
    destroy)
      image_destroy "${IMAGE}"
    ;;
    *)
      output_error "dev: Unknown command. See 'dev mailcatcher --help'"

      exit 1
    ;;
  esac
}

phpmyadmin_install() {
  output "phpmyadmin: Instaling"

  TMP="$(mktemp -d)" > >(log) 2> >(log_error)

  output "phpmyadmin: Downloading"

  sudo wget http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/4.2.8/phpMyAdmin-4.2.8-english.zip -O "${TMP}/phpMyAdmin-4.2.8-english.zip" > >(log) 2> >(log_error)

  output "phpmyadmin: Instaling unzip"

  sudo apt-get install -y unzip > >(log) 2> >(log_error)

  sudo mkdir -p /var/apache-2.2.22/data > >(log) 2> >(log_error)

  output "phpmyadmin: Extracting files"

  sudo unzip "${TMP}/phpMyAdmin-4.2.8-english.zip" -d /var/apache-2.2.22/data > >(log) 2> >(log_error)

  sudo rm -rf /var/apache-2.2.22/data/phpmyadmin > >(log) 2> >(log_error)

  sudo mv /var/apache-2.2.22/data/phpMyAdmin-4.2.8-english /var/apache-2.2.22/data/phpmyadmin > >(log) 2> >(log_error)

  sudo cp $(dirname "${0}")/apache-2.2.22/config.inc.php /var/apache-2.2.22/data/phpmyadmin > >(log) 2> >(log_error)

  output "phpmyadmin: Overwriting permissions"

  sudo chown www-data.www-data /var/apache-2.2.22/data/phpmyadmin -R > >(log) 2> >(log_error)
}

phpmyadmin() {
  output_debug "FUNCTION: phpmyadmin ARGS: ${*}"

  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    cat << EOF
dev phpmyadmin install
dev phpmyadmin update
dev phpmyadmin destroy
EOF
    exit
  fi

  case "${1}" in
    install)
      phpmyadmin_install
    ;;
    update)
      echo "update"
    ;;
    destroy)
      echo "destroy"
    ;;
    *)
      output_error "dev: Unknown command. See 'dev phpmyadmin --help'"

      exit 1
    ;;
  esac
}

install() {
  output "dev: Instaling"

  if [ ! -d "${LOG_DIR}" ]; then
    output "dev: Creating directory: ${LOG_DIR}"

    sudo mkdir -p "${LOG_DIR}"
  fi

  output "dev: Installing nsenter"

  sudo docker run \
    --rm \
    -v /usr/local/bin:/target \
    jpetazzo/nsenter > >(log) 2> >(log_error)

  dev stop
  dev update
  dev start

  redis stop
  redis update
  redis start

  sudo mkdir -p /var/apache-2.2.22/conf.d
  sudo cp $(dirname "${0}")/apache-2.2.22/php /var/apache-2.2.22/conf.d

  apache stop
  apache update
  apache start

  mysql stop
  mysql update
  mysql start

  php56 stop
  php56 update
  php56 start

  php55 stop
  php55 update
  php55 start

  php54 stop
  php54 update
  php54 start

  php53 stop
  php53 update
  php53 start

  php52 stop
  php52 update
  php52 start

  mailcatcher stop
  mailcatcher update
  mailcatcher start

  phpmyadmin install
}

update() {
  output "dev: Updating"

  TMP="$(mktemp -d)"

  output "dev: Cloning repository"

  git clone http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git "${TMP}" > >(log) 2> >(log_error)

  "${TMP}/dev.sh" install

  exit
}

build() {
  output "dev: Building images"

  dev build
  redis build
  apache build
  mysql build
  php56 build
  php55 build
  php54 build
  php53 build
  php52 build
  mailcatcher build
}

start() {
  output "dev: Starting containers"

  dev start
  redis start
  apache start
  mysql start
  php56 start
  php55 start
  php54 start
  php53 start
  php52 start
  mailcatcher start
}

restart() {
  output "dev: Restarting containers"

  dev restart
  redis restart
  apache restart
  mysql restart
  php56 restart
  php55 restart
  php54 restart
  php53 restart
  php52 restart
  mailcatcher restart
}

stop() {
  output "dev: Destroying containers"

  mailcatcher stop
  php56 stop
  php55 stop
  php54 stop
  php53 stop
  php52 stop
  mysql stop
  apache stop
  redis stop
  dev stop
}

destroy() {
  output "dev: Destroying images"

  mailcatcher stop
  php56 stop
  php55 stop
  php54 stop
  php53 stop
  php52 stop
  mysql stop
  apache stop
  redis stop
  dev stop
}

status() {
  echo "status"
}

case "${1}" in
  status)
    status
  ;;
  install)
    install
    ;;
  update)
    update
    ;;
  build)
    build
  ;;
  start)
    start
    ;;
  restart)
    restart
  ;;
  stop)
    stop
  ;;
  destroy)
    destroy
    ;;
  svn)
    svn "${@:2}"
  ;;
  dev)
    dev "${@:2}"
  ;;
  redis)
    case "${2}" in
      get)
        echo -n "$(dev_get "${@:3}")"
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
  php56)
    php56 "${@:2}"
  ;;
  mailcatcher)
    mailcatcher "${@:2}"
  ;;
  phpmyadmin)
    phpmyadmin "${@:2}"
  ;;
  *)
    output_error "dev: Unknown command. See 'dev --help'"

    exit 1
  ;;
esac
