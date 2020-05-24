#!/usr/bin/env bash

PROGNAME="apps-ubuntu-ppa.sh"

if ! egrep -i -q -r 'ubuntu' /etc/*release ; then
  echo "$PROGNAME: SKIP: Ubuntu supported only"
  exit
fi

echo "$PROGNAME: INFO: Ubuntu PPA selects (compound)"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

bash "${RUNR_DIR:-.}"/installers-ubuntu/setupfsearch.sh
bash "${RUNR_DIR:-.}"/installers-ubuntu/setupnextcloud.sh
bash "${RUNR_DIR:-.}"/installers-ubuntu/setupulauncher.sh
bash "${RUNR_DIR:-.}"/installers-ubuntu/setupwoeusb.sh
bash "${RUNR_DIR:-.}"/installers-ubuntu/setupyppamanager.sh

# Disabled as not available in current Ubuntu release:
# bash "${RUNR_DIR:-.}"/installers-ubuntu/setupqdirstat.sh
# bash "${RUNR_DIR:-.}"/installers-ubuntu/setupstacer.sh
# bash "${RUNR_DIR:-.}"/installers-ubuntu/setupzeal.sh

echo "$PROGNAME: COMPLETE (compound)"
exit
