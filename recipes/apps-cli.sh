#!/bin/sh

PROGNAME="apps-debian.sh"
export APTPROG=apt-get
export INSTPROG=apt-get
export PKG_LIST_FILE_UBUNTU="${RUNR_DIR}/assets/pkgs-ubuntu.lst"


if grep -i -q -r 'debian' /etc/*release ; then
  isdebian=true
  export PKG_LIST_FILE="${PKG_LIST_FILE_UBUNTU}"
elif grep -i -q -r 'ubuntu' /etc/*release ; then
  isubuntu=true
  export PKG_LIST_FILE="${PKG_LIST_FILE_UBUNTU}"
else
  echo "${PROGNAME:+$PROGNAME: }SKIP: OS not supported." 1>&2
  exit
fi


_assemble_valid_pkg_list () {
  pkg_list="$(sed -e 's/ *#.*$//' "${1}" | tr '\n' ' ')"
  for pkg in $(echo ${pkg_list}) ; do
    if apt-cache show "${pkg}" >/dev/null 2>&1 ; then
      echo "${pkg}"
    fi
  done \
  | tr -s '\n' ' '
}


_install_packages () {
  typeset timestamp="$(date '+%Y%m%d-%OH%OM%OS')"

  echo
  echo "$PROGNAME: INFO: Installing packages..."
  if ! (sudo "${INSTPROG}" install -y $(_assemble_valid_pkg_list "${PKG_LIST_FILE}") 2>&1 | tee "/tmp/pkg-install-${timestamp}.log") ; then
    echo "$PROGNAME: WARN: There was an error installing package '${package}' - see '/tmp/pkg-install-${timestamp}.log'." 1>&2
  fi
}


echo "$PROGNAME: INFO: started..."
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"


if ${isdebian:-false} || ${isubuntu:-false} ; then
  if ! (sudo $APTPROG update | tee '/tmp/apt-update-err.log') ; then
    echo "$PROGNAME: WARN: There was some failure during APT index update - see '/tmp/apt-update-err.log'." 1>&2
  fi
fi

_install_packages

if ${isdebian:-false} || ${isubuntu:-false} ; then
  echo "$PROGNAME: INFO: APT repository clean up (autoremove & clean)..."
  sudo $APTPROG autoremove -y
  sudo $APTPROG clean -y
fi

echo
echo
echo "$PROGNAME: COMPLETE"
exit
