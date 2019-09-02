#!/usr/bin/env bash

PROGNAME="conf-pip.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: Python pip configuration started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################

mkdir -p "$HOME/.config/pip" 2>/dev/null

if [ -e "$HOME/.config/pip/pip.conf" ] \
  && ! cp -v "$HOME/.config/pip/pip.conf" "$HOME/.config/pip/pip.conf.$(date '+%Y%m%d-%OH%OM%OS')"
then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Could not backup '$HOME/.config/pip/pip.conf'." 1>&2
  exit 1
fi

touch "$HOME/.config/pip/pip.conf"
if ! grep -q "format=columns" "$HOME/.config/pip/pip.conf" ; then
  if [ -s "$HOME/.config/pip/pip.conf" ] ; then
    echo >> "$HOME/.config/pip/pip.conf"
  fi
  cat >> "$HOME/.config/pip/pip.conf" <<EOF
[list]
format=columns
EOF
fi

echo "$PROGNAME: COMPLETE"
exit
