#!/usr/bin/env bash

PROGNAME="disable-ipv6.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if sudo grep -r -q "GRUB_CMDLINE_LINUX_DEFAULT.*ipv6.disable=1" /etc/default/grub /etc/default/grub.d 2>/dev/null ; then
  echo "$PROGNAME: SKIP: IPv6 already disabled via grub default file."
  exit
fi

echo "$PROGNAME: INFO: started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

GRUB_FILE=/etc/default/grub
if [ -f /etc/default/grub.d/50_linuxmint.cfg ] ; then
  GRUB_FILE=/etc/default/grub.d/50_linuxmint.cfg
fi
unset GRUB_CMDLINE_FILE
GRUB_CMDLINE_FILE="$(grep -l -r "GRUB_CMDLINE_LINUX_DEFAULT=" /etc/default/grub /etc/default/grub.d 2>/dev/null)"
GRUB_FILE="${GRUB_CMDLINE_FILE:-${GRUB_FILE}}"

# #############################################################################

if ! grep -q "GRUB_CMDLINE_LINUX_DEFAULT=" "${GRUB_FILE}" ; then
  echo "${PROGNAME:+$PROGNAME: }INFO: Updating grub file '${GRUB_FILE}' with:"
  sudo tee -a "${GRUB_FILE}" <<EOF
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
EOF
fi

echo "${PROGNAME:+$PROGNAME: }INFO: Updating grub file '${GRUB_FILE}' default Linux command with 'ipv6.disable=1'"
sudo sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 /' "${GRUB_FILE}"

sudo update-grub

echo "$PROGNAME: COMPLETE"
exit
