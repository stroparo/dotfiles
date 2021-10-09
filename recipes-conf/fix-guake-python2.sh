#!/usr/bin/env bash

PROGNAME="fix-guake-python2.sh"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

which guake || exit $?

# Globals
GUAKE_PATH=$(which -a guake | tail -n 1)
PY2_PATH="$(which -a python2 | tail -n 1 | sed -e 's#[/]#\\/#g')"

# Fix it
sudo sed -i -e "/PYTHON=.* python2/s/ python2/ $PY2_PATH/" "$GUAKE_PATH"
grep 'PYTHON=.*python2' "$GUAKE_PATH" /dev/null
