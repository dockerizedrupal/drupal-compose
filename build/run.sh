#!/usr/bin/env bash

if [ "${#}" -eq 0 ]; then
  /usr/bin/supervisord

  exit
fi

case "${1}" in
  install)
    TMP="$(mktemp -d)"

    git clone http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git "${TMP}"

    cp "${TMP}/dev.sh" /usr/local/bin/dev
  ;;
esac
