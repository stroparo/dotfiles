#!/usr/bin/env bash

PROGNAME="apps-desktop.sh"

echo "$PROGNAME: INFO: started >>>> this is a compound recipe"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################

cd "${RUNR_DIR:-$PWD}"

bash "${RUNR_DIR:-$PWD}"/recipes/apps-debian-desktop.sh
bash "${RUNR_DIR:-$PWD}"/recipes/apps-el-desktop.sh
bash "${RUNR_DIR:-$PWD}"/recipes/apps-ubuntu-ppa.sh

echo "$PROGNAME: COMPLETE: apps-desktop recipe (compound)"
exit
