#!/usr/bin/env bash

PROG=provision-sublime.sh

cd "${DOTFILES_DIR:-.}"

# #############################################################################
# Setup sublime

if ! type subl >/dev/null 2>&1 && ! type sublime_text >/dev/null 2>&1 ; then

  bash ./installers/setupsubl.sh

  echo "IMPORTANT Install package control and only after that press ENTER..."
  subl || sublime_text || exit $?
  read enter_key_press_dummy_var
fi

# #############################################################################
# Deploy dotfiles

bash ./misc/subl3/deploysublime.sh
