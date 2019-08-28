#!/usr/bin/env bash

PROGNAME="setupdocker-compose.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: docker-compose setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

COMPLETION_FILE="${HOME}/.zsh/completion/_docker-compose"
COMPLETION_URL="https://raw.githubusercontent.com/docker/compose/1.18.0/contrib/completion/zsh/_docker-compose"

# #############################################################################
# Install

if type docker-compose >/dev/null 2>&1 ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: Already installed." 1>&2
elif which pip >/dev/null 2>&1 ; then
  pip install --user docker-compose
fi

# Download docker-compose as a last resort if all else fails:
if ! type docker-compose >/dev/null 2>&1 ; then
  sudo curl ${DLOPTEXTRA} -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

# #############################################################################
# Verification

echo
if ! docker-compose --version ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: docker-compose is not available." 1>&2
  exit 1
fi

# #############################################################################
# Install completions

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
