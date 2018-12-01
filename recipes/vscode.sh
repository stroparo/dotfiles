#!/usr/bin/env bash

PROGNAME="vscode.sh"

cd "${RUNR_DIR:-.}"

bash ./installers/setupvscode.sh
bash ./recipes/conf-vscode.sh
