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
  sudo apt-get install -y realpath

  SCRIPT=$(realpath -s $0)

  if [ "${SCRIPT}" = /usr/local/bin/dev ]; then
    cat << EOF
dev is already installed on this machine.

Type "dev update" to get the latest updates.
EOF
    exit
  fi

  sudo apt-get install -y curl

  curl -sSL https://get.docker.io/ubuntu/ | sudo bash

  sudo docker pull ${IMAGE}

  sudo cp ${SCRIPT} /usr/local/bin/dev
}

update() {
  CONTEXT=$(mktemp -d)

  git clone git@git.simpledrupalcloud.com:viljaste/dev.git $CONTEXT

  $CONTEXT/dev.sh install
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

ssh() {
  sudo docker run --rm -t -i -v ~/.ssh:/root/.ssh simpledrupalcloud/ssh "${@}"
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
  install)
    install
    ;;
  update)
    update
    ;;
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
  ssh)
    case "${2}" in
      master)
        SSH_USER=$(sudo docker run --rm -a stdout -i -t -v $(pwd):/src ${IMAGE} yaml dev-master.ssh.user)
        SSH_HOSTNAME=$(sudo docker run --rm -a stdout -i -t -v $(pwd):/src ${IMAGE} yaml dev-master.ssh.hostname)

        ssh "${SSH_USER}@${SSH_HOSTNAME}"
        ;;
    esac
    ;;
  sync)


    ;;
  local)
    local
    ;;
  remote)
    local
    ;;
esac
