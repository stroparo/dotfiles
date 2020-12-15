#!/bin/sh

PROGNAME="apps-cli.sh"
export APTPROG=apt-get
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"
export PKG_LIST_FILE_EL="${RUNR_DIR}/assets/pkgs-el.lst"
export PKG_LIST_FILE_EL_EPEL="${RUNR_DIR}/assets/pkgs-el-epel.lst"
export PKG_LIST_FILE_UBUNTU="${RUNR_DIR}/assets/pkgs-ubuntu.lst"

export INSTPROG="${APTPROG}"


if grep -i -q -r 'debian' /etc/*release ; then
  isdebian=true
  export PKG_LIST_FILE="${PKG_LIST_FILE_UBUNTU}"

elif grep -i -q -r 'ubuntu' /etc/*release ; then
  isubuntu=true
  export PKG_LIST_FILE="${PKG_LIST_FILE_UBUNTU}"

elif egrep -i -q -r 'rhel|enterprise|centos|fedora|oracle linux' /etc/*release ; then
  isel=true
  export INSTPROG="$RPMPROG"
  export PKG_LIST_FILE="${PKG_LIST_FILE_EL}"

else
  echo "${PROGNAME:+$PROGNAME: }SKIP: OS not supported." 1>&2
  exit
fi


_is_el () { egrep -i -q -r '(cent *os|oracle|red *hat)' /etc/*release ; }
_is_el6 () { egrep -i -q -r '(cent *os|oracle|red *hat).* 6' /etc/*release ; }
_is_el7 () { egrep -i -q -r '(cent *os|oracle|red *hat).* 7' /etc/*release ; }
_is_fedora () { egrep -i -q -r 'fedora' /etc/*release ; }


_assemble_valid_pkg_list () {
  pkg_list="$(sed -e 's/ *#.*$//' "${1}" | tr '\n' ' ')"
  for pkg in $(echo ${pkg_list}) ; do
    if apt-cache show "${pkg}" >/dev/null 2>&1 ; then
      echo "${pkg}"
    fi
  done \
  | tr -s '\n' ' '
}


_prep_el () {
  # Package indexing setup
  sudo yum makecache fast

  if ! _is_fedora ; then
    echo "PROGNAME: INFO: EPEL - Extra Packages for Enterprise Linux..." # https://fedoraproject.org/wiki/EPEL
    if _is_el7 ; then
      _install_packages https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    else
      _install_packages epel-release.noarch
    fi
  fi

  sudo $RPMGROUP -q -y --enablerepo=epel 'Development Tools'
}


_install_epel_packages () {
  typeset timestamp="$(date '+%Y%m%d-%OH%OM%OS')"

  echo "$PROGNAME: INFO: Installing EPEL packages..."
  if ! (sudo "${INSTPROG}" install -y --enablerepo=epel "$@" 2>&1 | tee "/tmp/pkg-install-epel-${timestamp}.log") ; then
    echo "${PROGNAME:+$PROGNAME: }WARN: There was an error installing packages - see '/tmp/pkg-install-epel-${timestamp}.log'." 1>&2
  fi
}


_install_packages () {
  typeset timestamp="$(date '+%Y%m%d-%OH%OM%OS')"

  echo
  echo
  echo "$PROGNAME: INFO: Installing packages..."
  if ! (sudo "${INSTPROG}" install -y $(_assemble_valid_pkg_list "${PKG_LIST_FILE}") 2>&1 | tee "/tmp/pkg-install-${timestamp}.log") ; then
    echo "$PROGNAME: WARN: There was an error installing packages - see '/tmp/pkg-install-${timestamp}.log'." 1>&2
  fi
}


_cleanup () {
  if ${isdebian:-false} || ${isubuntu:-false} ; then
    echo
    echo
    echo "$PROGNAME: INFO: APT repository clean up (autoremove & clean)..."
    sudo $APTPROG autoremove -y
    sudo $APTPROG clean -y
  fi
}


echo "$PROGNAME: INFO: started..."
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"


if ${isdebian:-false} || ${isubuntu:-false} ; then
  if ! (sudo $APTPROG update | tee '/tmp/apt-update-err.log') ; then
    echo "$PROGNAME: WARN: There was some failure during APT index update - see '/tmp/apt-update-err.log'." 1>&2
  fi
elif ${isel} ; then
  _prep_el
  _install_epel_packages $(_assemble_valid_pkg_list "${PKG_LIST_FILE_EL_EPEL}")
fi

_install_packages
_cleanup

echo
echo
echo "$PROGNAME: COMPLETE"
exit
