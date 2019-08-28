#!/usr/bin/env bash

PROGNAME="setupkubectl.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if type kubectl >/dev/null 2>&1 ; then echo "$PROGNAME: SKIP: Already installed." ; exit ; fi

echo "$PROGNAME: INFO: Kubernetes kubectl setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

PROGNAME="setupkubectl.sh"

FORCE=false
INSTALL_DIR="/usr/local/bin"
KUBE_URL="https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl"
WORK_DIR="/tmp"

# Setup the downloader program (curl/wget)
if which curl >/dev/null 2>&1 ; then
  export DLPROG=curl
  export DLOPT='-LSfs'
  export DLOUT='-o'
elif which wget >/dev/null 2>&1 ; then
  export DLPROG=wget
  export DLOPT=''
  export DLOUT='-O'
else
  echo "FATAL: curl and wget missing" 1>&2
  exit 1
fi

# Options:
OPTIND=1
while getopts ':f' option ; do
  case "${option}" in
    f) FORCE=true"${OPTARG}";;
    h) echo "$USAGE"; exit;;
  esac
done
shift "$((OPTIND-1))"

# #############################################################################
# Prep

cd "$WORK_DIR"

# #############################################################################
# Main

if ${FORCE:-false} || [ ! -e "${INSTALL_DIR}"/kubectl ] ; then
  "$DLPROG" ${DLOPT} ${DLOUT} kubectl "$KUBE_URL"
  chmod -v 755 kubectl
  sudo chown -v 0:0 kubectl
  sudo mv -v kubectl "${INSTALL_DIR}"/ || exit $?
  echo
  ls -l "${INSTALL_DIR}"/kubectl
  kubectl version --client
else
  echo "$PROGNAME: SKIP: kubectl already installed (call this again with -f to force)."
  exit
fi

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE: Kubernetes kubectl setup"
exit
