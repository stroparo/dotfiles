#!/usr/bin/env bash

(uname | grep -i -q linux) || exit

echo "################################################################################"
echo "Applying Linux fixes in '${RUNR_DIR:-.}/recipes-linux-fixes'..."

for fix in "${RUNR_DIR:-.}"/recipes-linux-fixes/fix-* ; do
  bash "${fix}"
done

echo
echo "////////////////////////////////////////////////////////////////////////////////"
echo

