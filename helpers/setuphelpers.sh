# Helpers

_exec () {
  typeset result
  if ! "$@" ; then
    result=$?
    echo "FATAL: There was an error executing" "$@" 1>&2
    exit ${result:-1}
  fi
}

_is_gui_env () {
  (which startx || which firefox || which google-chrome || which subl) >/dev/null 2>&1
}
