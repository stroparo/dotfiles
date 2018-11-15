#!/usr/bin/env bash

echo
echo "################################################################################"
echo "Setup exa file listing"

# #############################################################################
# Checks

if !(uname -a | grep -i -q linux) ; then
  echo "SKIP: Only Linux is supported." 1>&2
  exit
fi

# Check for idempotency
if type exa >/dev/null 2>&1 ; then
  echo "SKIP: exa already installed." 1>&2
  exit
fi

# #############################################################################
# Functions

_install_exa_deb () {
  [ ! -d ~/bin ] && ! mkdir ~/bin && exit 1

  # Dependency - Rust language platform:
  [ -d ~/.cargo/bin ] || (curl "https://sh.rustup.rs" -sSf | sh)
  export PATH="$HOME/.cargo/bin:$PATH"

  # Dependency - APT packages:
  sudo apt update || exit 1
  sudo apt install -y libgit2-dev
  sudo apt install -y libhttp-parser2.1 \
    || sudo apt install -y libhttp-parser2.7.1 \
    || exit $?
  which cmake >/dev/null 2>&1 || sudo apt install -y cmake || exit $?
  which git >/dev/null 2>&1 || sudo apt install -y git || exit $?

  # Compile:
  git clone --depth 1 "https://github.com/ogham/exa.git" /tmp/exa \
    && (cd /tmp/exa && make install)

  # Install:
  if [ -f /tmp/exa/target/release/exa ] ; then
    sudo cp /tmp/exa/target/release/exa /usr/local/bin/exa \
      && ls -l /usr/local/bin/exa \
      && rm -rf /tmp/exa
  fi
}

# #############################################################################
# Main

if egrep -i -q -r 'debian|ubuntu' /etc/*release ; then
  _install_exa_deb "$@"
  exit $?
elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then
  echo "SKIP: _install_exa_rpm routine still to be implemented" 1>&2
  exit
else
  echo "SKIP: OS not handled." 1>&2
  exit
fi

# #############################################################################
# Finish

echo "FINISHED exa setup"
echo
