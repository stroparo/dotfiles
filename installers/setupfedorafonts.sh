#!/usr/bin/env bash

export PROGNAME="setupfedorafonts.sh"
export PROGDESC="\"Better fonts for Fedora\" setup"

if ! sudo which dnf ; then echo "$PROGNAME: SKIP: Linux with dnf supported only" ; exit ; fi

# #############################################################################
# Helpers

_prep () {
  sudo dnf copr enable dawid/better_fonts
}

_install () {
  sudo dnf install fontconfig-enhanced-defaults fontconfig-font-replacements
}

_finish () {
  echo "$PROGNAME: COMPLETE: ${PRODDESC}"
  exit
}

# #############################################################################
# Main

echo "$PROGNAME: INFO: ${PRODDESC} started (${PROGNAME})"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

_prep
_install
_finish
