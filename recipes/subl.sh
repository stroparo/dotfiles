#!/usr/bin/env bash

PROGNAME="subl.sh"

cd "${RUNR_DIR:-.}"

if ! type subl >/dev/null 2>&1 && ! type sublime_text >/dev/null 2>&1 ; then
  bash ./installers/setupsubl.sh
fi
echo "IMPORTANT Install package control and only after that press ENTER..."
subl || sublime_text || exit $?
read enter_key_press_dummy_var
bash ./subl3/sublconf.sh
