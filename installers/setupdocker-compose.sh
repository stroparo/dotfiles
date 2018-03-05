#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

echo ${BASH_VERSION:+-e} '\n\n==> Installing docker-compose...' 1>&2

# #############################################################################
# Globals

COMPLETION_FILE="${HOME}/.zsh/completion/_docker-compose"
COMPLETION_URL="https://raw.githubusercontent.com/docker/compose/1.18.0/contrib/completion/zsh/_docker-compose"

# #############################################################################
# Checks

if !(uname -a | grep -i -q linux) ; then
  echo "FATAL: Only Linux is supported." 1>&2
  exit 1
fi

# Check for idempotency
if type docker-compose >/dev/null 2>&1 ; then
  INSTALLED=true
fi

# #############################################################################
# Install

if ${INSTALLED:-false} ; then
  echo "SKIP: Already installed." 1>&2
elif which pip >/dev/null 2>&1 ; then
  pip install --user docker-compose
fi

# Download docker-compose as a last resort if all else fails:
if ! type docker-compose >/dev/null 2>&1 ; then
  sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

# #############################################################################
# Verification

echo
if ! docker-compose --version ; then
  echo "FATAL: docker-compose is not available." 1>&2
  exit 1
fi

# #############################################################################
# Install completions

if which zsh >/dev/null 2>&1 ; then

  mkdir -p ~/.zsh/completion

  echo
  echo "Fetching '$COMPLETION_URL' into '$COMPLETION_FILE'"
  curl -L "$COMPLETION_URL" > "$COMPLETION_FILE"
  ls -l "$COMPLETION_FILE"

  if ! grep -F -q 'fpath=(~/.zsh/completion $fpath)' ~/.zshrc ; then
    echo >> ~/.zshrc
    echo 'fpath=(~/.zsh/completion $fpath)' >> ~/.zshrc
  fi

  if ! grep -F -q 'autoload -Uz compinit && compinit -i' ~/.zshrc ; then
    echo >> ~/.zshrc
    echo 'autoload -Uz compinit && compinit -i' >> ~/.zshrc
  fi
fi

# #############################################################################
