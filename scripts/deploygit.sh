#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

echo
echo "==> Setting up git..."

# #############################################################################
# Globals

PROGNAME=deploygit.sh
GITFILE="${1:-$HOME/.gitconfig}"

# #############################################################################
# Prep

# Install Git
which git >/dev/null 2>&1 \
  || (sudo apt update && sudo apt install -y 'git-core') \
  || (sudo yum install -y git)
which git >/dev/null 2>&1 || return 1

if ! which git >/dev/null 2>&1 ; then
  echo "$PROGNAME: SKIP: no git available" 1>&2
  exit
fi

# #############################################################################
# Configuration

while read key value ; do
  if [ -n "$key" ] && [ -n "$value" ] ; then
    git config -f "$GITFILE" --replace-all "$key" "$value"
  fi
done <<EOF
${MYEMAIL:+user.email $MYEMAIL}
${MYSIGN:+user.name $MYSIGN}
color.ui          auto
core.autocrlf     false
core.excludesfile $HOME/.gitignore_global
core.pager        less -F -X
credential.helper cache --timeout=36000
diff.submodule    log
push.default      simple
push.recurseSubmodules  check
sendpack.sideband false
status.submodulesummary 1
EOF

# #############################################################################
