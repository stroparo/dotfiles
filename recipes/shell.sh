#!/usr/bin/env bash

PROGNAME="shell.sh"

echo "$PROGNAME: INFO: shell custom deployment started >>>> this is a compound recipe"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################

cd "${RUNR_DIR:-$PWD}"

bash "${RUNR_DIR:-$PWD}"/installers/setupsidra.sh
bash "${RUNR_DIR:-$PWD}"/installers/setupohmyzsh.sh
bash "${RUNR_DIR:-$PWD}"/recipes/alias.sh

echo "$PROGNAME: COMPLETE: shell custom deployment (compound)"
exit
