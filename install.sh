#!/usr/bin/env bash

do_install() {
  curl -L https://raw.githubusercontent.com/dockerizedrupal/drupal-compose/master/drupal-compose.sh > /usr/local/bin/drupal-compose

  chmod +x /usr/local/bin/drupal-compose
}

do_install
