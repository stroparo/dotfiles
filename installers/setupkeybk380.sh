#!/usr/bin/env bash

PROGNAME='setupkeybk380.sh'

# #############################################################################
# Checks

if ! (uname -a | grep -i -q linux) ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: Only Linux is supported."
  exit
fi

# #############################################################################
# Globals

K380_GIT=https://gitlab.com/stroparo/k380-function-keys-conf.git
K380_PATH=/srv/k380-function-keys-conf

# #############################################################################
# Main

sudo mkdir /srv 2>/dev/null
if [ ! -d /srv ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: No /srv dir, nor could this script create it." 1>&2
  exit 1
fi

sudo git clone "$K380_GIT" "$K380_PATH" \
  && cd "$K380_PATH" \
  && [ "$PWD" = "$K380_PATH" ] \
  && sudo ./build.sh \
  && set -x \
  && sudo cp /srv/k380-function-keys-conf/80-k380.rules /etc/udev/rules.d/ \
  && set +x \
  && sudo udevadm control -R \
  && ls -l /etc/udev/rules.d/80-k380.rules
if [ $? -eq 0 ] ; then
  echo "${PROGNAME:+$PROGNAME: }INFO: Logitech K380 keyboard configured successfully."
else
  echo "${PROGNAME:+$PROGNAME: }FATAL: Error configuring the Logitech K380 keyboard." 1>&2
  exit 1
fi
