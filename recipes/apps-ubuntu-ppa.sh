#!/usr/bin/env bash

PROGNAME="apps-ubuntu-ppa.sh"

if ! egrep -i -q -r 'ubuntu' /etc/*release ; then
  echo "$PROGNAME: SKIP: Ubuntu supported only"
  exit
fi


echo "$PROGNAME: INFO: Ubuntu PPA selects (compound)"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

source "${RUNR_DIR:-.}"/helpers/sidraenforce.sh


aptinstall.sh -r "bashtop-monitor/bashtop" bashtop
aptinstall.sh -r 'font-manager/staging' font-manager
aptinstall.sh -r "christian-boxdoerfer/fsearch-daily" fsearch-trunk
aptinstall.sh -r "agornostal/ulauncher" ulauncher

# Disabled:
# aptinstall.sh -r "phoerious/keepassxc" keepassxc  # Installing 2.4.3 instead of 2.6.1 in Ubuntu 20.04
# aptinstall.sh -r "nextcloud-devs/client" nextcloud-desktop
# aptinstall.sh -r "nilarimogard/webupd8" woeusb  # Uninstallable version of a dependency...
# aptinstall.sh -r "zeal-developers/ppa" zeal

# xfce4-appfinder has same feats, and besides this does not work in Ubuntu 20.04:
# aptinstall.sh -r "gottcode/gcppa" xfce4-whiskermenu-plugin


echo
echo
echo "$PROGNAME: COMPLETE (compound)"
exit
