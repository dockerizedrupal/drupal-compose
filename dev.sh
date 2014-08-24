#!/usr/bin/env bash

SSH_USER=root
SSH_HOSTNAME=dev-master.simpledrupalcloud.com
SSH_PRIVATE_KEY=$(cat ~/.ssh/id_rsa)

IMAGE=docker-registry.simpledrupalcloud.com/dev

OPTIONS_BUILD=0

install() {
  SCRIPT=$(realpath -s $0)

  if [ "${SCRIPT}" = "/usr/local/bin/dev" ]; then
    cat << EOF
dev is already installed on this machine.

Type "dev update" to get the latest updates or "dev remove" to remove the command from this machine.
EOF
    exit
  fi

  sudo apt-get install -y curl
  sudo apt-get install -y realpath

  curl -sSL https://get.docker.io/ubuntu/ | sudo bash

  if [ "${OPTIONS_BUILD}" -eq 1 ]; then
    sudo docker build -t ${IMAGE} $(dirname ${SCRIPT})
  else
    sudo docker pull ${IMAGE}
  fi

  sudo cp ${SCRIPT} /usr/local/bin/dev
}

update() {
  sudo docker rmi -f ${IMAGE}

  CONTEXT=$(mktemp -d)

  git clone git@git.simpledrupalcloud.com:viljaste/dev.git $CONTEXT

  if [ "${OPTIONS_BUILD}" -eq 1 ]; then
    $CONTEXT/dev.sh -b install
  else
    $CONTEXT/dev.sh install
  fi
}

remove() {
  sudo docker rmi -f ${IMAGE}

  sudo rm /usr/local/bin/dev
}

clean()
  CONTAINERS=$(docker ps -a -q)

  if [ -n "${CONTAINERS}" ]; then
    sudo docker stop ${CONTAINERS}
    sudo docker rm ${CONTAINERS}
  fi

  IMAGES=$(docker images -q)

  if [ -n "${IMAGES}" ]; then
    sudo docker rmi ${IMAGES}
  fi
}

init() {
  sudo docker run --rm -i -t -v $(pwd):/context ${IMAGE} init
}

start() {
  exec $(sudo docker run --rm -a stdout -i -t -v $(pwd):/context ${IMAGE} start)
}

stop() {
  echo "stop"
}

for option in "${@}"; do
  case "${option}" in
    -b|--build)
      OPTIONS_BUILD=1
      ;;
  esac
done

for option in "${@}"; do
  case "${option}" in
    install)
      install
      ;;
    update)
      update
      ;;
    remove)
      remove
      ;;
    clean)
      clean
      ;;
    init)
      init
      ;;
    start)
      start
      ;;
    stop)
      stop
      ;;
  esac
done
