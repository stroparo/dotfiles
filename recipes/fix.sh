#!/usr/bin/env bash

echo "################################################################################"
echo "Applying fixes list in '$0'..."

bash "${RUNR_DIR:-.}"/recipes/fix-apt-modes.sh
bash "${RUNR_DIR:-.}"/recipes/fix-fedora-input.sh
bash "${RUNR_DIR:-.}"/recipes/fix-guake-python2.sh
