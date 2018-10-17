#!/usr/bin/env bash

echo
echo "################################################################################"
echo "Setup sublimetext editor"

# #############################################################################
# Globals

PROGNAME="setupsubl.sh"
USAGE="$PROGNAME [-d opt dir (effect with -p only)] [-h] [-p]"

DO_REPO=false

# Deb-based package
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
SUBL_APT_KEY="https://download.sublimetext.com/sublimehq-pub.gpg"
SUBL_APT_PKG="sublime-text"
SUBL_APT_REPO="deb https://download.sublimetext.com/ apt/stable/"

# EL-based package
SUBL_RPM_KEY="https://download.sublimetext.com/sublimehq-rpm-pub.gpg"
SUBL_RPM_PKG="sublime-text"
SUBL_RPM_REPO="https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo"

SUBL_OPT_DIR="$HOME/opt"
SUBL_PORTABLE_LINUX='https://download.sublimetext.com/sublime_text_3_build_3143_x64.tar.bz2'
SUBL_PORTABLE_WINDOWS='https://download.sublimetext.com/Sublime%20Text%20Build%203143%20x64.zip'

# #############################################################################
# Options

OPTIND=1
while getopts ':d:hr' option ; do
  case "${option}" in
    d) SUBL_OPT_DIR="${OPTARG}";;
    h) echo "$USAGE"; exit;;
    r) DO_REPO=true;;
  esac
done
shift "$((OPTIND-1))"

export DO_REPO
export SUBL_OPT_DIR

# #############################################################################
# Functions

_skip_if_installed_in_opt () {
  if ls "${SUBL_OPT_DIR}"/subl* >/dev/null 2>&1 ; then
    echo "${PROGNAME:+$PROGNAME: }SKIP: Already installed." 1>&2
    exit
  fi
}

# #############################################################################
# Distribution-wise package

if ${DO_REPO:-false} ; then

  if which subl >/dev/null 2>&1 ; then
    echo "${PROGNAME:+$PROGNAME: }SKIP: Already installed." 1>&2
    exit
  fi

  if egrep -i -q 'debian|ubuntu' /etc/*release ; then

    curl -LSf "$SUBL_APT_KEY" | sudo apt-key add -
    sudo $APTPROG install -y apt-transport-https
    echo "$SUBL_APT_REPO" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo $APTPROG update
    sudo $APTPROG install -y "$SUBL_APT_PKG"

  elif egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release ; then

    if which dnf 2>/dev/null ; then
      sudo rpm -v --import "$SUBL_RPM_KEY"
      sudo dnf config-manager --add-repo "$SUBL_RPM_REPO"
      sudo dnf install -y "$SUBL_RPM_PKG"
    else
      sudo rpm -v --import "$SUBL_RPM_KEY"
      sudo yum-config-manager --add-repo "$SUBL_RPM_REPO"
      sudo yum install -y "$SUBL_RPM_PKG"
    fi
  fi

# #############################################################################
# Portable for Linux

elif egrep -i -q 'linux' /etc/*release ; then

  mkdir -p "$SUBL_OPT_DIR"
  _skip_if_installed_in_opt
  curl -k -L -o ./subl3.tar.bz2 "$SUBL_PORTABLE_LINUX"
  sudo tar xjvf ./subl3.tar.bz2
  sudo ln -s -v ./sublime_text_3 ./subl # directory
  sudo ln -s -v sublime_text ./subl/subl # binary

# #############################################################################
# Portable for Windows

elif [[ "$(uname -a)" = *[Cc]ygwin* ]] ; then

  export SUBL_OPT_DIR="$(cygpath 'C:\opt')"
  _skip_if_installed_in_opt
  mkdir -p "$SUBL_OPT_DIR"
  cd "$SUBL_OPT_DIR"
  curl -k -L -o ./subl3.zip "$SUBL_PORTABLE_WINDOWS"
  unzip ./subl3.zip

# #############################################################################

else
  echo "SKIP: OS not handled." 1>&2
  exit
fi

# #############################################################################
# Finish

echo "FINISHED sublimetext setup"
echo
