#!/usr/bin/env bash

PROGNAME="apps-cli.sh"

export PKG_LIST_FILE_ARCH="${RUNR_DIR}/assets/pkgs-arch.lst"
export PKG_LIST_FILE_EL="${RUNR_DIR}/assets/pkgs-el.lst"
export PKG_LIST_FILE_EL_EPEL="${RUNR_DIR}/assets/pkgs-el-epel.lst"
export PKG_LIST_FILE_UBUNTU="${RUNR_DIR}/assets/pkgs-ubuntu.lst"


echo "$PROGNAME: INFO: started..."
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

source "${RUNR_DIR:-.}"/helpers/sidraenforce.sh

cd "${RUNR_DIR:-$PWD}"

# #############################################################################
if _is_arch_family ; then
  export PKG_LIST_FILE="${PKG_LIST_FILE_ARCH}"

  sudo "$PACPROG" -Sy

  # Essential GUI environment packages best installed early on:
  if which caja >/dev/null 2>&1 \
    || which dolphin >/dev/null 2>&1 \
    || which nautilus >/dev/null 2>&1 \
    || which nemo >/dev/null 2>&1 \
    || which pcmanfm >/dev/null 2>&1 \
    || which thunar >/dev/null 2>&1 \
    || sudo systemctl status gdm \
    || sudo systemctl status lightdm \
    || sudo systemctl status lxdm \
    || sudo systemctl status sddm
  then
    sudo pacman -S ntfs-3g x11-ssh-askpass
  fi

# #############################################################################
elif _is_debian_family ; then
  export PKG_LIST_FILE="${PKG_LIST_FILE_UBUNTU}"

  if ! (sudo "$APTPROG" update | tee '/tmp/apt-update-err.log') ; then
    echo "$PROGNAME: WARN: There was some failure during APT index update - see '/tmp/apt-update-err.log'." 1>&2
  fi
# #############################################################################
elif _is_el_family ; then
  export PKG_LIST_FILE="${PKG_LIST_FILE_EL}"

  installrepoepel
  sudo $RPMGROUP -q -y --enablerepo=epel 'Development Tools'
  installpkgsepel $(validpkgs "${PKG_LIST_FILE_EL_EPEL}")
# #############################################################################
else
  echo "${PROGNAME:+$PROGNAME: }SKIP: OS not supported." 1>&2
  exit
fi
# #############################################################################

installpkgs $(validpkgs "${PKG_LIST_FILE}")

if _is_debian_family ; then
  aptcleanup
fi

echo
echo
echo "$PROGNAME: COMPLETE"
exit
