#!/usr/bin/env bash

PROGNAME="setupsubl.sh"

if which subl >/dev/null 2>&1 || which sublime_text >/dev/null 2>&1 ; then
  echo "$PROGNAME: SKIP: Already installed, trying an upgrade..."
  sudo apt-get update && sudo apt-get install sublime-text
  exit
fi

echo "$PROGNAME: INFO: setup started..."
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

DO_PORTABLE=false
export APTPROG=apt-get
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
USAGE="$PROGNAME [-d opt_dir (effect with -p only)] [-h] [-p]"

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
while getopts ':d:hp' option ; do
  case "${option}" in
    d) SUBL_OPT_DIR="${OPTARG}";;
    h) echo "$USAGE"; exit;;
    p) DO_PORTABLE=true;;
  esac
done
shift "$((OPTIND-1))"

export SUBL_OPT_DIR

# #############################################################################
# Functions

_skip_if_installed_in_opt () {
  if ls "${SUBL_OPT_DIR}"/subl* >/dev/null 2>&1 ; then
    echo "${PROGNAME:+$PROGNAME: }SKIP: Already installed."
    echo
    echo
    exit
  fi
}

# #############################################################################
# Main

if ${DO_PORTABLE:-false} ; then
  if egrep -i -q -r 'linux' /etc/*release \
    && ! (which subl >/dev/null 2>&1 || which sublime_text >/dev/null 2>&1)
  then
    _skip_if_installed_in_opt
    mkdir -p "$SUBL_OPT_DIR"
    cd "$SUBL_OPT_DIR"
    curl -k -L -o ./subl3.tar.bz2 "$SUBL_PORTABLE_LINUX"
    sudo tar xjvf ./subl3.tar.bz2
    sudo ln -s -v ./sublime_text_3 ./subl # directory
    sudo ln -s -v sublime_text ./subl/subl # binary

  elif [[ "$(uname -a)" = *[Cc]ygwin* ]] ; then
    export SUBL_OPT_DIR="$(cygpath 'C:\opt')"
    _skip_if_installed_in_opt
    mkdir -p "$SUBL_OPT_DIR"
    cd "$SUBL_OPT_DIR"
    curl -k -L -o ./subl3.zip "$SUBL_PORTABLE_WINDOWS"
    unzip ./subl3.zip
    # TODO rename the unpackaged dir to the final '/.../...opt.../subl' dir

  else
    echo "${PROGNAME:+$PROGNAME: }SKIP: portable mode: OS not handled." 1>&2
    echo
    echo
    exit
  fi


elif egrep -i -q 'id[^=]*=arch' /etc/*release ; then
  yay -S sublime-text-3


elif egrep -i -q -r 'debian|ubuntu' /etc/*release ; then
  curl -LSf "$SUBL_APT_KEY" | sudo apt-key add -
  sudo $APTPROG install -y apt-transport-https
  if ! sudo grep -q "sublime" /etc/apt/sources.list.d/sublime-text.list 2>/dev/null ; then
    echo "$SUBL_APT_REPO" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  fi
  sudo $APTPROG update \
    && sudo $APTPROG install -y "$SUBL_APT_PKG"


elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then
  sudo rpm -v --import "$SUBL_RPM_KEY"
  sudo "${RPMPROG}" config-manager --add-repo "$SUBL_RPM_REPO"
  sudo "${RPMPROG}" install -y "$SUBL_RPM_PKG"
fi


echo "${PROGNAME:+$PROGNAME: }COMPLETE"
echo
echo
