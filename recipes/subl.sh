#!/usr/bin/env bash

PROGNAME="subl.sh"

cd "${RUNR_DIR:-.}"

bash ./installers/setupsubl.sh

echo "IMPORTANT Install package control and only after that press ENTER..."
subl || sublime_text || exit $?
read enter_key_press_dummy_var

bash ./recipes/conf-subl.sh
