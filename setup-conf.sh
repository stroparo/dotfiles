#!/usr/bin/env sh

cp -v ./conf/exrc ~/.exrc
cp -v ./conf/vimrc ~/.vimrc
cp -v ./conf/sshconfig ~/.ssh/config

# Sublime Text:
SUBL_WIN='C:\Users\cr391577\AppData\Roaming\Sublime Text 3'
if [[ "$(uname -a)" = *[Cc]ygwin* ]] \
  && [ -d "`cygpath "${SUBL_WIN}"`" ]
then
  SUBL_USER="${SUBL_WIN}/Packages/User"
else
  echo "Sublime path:"
  read SUBL_PATH
  SUBL_USER="${SUBL_PATH}/Data/Packages/User"
fi

mkdir -p "${SUBL_USER}"
cp -v ./conf/sublime3/* "${SUBL_USER}"/
