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
    printf "$(/app/dev.js up /src)"
    ;;
  down)
    printf "$(/app/dev.js down /src)"
    ;;
  destroy)
    printf "$(/app/dev.js destroy /src)"
    ;;
esac
