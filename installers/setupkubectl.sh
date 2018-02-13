#!/usr/bin/env bash

# Daily Shells Extras extensions
# More instructions and licensing at:
# https://github.com/stroparo/ds-extras

echo ${BASH_VERSION:+-e} '\n\n==> Installing kubectl...' 1>&2

# #############################################################################
# Checks

if !(uname -a | grep -i -q linux) ; then
  echo "FATAL: Only Linux is supported." 1>&2
  exit 1
fi

# Check for idempotency
if type kubectl >/dev/null 2>&1 ; then
  echo "SKIP: Already installed." 1>&2
  exit
fi

# #############################################################################
# Globals

INSTALL_DIR=/usr/local/bin
KUBE_URL=https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl

# #############################################################################
# Prep

cd /tmp

# #############################################################################
# Main

wget "$KUBE_URL"
chmod -v 755 kubectl
sudo chown -v 0:0 kubectl
sudo mv -v kubectl "${INSTALL_DIR}"/
echo
ls -l "${INSTALL_DIR}"/kubectl
kubectl version --client

# #############################################################################
