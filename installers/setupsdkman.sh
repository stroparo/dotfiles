#!/usr/bin/env bash

PROGNAME="setupsdkman.sh"

# #############################################################################
# Globals

export SDKMAN_DIR="${HOME}/.sdkman"

# #############################################################################
# Functions

_error_exit () {
  echo "${PROGNAME:+$PROGNAME: }FATAL: There was some error installing sdkman." 1>&2
  exit 1
}

_setup_sdkman_profile () {
  if ! egrep -i -q 'SDKMAN_DIR=' ~/.bashrc ; then
    cat <<EOF | tee ~/.bashrc ~/.zshrc > /dev/null
export SDKMAN_DIR="${SDKMAN_DIR}"
[[ -s "\${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "\${SDKMAN_DIR}/bin/sdkman-init.sh"
EOF
  fi
}

# #############################################################################
# Reqs

if ! which zip ; then
  if (uname -a | grep -i -q linux) ; then
    if egrep -i -q -r 'debian|ubuntu' /etc/*release 2>/dev/null ; then
      sudo apt update && sudo apt install -y zip
    elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release 2>/dev/null ; then
      sudo yum install -y zip
    fi
  fi
fi
if ! which zip ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: must have the 'zip' program in the PATH." 1>&2
  exit 1
fi

# #############################################################################
# Main

if ! curl -s "https://get.sdkman.io" | bash ; then
  _error_exit
fi

_setup_sdkman_profile

echo "${PROGNAME:+$PROGNAME: }COMPLETE: sdkman setup complete." 1>&2
