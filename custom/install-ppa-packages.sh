#!/usr/bin/env bash

# #############################################################################
# Add PPA repos

for ppa in \
hsoft/ppa \
nextcloud-devs/client \
nathan-renniewaldock/qdirstat \
remmina-ppa-team/remmina-next \
webupd8team/y-ppa-manager
do
  echo ${BASH_VERSION:+-e} "\n==> ls /etc/apt/sources.list.d/${ppa%/*}*.list"
  if ! eval ls -l "/etc/apt/sources.list.d/${ppa%/*}*.list" 2>/dev/null ; then
    sudo add-apt-repository "ppa:$ppa"
  fi
done

# #############################################################################
# Install packages

sudo apt update
sudo aptitude install dupeguru-se dupeguru-me dupeguru-pe moneyguru pdfmasher
sudo aptitude install nextcloud-client
sudo aptitude install qdirstat
sudo aptitude install remmina remmina-plugin-rdp remmina-plugin-vnc libfreerdp-plugins-standard
sudo aptitude install y-ppa-manager

# #############################################################################
# Cleanup

sudo apt autoremove
sudo apt clean
