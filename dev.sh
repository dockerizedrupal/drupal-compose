#!/usr/bin/env bash

IMAGE=docker-registry.simpledrupalcloud.com/dev

IFS=$'\n'

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
#  for command in $(sudo docker run --rm -a stdout -i -t -v $(pwd):/src ${IMAGE} up); do
#    eval "${command}"
#  done

echo $(sudo docker run --rm -a stdout -i -t -v $(pwd):/src ${IMAGE} up)
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

yaml_environment_ssh_user() {
  echo $(sudo docker run --rm -a stdout -i -t -v $(pwd):/src ${IMAGE} yaml get environments."${1}".ssh.user)
}

yaml_environment_ssh_user_exists() {
  echo $(sudo docker run --rm -a stdout -i -t -v $(pwd):/src ${IMAGE} yaml exists environments."${1}".ssh.user)
}

yaml_environment_ssh_hostname() {
  echo $(sudo docker run --rm -a stdout -i -t -v $(pwd):/src ${IMAGE} yaml get environments."${1}".ssh.hostname)
}

yaml_environment_ssh_hostname_exists() {
  echo $(sudo docker run --rm -a stdout -i -t -v $(pwd):/src ${IMAGE} yaml exists environments."${1}".ssh.hostname)
}

yaml_environment_drupal_path() {
  echo $(sudo docker run --rm -a stdout -i -t -v $(pwd):/src ${IMAGE} yaml get environments."${1}".drupal.path)
}

yaml_environment_drupal_path_exists() {
  echo $(sudo docker run --rm -a stdout -i -t -v $(pwd):/src ${IMAGE} yaml exists environments."${1}".drupal.path)
}

yaml_environment_exists() {
  echo $(sudo docker run --rm -a stdout -i -t -v $(pwd):/src ${IMAGE} yaml exists environments."${1}")
}

ssh() {
  sudo docker run --rm -t -i -v ~/.ssh:/root/.ssh simpledrupalcloud/ssh "${@}"
}

ssh_environment() {
  ssh -t "$(yaml_environment_ssh_user ${1})@$(yaml_environment_ssh_hostname ${1})" "cd $(yaml_environment_drupal_path ${1}) && exec \$SHELL -l"
}

git() {
  sudo docker run --rm -t -i -v $(pwd):/src -v ~/.gitconfig:/root/.gitconfig -v ~/.ssh:/root/.ssh simpledrupalcloud/git "${@}"
}

svn() {
  sudo docker run --rm -t -i -v $(pwd):/src -v ~/.subversion:/root/.subversion simpledrupalcloud/svn "${@}"
}

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
    echo $(yaml_environment_exists "${2}")

    if [ $(yaml_environment_exists "${2}") = "true" ]; then
      ssh_environment "${2}"
    else
      ssh "${@:2}"
    fi
    ;;
  sync)
    case "${2}" in
      database)
        echo "sync database"
        ;;
      files)
        echo "file"
      ;;
    esac
    ;;
  git)
    git "${@:1}"
  ;;
  svn)
    svn "${@:1}"
  ;;
esac
