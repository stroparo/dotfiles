#!/usr/bin/env bash

PROGNAME="shell.sh"

echo "$PROGNAME: INFO: started >>>> this is a compound recipe"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

"${RUNR_DIR:-$PWD}"/installers/setupds.sh
"${RUNR_DIR:-$PWD}"/installers/setupohmyzsh.sh
"${RUNR_DIR:-$PWD}"/recipes/alias.sh
"${RUNR_DIR:-$PWD}"/recipes/sshkeygen.sh
"${RUNR_DIR:-$PWD}"/recipes/sshmodes.sh
