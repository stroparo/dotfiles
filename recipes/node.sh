#!/usr/bin/env bash

PROGNAME="node.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: Node (js) env deployment started >>>> this is a compound recipe"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################

cd "${RUNR_DIR:-$PWD}"

bash "${RUNR_DIR:-$PWD}"/installers/setupnvm.sh

# bash "${RUNR_DIR:-$PWD}"/recipes/...

echo "$PROGNAME: COMPLETE: Node env deployment (compound)"
exit
