#!/usr/bin/env bash

bash "${RUNR_DIR:-.}"/recipes/apps-debian-desktop.sh
bash "${RUNR_DIR:-.}"/recipes/apps-el-desktop.sh
bash "${RUNR_DIR:-.}"/recipes/apps-ubuntu-ppa.sh
bash "${RUNR_DIR:-.}"/installers/setupanki.sh
bash "${RUNR_DIR:-.}"/installers/setupchrome.sh
bash "${RUNR_DIR:-.}"/installers/setupdropbox.sh
