#!/usr/bin/env bash

PPA="agornostal/ulauncher"
PKG="ulauncher"

if ! egrep -i -q -r 'ubuntu' /etc/*release ; then exit ; fi
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt

if ! dpkg -s "${PKG}" ; then
  sudo add-apt-repository -y "ppa:${PPA}"
  sudo ${APTPROG} install -y "${PKG}"
fi
