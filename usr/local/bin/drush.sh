#!/usr/bin/env bash

WORKING_DIR="$(pwd)"

output() {
  local MESSAGE="${1}"
  local COLOR="${2}"

  if [ -z "${COLOR}" ]; then
    COLOR=2
  fi

  echo -e "$(tput setaf ${COLOR})${MESSAGE}$(tput sgr 0)"
}

output_warning() {
  local MESSAGE="${1}"
  local COLOR=3

  output "${MESSAGE}" "${COLOR}"
}

output_error() {
  local MESSAGE="${1}"
  local COLOR=1

  >&2 output "${MESSAGE}" "${COLOR}"
}

ARGS="${@}"

FIG_FILE="fig.yml"
DRUPAL_ROOT_DIRECTORY="/httpd/data"

BASE_PATH=""

while [ "$(pwd)" != '/' ]; do
  if [ "$(ls | grep ${FIG_FILE})" = "${FIG_FILE}" ]; then
    BASE_PATH="$(pwd)"

    break
  fi

  cd ..
done

cd "${WORKING_DIR}"

if [ -z "${BASE_PATH}" ]; then
  output_error "drush: Fig file not found."

  exit 1
fi

CONTAINER="$(fig -f ${BASE_PATH}/${FIG_FILE} ps php 2> /dev/null | grep _php_ | awk '{ print $1 }')"

if [ -z "${CONTAINER}" ]; then
  output_error "drush: A Drupal installation directory could not be found."

  exit 1
fi

IS_CONTAINER_RUNNING="$(docker exec ${CONTAINER} date 2> /dev/null)"

if [ -z "${IS_CONTAINER_RUNNING}" ]; then
  output_error "drush: Docker container not running: ${CONTAINER}"

  exit 1
fi

if [ -t 0 ]; then
  sudo docker exec -i -t "${CONTAINER}" /bin/bash -lc "drush -r ${DRUPAL_ROOT_DIRECTORY} ${ARGS}"
else
  sudo docker exec -i "${CONTAINER}" /bin/bash -lc "drush -r ${DRUPAL_ROOT_DIRECTORY} ${ARGS}"
fi

sudo chown -R "${SUDO_USER}".www-data "${BASE_PATH}"
