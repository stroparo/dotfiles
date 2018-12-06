#!/usr/bin/env bash

(uname | grep -i -q linux) || exit

PROGNAME=setuprust.sh

echo
echo "################################################################################"
echo "Setup Rust"

# #############################################################################
# Checks

# Check for idempotency
if type rustc >/dev/null 2>&1 ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: Rust already installed." 1>&2
  exit
fi

# #############################################################################
# Main

if [ ! -d ~/.cargo/bin ] ; then
  (curl -LSfs "https://sh.rustup.rs" | sh)
fi

PATH_STRING='export PATH="$HOME/.cargo/bin:$PATH"'
grep -q 'PATH=.*[.]cargo' ~/.bashrc || echo "$PATH_STRING" >> ~/.bashrc
grep -q 'PATH=.*[.]cargo' ~/.zshrc  || echo "$PATH_STRING" >> ~/.zshrc

eval $PATH_STRING
if ! which rustc 2>/dev/null ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: rustc compiler not found." 1>&2
  exit 1
fi

# #############################################################################
# Finish

echo "${PROGNAME:+$PROGNAME: }INFO: Rust setup complete"
echo
