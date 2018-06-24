#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "${0%/*}")"
SCRIPT_DIR="${SCRIPT_DIR:-$(pwd)}"

"$SCRIPT_DIR"/recipes/apps-debian.sh
"$SCRIPT_DIR"/recipes/apps-el.sh
