#!/usr/bin/env bash

IMAGE=simpledrupalcloud/dev

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

  sudo docker pull "${IMAGE}"

  sudo cp "${SCRIPT}" /usr/local/bin/dev
}

update() {
  TMP=$(mktemp -d)

  git clone git@git.simpledrupalcloud.com:viljaste/dev.git "${TMP}"

  ${TMP}/dev.sh install
}

dev() {
  sudo docker run --rm -i -t "${IMAGE}" "${1}"
}

case "${1}" in
  install)
    install
    ;;
  update)
    update
    ;;
  *)
    dev "${@:1}"
    ;;
esac
