#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

PROGNAME="setupsubl.sh"
USAGE="$PROGNAME [-d opt dir (effect with -p only)] [-h] [-p]"

echo ${BASH_VERSION:+-e} '\n\n==> Installing sublime-text...' 1>&2

# #############################################################################
# Globals

DO_PORTABLE=false

# Deb-based package
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

export DO_PORTABLE
export SUBL_OPT_DIR

# #############################################################################
# Distribution-wise package

if ! ${DO_PORTABLE:-false} ; then

  if egrep -i -q 'debian|ubuntu' /etc/*release ; then

    curl -LSf "$SUBL_APT_KEY" | sudo apt-key add -
    sudo apt-get install apt-transport-https
    echo "$SUBL_APT_REPO" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update
    sudo apt-get install "$SUBL_APT_PKG"

  elif egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release ; then

    if which dnf 2>/dev/null ; then
      sudo rpm -v --import "$SUBL_RPM_KEY"
      sudo dnf config-manager --add-repo "$SUBL_RPM_REPO"
      sudo dnf install "$SUBL_RPM_PKG"
    else
      sudo rpm -v --import "$SUBL_RPM_KEY"
      sudo yum-config-manager --add-repo "$SUBL_RPM_REPO"
      sudo yum install "$SUBL_RPM_PKG"
    fi
  fi

# #############################################################################
# Portable for Linux

elif egrep -i -q 'linux' /etc/*release ; then

  mkdir -p "$SUBL_OPT_DIR"
  cd "$SUBL_OPT_DIR"
  curl -k -L -o ./subl3.tar.bz2 "$SUBL_PORTABLE_LINUX"
  sudo tar xjvf ./subl3.tar.bz2
  sudo ln -s -v ./sublime_text_3 ./subl # directory
  sudo ln -s -v sublime_text ./subl/subl # binary

# #############################################################################
# Portable for Windows

elif [[ "$(uname -a)" = *[Cc]ygwin* ]] ; then

  SUBL_OPT_DIR="$(cygpath 'C:\opt')"
  mkdir -p "$SUBL_OPT_DIR"
  cd "$SUBL_OPT_DIR"
  curl -k -L -o ./subl3.zip "$SUBL_PORTABLE_WINDOWS"
  unzip ./subl3.zip

# #############################################################################

else
  echo "FATAL: OS not handled." 1>&2
  exit 1
fi
