#!/usr/bin/env bash

PROGNAME="setupbasicpackages.sh"
SCRIPT_DIR="$(dirname "${0%/*}")"
SCRIPT_DIR="${SCRIPT_DIR:-$(pwd)}"

echo "# #############################################################################"
echo "Linux package selects"
echo "# #############################################################################"

"$SCRIPT_DIR"/recipes/apps-debian.sh
"$SCRIPT_DIR"/recipes/apps-el.sh
