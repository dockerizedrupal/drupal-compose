#!/usr/bin/env bash

ARGS="${@}"

DRUPAL_ROOT_DIRECTORY="/httpd/data"

CONTAINER="$(fig ps php 2> /dev/null | grep _php_ | awk '{ print $1 }')"

if [ -z "${CONTAINER}" ]; then
  echo "A Drupal installation directory could not be found."

  exit
fi

IS_CONTAINER_RUNNING="$(docker exec ${CONTAINER} date 2> /dev/null)"

if [ -z "${IS_CONTAINER_RUNNING}" ]; then
  echo "Docker container not running: ${CONTAINER}"

  exit
fi

if [ -t 0 ]; then
  sudo docker exec -i -t "${CONTAINER}" /bin/bash -lc "drush -r ${DRUPAL_ROOT_DIRECTORY} ${ARGS}"
else
  sudo docker exec -i "${CONTAINER}" /bin/bash -lc "drush -r ${DRUPAL_ROOT_DIRECTORY} ${ARGS}"
fi
