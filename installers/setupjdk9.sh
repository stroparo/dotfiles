#!/usr/bin/env bash

# Remark: OpenJDK packages are at http://jdk.java.net, older version packages at https://jdk.java.net/archive/

PROGNAME="setupjdk9.sh"

export JDK_VER_MAJOR=9
export JDK_VER_FULL=9.0.4

export ALTERNATIVES_INDEX=9000
export JDK_INSTALL_PATH=/usr/local
export JDK_EXTRACTED_PATH="${JDK_INSTALL_PATH}/jdk-${JDK_VER_FULL}"
export JDK_SHELL_PROFILE_PREFIX="jdk-"
export JDK_SHELL_PROFILE="/etc/profile.d/${JDK_SHELL_PROFILE_PREFIX}${JDK_VER_MAJOR}.sh"
export JDK_PACKAGE_URL="https://download.java.net/java/GA/jdk${JDK_VER_MAJOR}/${JDK_VER_FULL}/binaries/openjdk-${JDK_VER_FULL}_linux-x64_bin.tar.gz"
export JDK_PATH="${JDK_INSTALL_PATH}/jdk-${JDK_VER_MAJOR}"
export REQ_HEADER="Cookie: oraclelicense=accept-securebackup-cookie"

# #############################################################################
# Main

bash "${RUNR_DIR:-$PWD}"/installers/setupjdk-helper.sh
echo "$PROGNAME: COMPLETE: Java OpenJDK setup"
exit
