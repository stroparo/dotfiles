#!/usr/bin/env bash

PROGNAME="setupdocker-compose.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: docker-compose setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

DC_VERSION='1.29.2'
DC_ALTN_URL="https://github.com/docker/compose/releases/download/${DC_VERSION}/docker-compose-`uname -s`-`uname -m`"

COMPLETION_FILE="${HOME}/.zsh/completion/_docker-compose"

SYSTEM_PYTHON="$(ls -1 /bin/python3 2>/dev/null || ls -1 /usr/bin/python3 2>/dev/null || echo python3)"

# #############################################################################
# Install

if grep -i -q 'id=arch' /etc/*release ; then

  sudo pacman -Sy docker-compose

else
  if which pip >/dev/null 2>&1 ; then
    if type pyenv >/dev/null 2>&1 ; then
      pyenv local system
    fi
    ${SYSTEM_PYTHON:-python3} -m pip install --user --upgrade docker-compose
  fi

  # Download docker-compose as a last resort if all else fails:
  if ! type docker-compose >/dev/null 2>&1 ; then
    sudo curl ${DLOPTEXTRA} -L "${DC_ALTN_URL}" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi
fi

# #############################################################################
# Verification

echo

# Update DC_VERSION in case the pip installation succeeded:
DC_VERSION="$(docker-compose --version | egrep -o 'version [0-9]+[.][0-9]+[.][0-9]+' | sed -e 's/version //')"
if [ $? -ne 0 ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: docker-compose is not available." 1>&2
  exit 1
fi

# #############################################################################
# Install completions

COMPLETION_URL="https://raw.githubusercontent.com/docker/compose/${DC_VERSION}/contrib/completion/zsh/_docker-compose"

if which zsh >/dev/null 2>&1 ; then

  mkdir -p "${HOME}"/.zsh/completion

  echo
  echo "${PROGNAME:+$PROGNAME: }INFO: Fetching '$COMPLETION_URL' into '$COMPLETION_FILE'"
  curl -L "$COMPLETION_URL" > "$COMPLETION_FILE"
  ls -l "$COMPLETION_FILE"

  if ! grep -F -q 'fpath=(~/.zsh/completion $fpath)' "${HOME}"/.zshrc ; then
    echo >> "${HOME}"/.zshrc
    echo 'fpath=(~/.zsh/completion $fpath)' >> "${HOME}"/.zshrc
  fi

  if ! grep -F -q 'autoload -Uz compinit && compinit -i' "${HOME}"/.zshrc ; then
    echo >> "${HOME}"/.zshrc
    echo 'autoload -Uz compinit && compinit -i' >> "${HOME}"/.zshrc
  fi
fi

# #############################################################################
# Final sequence

echo "${PROGNAME:+$PROGNAME: }COMPLETE: docker-compose setup"
exit
