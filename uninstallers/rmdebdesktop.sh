#!/usr/bin/env bash

apt update \
  && apt purge evince firefox* gimp libreoffice* vlc \
  && apt autoremove \
  && apt clean
