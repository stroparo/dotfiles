#!/usr/bin/env bash

: ${DEV:=${HOME}/workspace} ; export DEV

if [ ! -d "$DEV" ] ; then
  echo "################################################################################"
  echo "Workspace DEV='${DEV}' directory..."

  mkdir -p "${DEV}"
  echo "DEV dir created:"
  ls -d -l "${DEV}"

  echo "FINISHED provisioning workspace DEV='${DEV}' directory"
  echo
fi

