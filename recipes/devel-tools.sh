#!/usr/bin/env bash

echo "################################################################################"
echo "Development tools"

bash "${RUNR_DIR:-.}"/installers/setupdocker.sh
bash "${RUNR_DIR:-.}"/installers/setupdocker-compose.sh
bash "${RUNR_DIR:-.}"/installers/setupexa.sh
bash "${RUNR_DIR:-.}"/installers/setupvim.sh python3

bash "${RUNR_DIR:-.}"/recipes/devel-fonts.sh
