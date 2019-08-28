#!/usr/bin/env bash

PROGNAME="setuptmux.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: only Linux supported." ; exit ; fi

echo "$PROGNAME: INFO: tmux Terminal MUltipleXer setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

set -e

# #############################################################################
# Globals

PREFIX="${1:-/usr/local}"
WORKDIR="$HOME"

export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf

LIBEVENT_VERSION=2.1.8
LIBEVENT_URL="https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VERSION-stable/libevent-$LIBEVENT_VERSION-stable.tar.gz"

NCURSES_VERSION=6.1
NCURSES_URL="https://ftp.gnu.org/pub/gnu/ncurses/ncurses-$NCURSES_VERSION.tar.gz"

TMUX_VERSION=2.6
TMUX_URL="https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/tmux-$TMUX_VERSION.tar.gz"

# #############################################################################
# Functions


_make_install () {
  if (echo "$PREFIX" | grep -q "$HOME") ; then
    make install
  else
    sudo make install
  fi
}


_install_system_deps () {
  echo ${BASH_VERSION:+-e} "\n==> Installing dependencies..."
  if egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then
    sudo $RPMPROG install -y automake make gcc
    sudo $RPMPROG install -y glibc-static
    sudo $RPMPROG install -y kernel-devel
    sudo $RPMPROG install -y libevent libevent-devel libevent-headers
    sudo $RPMPROG install -y ncurses ncurses-devel
  elif egrep -i -q -r 'debian|ubuntu' /etc/*release ; then
    sudo $APTPROG install -y automake make gcc
  fi
}


_build_libevent () {

  cd "$WORKDIR"

  if [ ! -e libevent-$LIBEVENT_VERSION.tar.gz ] ; then
    curl ${DLOPTEXTRA} -LSfs -o libevent-$LIBEVENT_VERSION.tar.gz "$LIBEVENT_URL"
  fi
  tar -xzf ./libevent-$LIBEVENT_VERSION.tar.gz
  cd libevent-$LIBEVENT_VERSION-stable
  ./configure --prefix="$PREFIX"
  make
  _make_install
}


_build_ncurses () {

  cd "$WORKDIR"

  if [ ! -e ncurses-$NCURSES_VERSION.tar.gz ] ; then
    curl -LSfs -o ncurses-$NCURSES_VERSION.tar.gz "$NCURSES_URL"
  fi
  tar -xzf ncurses-$NCURSES_VERSION.tar.gz
  cd ncurses-$NCURSES_VERSION
  ./configure --prefix="$PREFIX"
  make
  _make_install
}


_build_deps () {
  _install_system_deps
  _build_libevent
  _build_ncurses
}


_build_main () {

  cd "$WORKDIR"

  if which tmux >/dev/null 2>&1 && [ -d ./."tmux-$TMUX_VERSION" ] ; then
    echo "${PROGNAME:+$PROGNAME: }SKIP: tmux likely already built and installed." 1>&2
    return
  fi

  _build_deps

  if [ ! -e ./."tmux-$TMUX_VERSION".tar.gz ] ; then
    curl ${DLOPTEXTRA} -LSfs -o ./."tmux-$TMUX_VERSION".tar.gz "$TMUX_URL"
  fi
  tar -xzf ./."tmux-$TMUX_VERSION".tar.gz
  mv "tmux-$TMUX_VERSION" ."tmux-$TMUX_VERSION"
  cd ."tmux-$TMUX_VERSION"
  LDFLAGS="-L$PREFIX/lib -Wl,-rpath=$PREFIX/lib" \
    ./configure --prefix="$PREFIX"
  make
  _make_install
}


_install_plugin_manager () {
  mkdir -p ~/.tmux/plugins >/dev/null
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}


# #############################################################################
# Main

mkdir -p "$PREFIX"/
if [ ! -d "$PREFIX" ] ; then
  echo "FATAL: No prefix dir ($PREFIX)." 1>&2
  exit 1
fi

_build_main
_install_plugin_manager

echo "$PROGNAME: COMPLETE: tmux setup"
exit
