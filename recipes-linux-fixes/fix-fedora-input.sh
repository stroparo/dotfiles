#!/usr/bin/env bash

PROGNAME=fix-fedora-input.sh
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

COMPOSE_FILE="/usr/share/X11/locale/en_US.UTF-8/Compose"

# #############################################################################
# Prep

if ! egrep -i -q -r 'fedora' /etc/*release ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: this is a Fedora Linux routine." 1>&2
  exit
elif ! which dnf >/dev/null 2>&1 ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: dnf command must be available." 1>&2
  exit
else
  echo "==> ${PROGNAME:+$PROGNAME: } fixing Fedora input." 1>&2
fi

if [ ! -s "$COMPOSE_FILE" ]; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: system compose file with no contents." 1>&2
  exit 1
fi

# #############################################################################
echo
echo "==> ${PROGNAME:+$PROGNAME: }Writing new .XCompose at the home dir in '$HOME/.XCompose'..."

sed -e 's,\xc4\x86,\xc3\x87,g' \
  -e 's,\xc4\x87,\xc3\xa7,g' \
  < "$COMPOSE_FILE" \
  >"$HOME/.XCompose"

# #############################################################################
echo
echo "==> ${PROGNAME:+$PROGNAME: }Installing im-chooser..."

sudo dnf install im-chooser

# #############################################################################
echo
echo "==> ${PROGNAME:+$PROGNAME: }Setting up GNOME..."

gsettings set 'org.gnome.settings-daemon.plugins.keyboard' active false

# #############################################################################
echo
echo "==> ${PROGNAME:+$PROGNAME: }Launching im-chooser."

echo 'Please choose "Use X Compose table" and then logout...'

command im-chooser >/dev/null 2>&1

# #############################################################################
echo
echo "==> ${PROGNAME:+$PROGNAME: }Please logout and back in for the changes to take effect."
