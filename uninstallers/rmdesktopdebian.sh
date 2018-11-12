#!/usr/bin/env bash

export APTREMOVELIST="oxygen-icon-theme"

apt update \
  && apt purge ${APTREMOVELIST} \
  && apt autoremove \
  && apt clean
