#!/usr/bin/env bash

PROGNAME="vscodium.sh"


echo "$PROGNAME: INFO: started (compound)..."
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"


cd "${RUNR_DIR:-$PWD}"

bash "${RUNR_DIR:-$PWD}"/installers/setupvscodium.sh
bash "${RUNR_DIR:-$PWD}"/recipes/conf-vscodium.sh


echo "$PROGNAME: COMPLETE (compound)"
exit
