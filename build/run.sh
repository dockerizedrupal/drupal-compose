#!/usr/bin/env bash

case "$1" in
  init)
    echo 1

    cd /app

    ls -la

    cat ./dev.js

    ./dev.js init /context

    echo 2
    echo 5
    ;;
  get)
    case "$2" in
      database)
        echo ${SSH_PRIVATE_KEY} | ssh -i /dev/stdin ${SSH_USER}@${SSH_HOSTNAME} dev-master get database $3
        ;;
    esac
    ;;
esac
