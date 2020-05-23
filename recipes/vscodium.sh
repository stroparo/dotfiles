#!/usr/bin/env bash

PROGNAME="vscodium.sh"

echo "$PROGNAME: INFO: Visual Studio Codium custom deployment >>>> this is a compound recipe"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################

cd "${RUNR_DIR:-$PWD}"

bash "${RUNR_DIR:-$PWD}"/installers/setupvscodium.sh
bash "${RUNR_DIR:-$PWD}"/recipes/conf-vscodium.sh

echo "$PROGNAME: COMPLETE: Visual Studio Codium custom deployment (compound)"
exit
