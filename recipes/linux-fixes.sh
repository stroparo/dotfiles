#!/usr/bin/env bash

(uname | grep -i -q linux) || exit

echo "################################################################################"
echo "Applying fixes list in '$0'..."

bash "${RUNR_DIR:-.}"/fixes/fix-apt-modes.sh
bash "${RUNR_DIR:-.}"/fixes/fix-fedora-input.sh
bash "${RUNR_DIR:-.}"/fixes/fix-guake-python2.sh
