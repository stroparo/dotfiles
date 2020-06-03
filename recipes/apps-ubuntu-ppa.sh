#!/usr/bin/env bash

PROGNAME="apps-ubuntu-ppa.sh"

if ! egrep -i -q -r 'ubuntu' /etc/*release ; then
  echo "$PROGNAME: SKIP: Ubuntu supported only"
  exit
fi

echo "$PROGNAME: INFO: Ubuntu PPA selects (compound)"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

source "${RUNR_DIR:-.}"/helpers/dsenforce.sh

aptinstallppa.sh "christian-boxdoerfer/fsearch-daily" "fsearch-trunk"
aptinstallppa.sh "nextcloud-devs/client" "nextcloud-client"
aptinstallppa.sh "agornostal/ulauncher" "ulauncher"
aptinstallppa.sh "webupd8team/y-ppa-manager" "y-ppa-manager"

# Disabled as not available in current Ubuntu release:
# aptinstallppa.sh "nathan-renniewaldock/qdirstat" "qdirstat"
# aptinstallppa.sh "oguzhaninan/stacer" "stacer"
# aptinstallppa.sh "nilarimogard/webupd8" "woeusb" # uninstallable version of a dependency...
# aptinstallppa.sh "zeal-developers/ppa" "zeal"

echo "$PROGNAME: COMPLETE (compound)"
exit
