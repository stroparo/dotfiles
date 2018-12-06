#!/usr/bin/env bash

(uname | grep -i -q linux) || exit

PROGNAME="python.sh"

cd "${RUNR_DIR:-.}"

bash ./installers/setuppython.sh

bash ./recipes/conf-pip.sh
bash ./recipes/pyenv.sh
