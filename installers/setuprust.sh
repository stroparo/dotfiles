#!/usr/bin/env bash
cat <<EOF
################################################################################
Rust platform
################################################################################
EOF

# #############################################################################
# Checks

if !(uname -a | grep -i -q linux) ; then
  echo "SKIP: Only Linux is supported." 1>&2
  exit
fi

# Check for idempotency
if type rustc >/dev/null 2>&1 ; then
  echo "SKIP: Rust already installed." 1>&2
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
