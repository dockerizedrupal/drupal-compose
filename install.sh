#!/usr/bin/env bash

do_install() {
  VERSION_FILE_URL="https://raw.githubusercontent.com/dockerizedrupal/drupal-compose/master/VERSION.md"

  TAG="$(wget ${VERSION_FILE_URL} -q -O -)"

  TMP="$(mktemp -d)"

  ARCHIVE="${TMP}/archive.tar.gz"

  curl -L "https://github.com/dockerizedrupal/drupal-compose/archive/${TAG}.tar.gz" > "${ARCHIVE}"

  TMP="$(mktemp -d)"

  tar xzf "${ARCHIVE}" -C "${TMP}"

  cp "${TMP}/drupal-compose/drupal-compose.sh" > /usr/local/bin/drupal-compose

  chmod +x /usr/local/bin/drupal-compose
}

do_install
