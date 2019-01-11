#!/usr/bin/env bash

PROGNAME="ipv6off.sh"

echo
echo "################################################################################"
echo "Disabling IPv6; \$0='$0'; \$PWD='$PWD'"

if sudo grep -r -q "GRUB_CMDLINE_LINUX_DEFAULT.*ipv6.disable=1" /etc/default/grub /etc/default/grub.d ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: IPv6 already disabled via grub default file." 1>&2
  exit
fi

# #############################################################################
# Globals

GRUB_FILE=/etc/default/grub
if [ -f /etc/default/grub.d/50_linuxmint.cfg ] ; then
  GRUB_FILE=/etc/default/grub.d/50_linuxmint.cfg
fi
unset GRUB_CMDLINE_FILE
GRUB_CMDLINE_FILE="$(grep -l -r "GRUB_CMDLINE_LINUX_DEFAULT=" /etc/default/grub /etc/default/grub.d)"
GRUB_FILE="${GRUB_CMDLINE_FILE:-${GRUB_FILE}}"

# #############################################################################
# Main

if ! grep -q "GRUB_CMDLINE_LINUX_DEFAULT=" "${GRUB_FILE}" ; then
  cat >> "${GRUB_FILE}" <<EOF
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
EOF
fi
sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 /' "${GRUB_FILE}"

# #############################################################################
# Final sequence

echo "${PROGNAME:+$PROGNAME: }COMPLETE"
echo
