#!/usr/bin/env bash

SSH_USER=root
SSH_HOSTNAME=dev-master.simpledrupalcloud.com
SSH_PRIVATE_KEY=$(cat ~/.ssh/id_rsa)

IMAGE=docker-registry.simpledrupalcloud.com/dev

OPTIONS_BUILD=0

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
      SCRIPT_PATH=$(realpath -s $0)

      sudo apt-get install -y curl

      curl -sSL https://get.docker.io/ubuntu/ | sudo bash

      if [ "${OPTIONS_BUILD}" -eq 1 ]; then
        sudo docker build -t ${IMAGE} $(basedir ${SCRIPT_PATH})
      else
        sudo docker pull ${IMAGE}
      fi

      sudo apt-get install -y realpath

      sudo cp ${SCRIPT_PATH} /usr/local/bin/dev
      ;;
    update)
      sudo docker rmi ${IMAGE}

      CONTEXT=$(mktemp -d)

      git clone git@git.simpledrupalcloud.com:viljaste/dev.git $CONTEXT

      if [ "${OPTIONS_BUILD}" -eq 1 ]; then
        $CONTEXT/dev.sh -b install
      else
        $CONTEXT/dev.sh install
      fi
      ;;
    init)
      sudo docker run --rm -i -t -v $(pwd):/project ${IMAGE} init
      ;;
    start)

      ;;
    stop)

      ;;
    get)
      case "$2" in
        database)
          sudo docker run --rm -i -t -e SSH_PRIVATE_KEY=${SSH_PRIVATE_KEY} -e SSH_USER=${SSH_USER} -e SSH_HOSTNAME=${SSH_HOSTNAME} ${IMAGE} get database $3
          ;;
      esac
      ;;
  esac
done
