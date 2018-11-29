#!/usr/bin/env bash

PROGNAME="code.sh"
VSCODE_CMD=code

echo
echo "################################################################################"
echo "Visual Studio Code editor setup; \$0='$0'; \$PWD='$PWD'"

# System installers
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"
export INSTPROG="$APTPROG"; which "$RPMPROG" >/dev/null 2>&1 && export INSTPROG="$RPMPROG"

# #############################################################################
# Install

if ! which ${VSCODE_CMD:-code} >/dev/null 2>&1 ; then
  if egrep -i -q -r 'debian|ubuntu' /etc/*release ; then
    # Add repo
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    # Install
    sudo $INSTPROG install -y apt-transport-https
    sudo $INSTPROG update
    sudo $INSTPROG install -y code # or code-insiders

  elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then
    # Add repo
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

    # Install
    if egrep -i -q -r 'fedora' /etc/*release ; then
      sudo dnf check-update
      sudo dnf install code
    else
      sudo yum check-update
      sudo yum install code
    fi
  fi
fi

# #############################################################################
# Set as default editor

if which xdg-mime >/dev/null 2>&1 ; then
  xdg-mime default code.desktop text/plain
fi

if which update-alternatives >/dev/null 2>&1 \
  && egrep -i -q -r 'debian|ubuntu' /etc/*release
then
  sudo update-alternatives --set editor /usr/bin/code
fi

# #############################################################################
# Conf - User settings

if ! (ps -ef | grep -v grep | grep -w -q code) ; then
  ${VSCODE_CMD:-code} >/dev/null 2>&1 & disown
  sleep 4
fi

if (uname -a | egrep -i -q "cygwin|mingw|msys|win32|windows") ; then
  CODE_USER_DIR="$(cygpath "${USERPROFILE}")/AppData/Roaming/Code/User"
elif [[ "$(uname -a)" = *[Ll]inux* ]] ; then
  CODE_USER_DIR="${HOME}/.config/Code/User"
fi

if [ ! -d "${CODE_USER_DIR}" ] ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP assets copy as there is no CODE_USER_DIR dir ('$CODE_USER_DIR')." 1>&2
else
  assets_dir=$(dirname "$(find "$PWD" -type f -name 'settings.json' | grep 'code')")
  if [ -z "$assets_dir" ] ; then
    echo "${PROGNAME:+$PROGNAME: }FATAL: No assets dir found ($assets_dir)." 1>&2
    exit 1
  fi
  assets="$(ls -1d ${assets_dir:-.}/*)"
  assets="$(echo "$assets" | sed "s/^/'/" | sed "s/$/'/" | tr '\n' ' ')" # prep for eval

  if ! eval cp -L -R "${assets}" "\"${CODE_USER_DIR}\""/ ; then
    echo "${PROGNAME:+$PROGNAME: }ERROR deploying VSCode files." 1>&2
  fi
fi

# #############################################################################
# Final sequence

echo "${PROGNAME:+$PROGNAME: }COMPLETE"
echo
