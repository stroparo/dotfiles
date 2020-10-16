#!/usr/bin/env bash

PROGNAME="apps-ubuntu-ppa.sh"

if ! egrep -i -q -r 'ubuntu' /etc/*release ; then
  echo "$PROGNAME: SKIP: Ubuntu supported only"
  exit
fi

echo "$PROGNAME: INFO: Ubuntu PPA selects (compound)"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

source "${RUNR_DIR:-.}"/helpers/dsenforce.sh

# Disabled:
# aptinstallppa.sh "christian-boxdoerfer/fsearch-daily" "fsearch-trunk"
# aptinstallppa.sh "nextcloud-devs/client" "nextcloud-desktop"
# aptinstallppa.sh "nathan-renniewaldock/qdirstat" "qdirstat"
# aptinstallppa.sh "oguzhaninan/stacer" "stacer"
# aptinstallppa.sh "agornostal/ulauncher" "ulauncher"
# aptinstallppa.sh "nilarimogard/webupd8" "woeusb" # uninstallable version of a dependency...
# aptinstallppa.sh "zeal-developers/ppa" "zeal"

# xfce4-appfinder same feats, besides this does not work in Ubuntu 20.04:
# aptinstallppa.sh "gottcode/gcppa" "xfce4-whiskermenu-plugin"

echo "$PROGNAME: COMPLETE (compound)"
exit
