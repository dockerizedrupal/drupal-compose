#!/usr/bin/env bash

case "${1}" in
  install)
    TMP="$(mktemp -d)"

    git clone http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git "${TMP}"

    cp "${TMP}/dev.sh" /usr/local/bin/dev
  ;;
  *)
    /usr/bin/supervisord
  ;;
esac
