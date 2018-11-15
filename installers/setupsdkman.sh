#!/usr/bin/env bash

PROGNAME="setupsdkman.sh"

# #############################################################################
# Globals

export SDKMAN_DIR="/usr/local/sdkman"

# #############################################################################
# Functions

_error_exit () {
  echo "${PROGNAME:+$PROGNAME: }FATAL: There was some error installing sdkman." 1>&2
  exit 1
}

# #############################################################################
# Reqs

if ! which zip ; then
  if egrep -i -q -r 'debian|ubuntu' /etc/*release ; then
    sudo apt update && sudo apt install -y zip
  elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then
    sudo yum install -y zip
  fi
fi

# #############################################################################
# Main

if ! curl -s "https://get.sdkman.io" | bash ; then
  _error_exit
fi

if [ ! -f /etc/profile.d/sdkman.sh ] ; then
  cat <<EOF | sudo tee /etc/profile.d/sdkman.sh > /dev/null
export SDKMAN_DIR="${SDKMAN_DIR}"
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
EOF
  chmod 755 /etc/profile.d/sdkman.sh
fi

if [ ! -f /etc/profile.d/sdkman.sh ] ; then
  _error_exit
fi

echo "${PROGNAME:+$PROGNAME: }INFO: installation complete." 1>&2
