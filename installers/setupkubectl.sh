#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

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
# Checks

if !(uname -a | grep -i -q linux) ; then
  echo "$PROGNAME: FATAL: Only Linux is supported." 1>&2
  exit 1
fi

# Check for idempotency
if type kubectl >/dev/null 2>&1 ; then
  echo "$PROGNAME: SKIP: Already installed." 1>&2
  exit
fi

# #############################################################################
# Prep

cd "$WORK_DIR"

# #############################################################################
# Main

echo ${BASH_VERSION:+-e} '\n\n==> Installing kubectl...' 1>&2

if ${FORCE:-false} || [ ! -e "${INSTALL_DIR}"/kubectl ] ; then
  "$DLPROG" ${DLOPT} ${DLOUT} kubectl "$KUBE_URL"
  chmod -v 755 kubectl
  sudo chown -v 0:0 kubectl
  sudo mv -v kubectl "${INSTALL_DIR}"/ || exit $?
  echo
  ls -l "${INSTALL_DIR}"/kubectl
  kubectl version --client
else
  echo "$PROGNAME: SKIP: kubectl already installed (call this again with -f to force)." 1>&2
fi

# #############################################################################
