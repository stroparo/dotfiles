#!/usr/bin/env bash

PROGNAME="python.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: Python env deployment started >>>> this is a compound recipe"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################

cd "${RUNR_DIR:-$PWD}"

bash "${RUNR_DIR:-$PWD}"/installers/setuppython.sh

bash "${RUNR_DIR:-$PWD}"/recipes/conf-pip.sh
bash "${RUNR_DIR:-$PWD}"/recipes/pyenv.sh
bash "${RUNR_DIR:-$PWD}"/recipes/fix-ipython-virtualenv.sh

echo "$PROGNAME: COMPLETE: Python env deployment (compound)"
exit
