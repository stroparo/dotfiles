#!/usr/bin/env bash

echo
echo "################################################################################"
echo "Setup hostname"

echo ${BASH_VERSION:+-e} "\nHostname: \c" ; read newhostname
sudo hostnamectl set-hostname "${newhostname:-andromeda}"

# #############################################################################
# Finish

echo "FINISHED hostname setup"
echo
