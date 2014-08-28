#!/usr/bin/env bash

cd /src

if [ ! -d .dev ]; then
  mkdir .dev
fi

case "${1}" in
  init)
    if [ -f dev.yaml ]; then
      echo "dev.yaml file already exists"

      exit
    fi

    cp /app/dev.yaml /src/dev.yaml
    ;;
  up)
    if [ ! -f dev.yaml ]; then
      echo "Unable to find dev.yaml file from your working directory"

      exit
    fi

    printf "$(/app/dev.js yaml dev.up)"
    ;;
  down)
    if [ ! -f dev.yaml ]; then
      echo "Unable to find dev.yaml file from your working directory"

      exit
    fi

    printf "$(/app/dev.js yaml dev.down)"
    ;;
  destroy)
    if [ ! -f dev.yaml ]; then
      echo "Unable to find dev.yaml file from your working directory"

      exit
    fi

    printf "$(/app/dev.js yaml dev.destroy)"
    ;;
  yaml)
    printf $(/app/dev.js yaml "${@:2}")
    ;;
esac
