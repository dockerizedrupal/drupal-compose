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
      sudo apt-get install -y curl
      sudo apt-get install -y realpath

      curl -sSL https://get.docker.io/ubuntu/ | sudo bash

      SCRIPT=$(realpath -s $0)

      if [ "${OPTIONS_BUILD}" -eq 1 ]; then
        sudo docker build -t ${IMAGE} $(dirname ${SCRIPT})
      else
        sudo docker pull ${IMAGE}
      fi

      sudo cp ${SCRIPT} /usr/local/bin/dev
      ;;
    update)
      sudo docker pull simpledrupalcloud/node
      sudo docker rmi ${IMAGE}

      CONTEXT=$(mktemp -d)

      git clone git@git.simpledrupalcloud.com:viljaste/dev.git $CONTEXT

      if [ "${OPTIONS_BUILD}" -eq 1 ]; then
        $CONTEXT/dev.sh -b install
      else
        $CONTEXT/dev.sh install
      fi
      ;;
    remove)
      sudo docker rmi ${IMAGE}

      sudo rm /usr/local/bin/dev
      ;;
    init)
      sudo docker run --rm -i -t -v $(pwd):/context ${IMAGE} init
      ;;
    start)
      exec $(sudo docker run --rm -a stdout -i -t -v $(pwd):/context ${IMAGE} start)
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
