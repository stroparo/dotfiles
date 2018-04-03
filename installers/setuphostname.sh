#!/usr/bin/env bash

echo ${BASH_VERSION:+-e} "Hostname: \c" ; read newhostname
sudo hostnamectl set-hostname "${newhostname:-andromeda}"
