#!/usr/bin/env bash

# Daily Shells Stroparo extensions

# #############################################################################
# Checks

if ! (uname -a | grep -i -q linux) ; then
  echo "SKIP: Not on Linux." 1>&2
  exit
fi

# #############################################################################
# Globals

K380_GIT=https://gitlab.com/stroparo/k380-function-keys-conf.git
K380_PATH=/srv/k380-function-keys-conf

# #############################################################################
# Main

echo ${BASH_VERSION:+-e} "\n\n==> Started '$0'"

sudo git clone "$K380_GIT" "$K380_PATH" \
  && cd "$K380_PATH" \
  && [ "$PWD" = "$K380_PATH" ] \
  && sudo ./build.sh \
  && set -x \
  && sudo cp /srv/k380-function-keys-conf/80-k380.rules /etc/udev/rules.d/ \
  && set +x \
  && sudo udevadm control -R \
  && ls -l /etc/udev/rules.d/80-k380.rules \
  && echo "OK: built successfully"
