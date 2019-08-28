#!/usr/bin/env bash

PROGNAME="setupjava9openjdk.sh"

echo "$PROGNAME: INFO: Java OpenJDK ${VER_MAJOR} version ${VER_FULL} setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# Remark: OpenJDK packages are at http://jdk.java.net

# #############################################################################
# Globals

VER_MAJOR=9
VER_FULL=9.0.1

export ALTERNATIVES_INDEX=9000
export GLOBAL_PROFILE=/etc/profile
export INSTALL_PATH=/usr/local
export JDK_EXTRACTED_PATH="$INSTALL_PATH/jdk-${VER_FULL}"
export JDK_PATH=$INSTALL_PATH/jdk-$VER_MAJOR
export PACKAGE_URL="http://download.java.net/java/GA/jdk${VER_MAJOR}/${VER_FULL}/binaries/openjdk-${VER_FULL}_linux-x64_bin.tar.gz"
export REQ_HEADER="Cookie: oraclelicense=accept-securebackup-cookie"

# #############################################################################
# Main

./setupjava-helper.sh
echo "$PROGNAME: COMPLETE: Java OpenJDK setup"
exit
