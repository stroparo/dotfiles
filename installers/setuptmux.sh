#!/usr/bin/env bash

# Daily Shells Extras extensions
# More instructions and licensing at:
# https://github.com/stroparo/ds-extras

echo ${BASH_VERSION:+-e} '\n\n==> Installing tmux...' 1>&2

# #############################################################################
# Globals

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
# Helpers

_make_install () {
  if (echo "$PREFIX" | grep -q "$HOME") ; then
    make install
  else
    sudo make install
  fi
}

# #############################################################################
# Checks

if !(uname -a | grep -i -q linux) ; then
  echo "FATAL: Only Linux is supported." 1>&2
  exit 1
fi

# #############################################################################
# Prep

set -e

mkdir -p "$PREFIX"/

echo ${BASH_VERSION:+-e} "\n==> Installing dependencies..."
if egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release* ; then
  sudo $RPMPROG install -y automake make gcc
  sudo $RPMPROG install -y glibc-static kernel-devel libevent-devel ncurses-devel
elif egrep -i -q 'debian|ubuntu' /etc/*release* ; then
  sudo $APTPROG install -y automake make gcc
fi

# #############################################################################
# Build libevent

cd "$WORKDIR"

if [ ! -e libevent-$LIBEVENT_VERSION.tar.gz ] ; then
  curl -LSfs -o libevent-$LIBEVENT_VERSION.tar.gz "$LIBEVENT_URL"
fi
tar -xzf ./libevent-$LIBEVENT_VERSION.tar.gz
cd libevent-$LIBEVENT_VERSION-stable
./configure
make
_make_install

# #############################################################################
# Build ncurses

# cd "$WORKDIR"

# if [ ! -e ncurses-$NCURSES_VERSION.tar.gz ] ; then
#   curl -LSfs -o ncurses-$NCURSES_VERSION.tar.gz "$NCURSES_URL"
# fi
# tar -xzf ncurses-$NCURSES_VERSION.tar.gz
# cd ncurses-$NCURSES_VERSION
# ./configure
# make
# _make_install

# #############################################################################
# Build tmux

cd "$WORKDIR"

if [ ! -e tmux-$TMUX_VERSION.tar.gz ] ; then
  curl -LSfs -o tmux-$TMUX_VERSION.tar.gz "$TMUX_URL"
fi
tar -xzf ./tmux-$TMUX_VERSION.tar.gz
cd tmux-$TMUX_VERSION
./configure
make
_make_install
