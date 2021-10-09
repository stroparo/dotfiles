#!/usr/bin/env bash

PROGNAME="subl.sh"

echo "$PROGNAME: INFO: SublimeText custom deployment >>>> this is a compound recipe"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################

cd "${RUNR_DIR:-$PWD}"

bash "${RUNR_DIR:-$PWD}"/installers/setupsubl.sh

echo "$PROGNAME: INFO: IMPORTANT: Install package control in sublime and hit ENTER here..."
subl || sublime_text || exit $?
read enter_key_press_dummy_var

bash "${RUNR_DIR:-$PWD}"/recipes-conf/subl-conf.sh

echo "$PROGNAME: COMPLETE: SublimeText custom deployment (compound)"
exit
