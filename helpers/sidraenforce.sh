if [ ! -e "${ZDRA_HOME:-$HOME/.zdra}/zdra.sh" ] ; then
  "${RUNR_DIR:-.}"/installers/setupsidra.sh
fi
if [ ! -e "${ZDRA_HOME:-$HOME/.zdra}/zdra.sh" ] ; then
  echo "sidraenforce: ${PROGNAME:+$PROGNAME: }FATAL: Missing dependency: shell scripting library." 1>&2
  echo
  exit 1
fi
if ! type zdraversion >/dev/null 2>&1 ; then
  . "${ZDRA_HOME:-$HOME/.zdra}/zdra.sh"
  if ! type zdraversion >/dev/null 2>&1 ; then
    echo "sidraenforce: ${PROGNAME:+$PROGNAME: }FATAL: Loading shell scripting library." 1>&2
    echo
    exit 1
  fi
fi
