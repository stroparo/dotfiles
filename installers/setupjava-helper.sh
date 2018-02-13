#!/usr/bin/env bash

# Daily Shells Extras extensions
# More instructions and licensing at:
# https://github.com/stroparo/ds-extras

# Rmk:
# This script must have all the uppercase variables
# in its code exported prior to being called.

# #############################################################################
# Checks

if [ $UID != 0 ] ; then
  echo "FATAL: Must run this as root" 1>&2
  exit 1
fi

# #############################################################################
# Prep

cd "${INSTALL_PATH}"

wget \
  --no-cookies \
  --no-check-certificate \
  --header "$REQ_HEADER" \
  -O "${PACKAGE_URL##*/}" \
  "$PACKAGE_URL"

# #############################################################################
# Install

tar xzf "${PACKAGE_URL##*/}"

# #############################################################################
# Post installation configuration

ln -f -s "${JDK_EXTRACTED_PATH}" "${JDK_PATH}"
cd "${JDK_PATH}"/

# Switch Java binaries defaults:
alternatives --install /usr/bin/java java "${JDK_PATH}"/bin/java "${ALTERNATIVES_INDEX}"
alternatives --config java
alternatives --install /usr/bin/jar jar "${JDK_PATH}"/bin/jar "${ALTERNATIVES_INDEX}"
alternatives --install /usr/bin/javac javac "${JDK_PATH}"/bin/javac "${ALTERNATIVES_INDEX}"
alternatives --set jar "${JDK_PATH}"/bin/jar
alternatives --set javac "${JDK_PATH}"/bin/javac

# TODO update-alternatives add manpages slaves

# Update profile:
echo "Updating profile..." 1>&2

  if ! grep -q "${JDK_PATH}" "${GLOBAL_PROFILE}" ; then

    cp -v "${GLOBAL_PROFILE}" "${GLOBAL_PROFILE}-bak-$(date +'%Y%m%d-%OH%OM%OS')"

    cat >> "${GLOBAL_PROFILE}" <<EOF
export JAVA_HOME=${JDK_PATH}
export JRE_HOME=${JDK_PATH}/jre
export PATH=\$PATH:\$JAVA_HOME/bin:\$JRE_HOME/bin
EOF
  fi

# #############################################################################
# Verification

. ${GLOBAL_PROFILE}
java -version || exit "$?"

# #############################################################################
