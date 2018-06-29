#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

echo ${BASH_VERSION:+-e} '\n\n==> Installing exa...' 1>&2

# #############################################################################
# Checks

if !(uname -a | grep -i -q linux) ; then
  echo "FATAL: Only Linux is supported." 1>&2
  exit 1
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

  # Deps - Install the Rust language platform:
  [ -d ~/.cargo/bin ] || (curl https://sh.rustup.rs -sSf | sh)
  export PATH="$HOME/.cargo/bin:$PATH"

  # Deps - Install from APT repos:
  sudo apt update || exit 1
  sudo apt install -y libgit2-dev libhttp-parser2.1 || exit $?
  which cmake >/dev/null 2>&1 || sudo apt install -y cmake || exit $?
  which git >/dev/null 2>&1 || sudo apt install -y git || exit $?

  # Compile:
  git clone https://github.com/ogham/exa.git /tmp/exa \
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

if egrep -i -q 'debian|ubuntu' /etc/*release ; then

  _install_exa_deb "$@"
  exit $?

elif egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release ; then

  echo "FATAL: _install_exa_rpm routine still to be implemented"
  exit 1

else
  echo "FATAL: OS not handled." 1>&2
  exit 1
fi
