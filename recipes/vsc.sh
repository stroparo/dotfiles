#!/usr/bin/env bash

PROGNAME="vsc.sh"

echo "$PROGNAME: INFO: VSCode custom deployment >>>> this is a compound recipe"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################

cd "${RUNR_DIR:-$PWD}"

bash "${RUNR_DIR:-$PWD}"/installers/setupvscode.sh
bash "${RUNR_DIR:-$PWD}"/recipes/conf-vscode.sh

echo "$PROGNAME: COMPLETE: VSCode custom deployment (compound)"
exit
