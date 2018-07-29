#!/usr/bin/env bash

echo
echo "################################################################################"
echo "Setup cfssl..."

# #############################################################################
# Checks

if !(uname -a | grep -i -q linux) ; then
  echo "SKIP: Only Linux is supported." 1>&2
  exit
fi

if type cfssl >/dev/null 2>&1 ; then
  echo "SKIP: Already installed." 1>&2
  exit
fi

# #############################################################################
# Globals

INSTALL_DIR=/usr/local/bin
CFSSL_SITE=https://pkg.cfssl.org/
CFSSL_VER=R1.2

CFSSL_URL="${CFSSL_SITE%/}/${CFSSL_VER}/cfssl_linux-amd64"
CFSSLJSON_URL="${CFSSL_SITE%/}/${CFSSL_VER}/cfssljson_linux-amd64"

# #############################################################################
# Prep

cd /tmp
wget "$CFSSL_URL" "$CFSSLJSON_URL"
chmod -v 755 cfssl*
sudo chown -v 0:0 cfssl*

# #############################################################################
# Install

sudo mv -v cfssl_linux-amd64 "${INSTALL_DIR}"/cfssl
sudo mv -v cfssljson_linux-amd64 "${INSTALL_DIR}"/cfssljson

# #############################################################################
# Verification

echo
ls -l "${INSTALL_DIR}"/cfssl*
which cfssl cfssljson

# #############################################################################
# Finish

echo "FINISHED cfssl setup"
echo
