#!/usr/bin/env bash

# Java JDK setup helper. This will also setup the alternatives system.

# Remark: OpenJDK packages are at http://jdk.java.net, older version packages at https://jdk.java.net/archive/

PROGNAME="setupjdk-helper.sh"

echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Checks

# if [ "$UID" != 0 ] ; then
#   echo "FATAL: Must run this as root" 1>&2
#   exit 1
# fi

if [ -z "${JDK_VER_MAJOR}" ] ; then echo "${PROGNAME:+$PROGNAME: }FATAL: Global 'JDK_VER_MAJOR' must be exported in caller." 1>&2 ; exit 1 ; fi
if [ -z "${ALTERNATIVES_INDEX}" ] ; then echo "${PROGNAME:+$PROGNAME: }FATAL: Global 'ALTERNATIVES_INDEX' must be exported in caller." 1>&2 ; exit 1 ; fi
if [ -z "${JDK_INSTALL_PATH}" ] ; then echo "${PROGNAME:+$PROGNAME: }FATAL: Global 'JDK_INSTALL_PATH' must be exported in caller." 1>&2 ; exit 1 ; fi
if [ -z "${JDK_EXTRACTED_PATH}" ] ; then echo "${PROGNAME:+$PROGNAME: }FATAL: Global 'JDK_EXTRACTED_PATH' must be exported in caller." 1>&2 ; exit 1 ; fi
if [ -z "${JDK_SHELL_PROFILE_PREFIX}" ] ; then echo "${PROGNAME:+$PROGNAME: }FATAL: Global 'JDK_SHELL_PROFILE_PREFIX' must be exported in caller." 1>&2 ; exit 1 ; fi
if [ -z "${JDK_SHELL_PROFILE}" ] ; then echo "${PROGNAME:+$PROGNAME: }FATAL: Global 'JDK_SHELL_PROFILE' must be exported in caller." 1>&2 ; exit 1 ; fi
if [ -z "${JDK_PACKAGE_URL}" ] ; then echo "${PROGNAME:+$PROGNAME: }FATAL: Global 'JDK_PACKAGE_URL' must be exported in caller." 1>&2 ; exit 1 ; fi
if [ -z "${JDK_PATH}" ] ; then echo "${PROGNAME:+$PROGNAME: }FATAL: Global 'JDK_PATH' must be exported in caller." 1>&2 ; exit 1 ; fi
if [ -z "${REQ_HEADER}" ] ; then echo "${PROGNAME:+$PROGNAME: }FATAL: Global 'REQ_HEADER' must be exported in caller." 1>&2 ; exit 1 ; fi

# #############################################################################
# Prep - Download & Extract

cd "${JDK_INSTALL_PATH}"

if [ ! -e "${JDK_PACKAGE_URL##*/}" ] \
&& ! sudo curl -k -LSf -o "${JDK_PACKAGE_URL##*/}" "${JDK_PACKAGE_URL}" \
&& ! sudo wget --no-cookies --no-check-certificate -O "${JDK_PACKAGE_URL##*/}" "${JDK_PACKAGE_URL}"
then
  echo "${PROGNAME:+$PROGNAME: }FATAL: There was an error downloading '${JDK_PACKAGE_URL}'." 1>&2
  exit 1
else
  echo "${PROGNAME:+$PROGNAME: }SKIP: Did not download package as it is already there." 1>&2
  sudo ls -l "${JDK_PACKAGE_URL##*/}"
fi

if [ ! -e "${JDK_EXTRACTED_PATH}/bin/java" ] ; then
  sudo tar xzvf "${JDK_PACKAGE_URL##*/}"
else
  echo "${PROGNAME:+$PROGNAME: }SKIP: Did not extract '${JDK_PACKAGE_URL##*/}' as there is '${JDK_EXTRACTED_PATH}/bin/java' already." 1>&2
  sudo ls -l "${JDK_INSTALL_PATH}/${JDK_PACKAGE_URL##*/}"
fi

# #############################################################################
# Post installation configuration

sudo rm -v "${JDK_PATH}" >/dev/null 2>&1
sudo ln -f -s -v "${JDK_EXTRACTED_PATH}" "${JDK_PATH}"
cd "${JDK_PATH}"/

if sudo which alternatives; then
  # Highest update-alternatives priority for a newer JDK version being installed:
  export ALTERNATIVES_INDEX=$((ALTERNATIVES_INDEX+JDK_VER_MAJOR))
  # Switch Java binaries defaults:
  sudo alternatives --install /usr/bin/java java "${JDK_PATH}"/bin/java "${ALTERNATIVES_INDEX}"
  sudo alternatives --config java
  sudo alternatives --install /usr/bin/jar jar "${JDK_PATH}"/bin/jar "${ALTERNATIVES_INDEX}"
  sudo alternatives --install /usr/bin/javac javac "${JDK_PATH}"/bin/javac "${ALTERNATIVES_INDEX}"
  sudo alternatives --set jar "${JDK_PATH}"/bin/jar
  sudo alternatives --set javac "${JDK_PATH}"/bin/javac
fi

# TODO update-alternatives add manpages slaves

# #############################################################################
echo "Updating profile '${JDK_SHELL_PROFILE}'..." 1>&2

for jdkprofile in $(sudo ls "${JDK_SHELL_PROFILE%/*}/${JDK_SHELL_PROFILE_PREFIX}"*.sh 2>/dev/null) ; do
  if [ "${jdkprofile}" != "${JDK_SHELL_PROFILE}" ] ; then
    sudo mv -v "${jdkprofile}" "${jdkprofile%.sh}.disabled"
  fi
done

  cat <<EOF | sudo tee "${JDK_SHELL_PROFILE}"
export JAVA_HOME="${JDK_PATH}"
export JRE_HOME="${JDK_PATH}/jre"
export PATH="\$PATH:\$JAVA_HOME/bin:\$JRE_HOME/bin"
EOF

# #############################################################################
# Verification

. "${JDK_SHELL_PROFILE}"
which java
java -version || exit "$?"

# #############################################################################
