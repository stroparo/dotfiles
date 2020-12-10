#!/usr/bin/env bash

export PROGNAME="setuppowerfonts.sh"
export PROGDESC="powerline fonts setup"
export INSTALLED_SUCCESSFULLY=false
export INSTALLER_DIR="${HOME}/fonts-master"
export INSTALLER_PKG="${HOME}/.powerline-fonts.zip"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

if [ -e "$HOME/.local/share/fonts/Inconsolata for Powerline.otf" ] ; then
  echo "SKIP: Already installed." 1>&2
  exit
fi

# #############################################################################
# Helpers

_get_package () {
  wget https://github.com/powerline/fonts/archive/master.zip \
    -O "${INSTALLER_PKG}"
  (cd "$HOME" ; unzip "$(basename ${INSTALLER_PKG})")
}

_get_package_git () {
  git clone --depth 1 "https://github.com/powerline/fonts.git" "${INSTALLER_DIR}"
}

_update_fc_cache () {
  fc-cache -f -v
  sudo fc-cache -f -v

  mkfontscale "${LOCAL_FONTS_DIR}"
  mkfontdir "${LOCAL_FONTS_DIR}"

  if ls -l "${LOCAL_FONTS_DIR}"/* ; then
    echo "$PROGNAME: SUCCESS: installed fonts successfully."
    return
  else
    exit 1
  fi
}

_remove_package () {
  rm -rf "${INSTALLER_DIR}" || ls -d -l "${INSTALLER_DIR}"
  if [ -f "${INSTALLER_PKG}" ] ; then
    rm -rf "${INSTALLER_PKG}" || ls -l "${INSTALLER_PKG}"
  fi
}

_install () {
  if [ ! -f "${INSTALLER_DIR}"/install.sh ] ; then
    return 1
  fi
  if "${INSTALLER_DIR}"/install.sh ; then
    _update_fc_cache
    _remove_package
  fi
}

_finish () {
  echo "$PROGNAME: COMPLETE: ${PRODDESC}"
  exit
}

# #############################################################################
# Main

echo "$PROGNAME: INFO: ${PRODDESC} started (${PROGNAME})"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

_get_package
# _get_package_git
_install
_finish
