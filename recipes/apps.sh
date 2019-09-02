#!/usr/bin/env bash

PROGNAME="apps.sh"

echo "$PROGNAME: INFO: (no GUI) apps selections installation started >>>> this is a compound recipe"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################

cd "${RUNR_DIR:-$PWD}"

bash "${RUNR_DIR:-$PWD}"/recipes/apps-debian.sh
bash "${RUNR_DIR:-$PWD}"/recipes/apps-el.sh

echo "$PROGNAME: COMPLETE: (no GUI) apps selections installation recipe (compound)"
exit
