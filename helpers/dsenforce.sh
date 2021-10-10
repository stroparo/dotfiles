if [ ! -e "${DS_HOME:-$HOME/.ds}/ds.sh" ] ; then
  "${RUNR_DIR:-.}"/installers/setupds.sh
fi
if [ ! -e "${DS_HOME:-$HOME/.ds}/ds.sh" ] ; then
  echo "nrsenforce: ${PROGNAME:+$PROGNAME: }FATAL: Missing dependency: shell scripting library." 1>&2
  echo
  exit 1
fi
if ! type dsversion >/dev/null 2>&1 ; then
  . "${DS_HOME:-$HOME/.ds}/ds.sh"
  if ! type dsversion >/dev/null 2>&1 ; then
    echo "nrsenforce: ${PROGNAME:+$PROGNAME: }FATAL: Loading shell scripting library." 1>&2
    echo
    exit 1
  fi
fi
