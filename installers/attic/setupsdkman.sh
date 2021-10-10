#!/usr/bin/env bash

PROGNAME="setupsdkman.sh"

echo "$PROGNAME: INFO: started sdkman setup"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

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
  echo "${PROGNAME:+$PROGNAME: }FATAL: could not install the 'zip' package." 1>&2
  exit 1
fi

# #############################################################################
# Main

if ! curl -s "https://get.sdkman.io" | bash ; then
  _error_exit
fi

_setup_sdkman_profile

# #############################################################################
# Final sequence

echo "${PROGNAME}: COMPLETE: sdkman setup" 1>&2
exit
