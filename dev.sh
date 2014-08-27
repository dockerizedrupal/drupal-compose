#!/usr/bin/env bash

SSH_USER=root
SSH_HOSTNAME=dev-master.simpledrupalcloud.com
SSH_PRIVATE_KEY=$(cat ~/.ssh/id_rsa)

IMAGE=docker-registry.simpledrupalcloud.com/dev

IFS=$'\n'

#OPTIONS_BUILD=0

#for option in "${@}"; do
#  case "${option}" in
#    -b|--build)
#      OPTIONS_BUILD=1
#      ;;
#  esac
#done

#for option in "${@}"; do
#  case "${option}" in
#    install)
#      install
#      ;;
#    update)
#      update
#      ;;
#    remove)
#      remove
#      ;;
#    clean)
#      clean
#      ;;
#    init)
#      init
#      ;;
#    up)
#      up
#      ;;
#    down)
#      down
#      ;;
#    destroy)
#      destroy
#      ;;
#    git)
#      git
#      ;;
#  esac
#done

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

clean() {
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
  sudo docker run --rm -i -t -v $(pwd):/src ${IMAGE} init
}

up() {
  for command in $(sudo docker run --rm -a stdout -i -t -v $(pwd):/src ${IMAGE} up); do
    eval "${command}"
  done
}

down() {
  for command in $(sudo docker run --rm -a stdout -i -t -v $(pwd):/src ${IMAGE} down); do
    eval "${command}"
  done
}

destroy() {
  for command in $(sudo docker run --rm -a stdout -i -t -v $(pwd):/src ${IMAGE} destroy); do
    eval "${command}"
  done
}

#git() {
#  sudo docker run --rm -t -i -v $(pwd):/src -v ~/.gitconfig:/root/.gitconfig -v ~/.ssh:/root/.ssh simpledrupalcloud/git "${@}"
#}
#
#svn() {
#  sudo docker run --rm -t -i -v $(pwd):/src -v ~/.subversion:/root/.subversion simpledrupalcloud/svn "${@}"
#}
#
#drush() {
#  sudo docker run --rm -t -i -v $(pwd):/src simpledrupalcloud/drush "${@}"
#}
#
#drupal_fix_permissions() {
#
#}

case "${1}" in
  init)
    init
    ;;
  up)
    up
    ;;
  down)
    down
    ;;
  destroy)
    destroy
    ;;
esac
