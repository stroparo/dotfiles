#!/usr/bin/env bash

echo "################################################################################"
echo "Development stacks"

bash "${RUNR_DIR:-.}"/installers/setuppython.sh
bash "${RUNR_DIR:-.}"/installers/setuprust.sh
