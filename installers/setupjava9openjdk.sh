#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

# Rmk: Find OpenJDK packages at http://jdk.java.net

echo ${BASH_VERSION:+-e} '\n\n==> Installing openjdk9...' 1>&2

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
