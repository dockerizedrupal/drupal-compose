#!/usr/bin/env bash

if [ "${#}" -eq 0 ]; then
  /usr/bin/supervisord

  exit
fi


