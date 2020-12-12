#!/usr/bin/env bash

PROGNAME="setupexa.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if type exa >/dev/null 2>&1 ; then echo "${PROGNAME:+$PROGNAME: }SKIP: exa already installed." 1>&2 ; exit ; fi

echo "$PROGNAME: INFO: Setup exa setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"


_setup_exa () {
  [ ! -d ~/bin ] && ! mkdir ~/bin && exit 1

  # Dependency - Rust language platform:
  [ -d ~/.cargo/bin ] || (curl "https://sh.rustup.rs" -sSf | sh)
  export PATH="$HOME/.cargo/bin:$PATH"

  # Install:
  cargo install exa
}


_setup_exa "$@"
result=$?

echo "${PROGNAME:+$PROGNAME: }COMPLETE: exa setup complete"
exit $result
