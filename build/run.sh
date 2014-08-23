#!/usr/bin/env bash

case "$1" in
  get)
    case "$2" in
      database)
        echo ${SSH_PRIVATE_KEY} | ssh -i /dev/stdin ${SSH_USER}@${SSH_HOSTNAME} dev-master get database $3
        ;;
    esac
    ;;
esac
