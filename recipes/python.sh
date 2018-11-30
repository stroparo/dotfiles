#!/usr/bin/env bash

PROGNAME="python.sh"

cd "${RUNR_DIR:-.}"

bash ./installers/setuppython.sh
bash ./recipes/conf-pip.sh

bash ./recipes/pyenvwrapper.sh
