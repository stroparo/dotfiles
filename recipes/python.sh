#!/usr/bin/env bash

PROGNAME="python.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

cd "${RUNR_DIR:-.}"

bash ./installers/setuppython.sh

bash ./recipes/conf-pip.sh
bash ./recipes/pyenv.sh
