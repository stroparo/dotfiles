#!/usr/bin/env bash

PROGNAME="setupvim.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: Vim compiling from source started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# Supports Lua, Perl Python, Ruby

# #############################################################################
# Remarks

# Interactive mode trigered with -i option.
# Errors may generate prompts even during a non-interactive run.

# Configure command based on:
# https://gist.github.com/odiumediae/3b22d09b62e9acb7788baf6fdbb77cf8

# #############################################################################
# Globals

USAGE="[-h] [-i] [-p prefix_path] [lua] [perl] [python|python2] [ruby]"

export INTERACTIVE=false

export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf

# Disable pyenv in PATH:
export PATH="$(echo "$PATH" | tr : \\n | grep -v pyenv | tr \\n :)"

unset CONF_ARGS_LUA
unset CONF_ARGS_PERL
unset CONF_ARGS_PYTHON
unset CONF_ARGS_RUBY

FORCE="false"
NO_PYTHON="false"
BUILD_NAME='stroparo'

# #############################################################################
# Routines

_user_confirm () {
  # Info: Ask a question and yield success if user responded [yY]*

  typeset confirm
  typeset result=1

  echo ${BASH_VERSION:+-e} "$@" "[y/N] \c"
  read confirm
  if [[ $confirm = [yY]* ]] ; then return 0 ; fi
  return 1
}

# #############################################################################
# Dynamic globals

# Options:
OPTIND=1
while getopts ':fhip:' option ; do
  case "${option}" in
    f) FORCE="true";;
    h) echo "$USAGE"; exit;;
    i) export INTERACTIVE="true";;
    p) export PREFIX="${OPTARG}";;
  esac
done
shift "$((OPTIND-1))"

# #############################################################################
# Check if already compiled and prompt

if ! ${FORCE:-false} && (vim --version | grep -q "${BUILD_NAME}") ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: VIM '${BUILD_NAME}' build already compiled."
  echo "${PROGNAME:+$PROGNAME: }TIP: Run '\"${PROGNAME}\" -f' to force a new compilation."
  exit
fi

# #############################################################################
# Prompt for specific support

for arg in "$@" ; do
  case $arg in
    lua)      DO_LUA=true;;
    perl)     DO_PERL=true;;
    nopython) NO_PYTHON=true;;
    python2)  DO_PYTHON2=true;;
    ruby)     DO_RUBY=true;;
  esac
done

# #############################################################################
# Prep dependencies

echo ${BASH_VERSION:+-e} "\n${PROGNAME:+$PROGNAME: }INFO: Dependencies custom scripts...\n"

if ${DO_LUA:-false} ; then "${RUNR_DIR:-.}/installers/setuplua.sh" ; fi
if ${DO_PERL:-false} ; then "${RUNR_DIR:-.}/installers/setupperl.sh" ; fi
if ! ${NO_PYTHON:-false} ; then "${RUNR_DIR:-.}/installers/setuppython.sh" "system" ; fi

echo ${BASH_VERSION:+-e} "\n${PROGNAME:+$PROGNAME: }INFO: Dependencies from OS repos (deb, rpm)...\n"

if egrep -i -q -r 'debian|ubuntu' /etc/*release ; then

  # Utilities:
  sudo $APTPROG install -y exuberant-ctags
  which curl >/dev/null 2>&1 || sudo $APTPROG install -y curl
  which gcc >/dev/null 2>&1 || sudo $APTPROG install -y gcc
  which git >/dev/null 2>&1 || sudo $APTPROG install -y git-core
  which make >/dev/null 2>&1 || sudo $APTPROG install -y make

  # Libraries:
  sudo $APTPROG install -y libatk1.0-dev
  sudo $APTPROG install -y libncurses5-dev
  sudo $APTPROG install -y libx11-dev
  sudo $APTPROG install -y libxpm-dev
  sudo $APTPROG install -y libxt-dev

  # checkinstall will allow for vim to be uninstalled via `dpkg -r vim`
  sudo $APTPROG install -y checkinstall

elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then

  # Utilities:
  sudo $RPMPROG install -q -y --enablerepo=epel ctags
  which cmake >/dev/null 2>&1 || sudo $RPMPROG install -q -y --enablerepo=epel cmake
  which curl >/dev/null 2>&1 || sudo $RPMPROG install -q -y --enablerepo=epel curl
  which gcc >/dev/null 2>&1 || sudo $RPMPROG install -q -y --enablerepo=epel gcc
  which git >/dev/null 2>&1 || sudo $RPMPROG install -q -y --enablerepo=epel git
  sudo $RPMPROG -y groupinstall 'Development Tools'

  # Libraries:
  sudo $RPMPROG install -q -y --enablerepo=epel ncurses ncurses-devel
fi

# #############################################################################

_prep_lua () {
  if [ "$DO_LUA" = y ] || [ "$DO_LUA" = true ] ; then
    DO_LUA=true
    CONF_ARGS_LUA="\
      --enable-luainterp \
      --with-luajit"
  else
    DO_LUA=false
    return
  fi
}

# #############################################################################

_prep_perl () {
  if [ "$DO_PERL" = y ] || [ "$DO_PERL" = true ] ; then
    DO_PERL=true
    CONF_ARGS_PERL="--enable-perlinterp=dynamic"
  else
    DO_PERL=false
    return
  fi
}

# #############################################################################

_prep_python2 () {
  if ${NO_PYTHON:-false} ; then
    DO_PYTHON2=false
    return
  fi

  if [ "$DO_PYTHON2" = y ] || [ "$DO_PYTHON2" = true ] ; then

    DO_PYTHON2=true

    if ${INTERACTIVE:-false} ; then
      echo
      echo 'Python 2 config dir...'
      echo
      echo 'Examples in Fedora 27:'
      echo '/usr/lib/python2.7/config'
      echo '/usr/lib64/python2.7/config'
      echo
      echo 'Enter the Python 2 config dir:'
      read PYTHON2_CONFIG_DIR
    elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then
      PYTHON2_CONFIG_DIR="/usr/lib64/python2.7/config"
    elif egrep -i -q -r 'ubuntu' /etc/*release ; then
      PYTHON2_CONFIG_DIR="/usr/lib/python2.7/config-x86_64-linux-gnu"
    else
      DO_PYTHON2=false
      return
    fi

    if [ ! -d "${PYTHON2_CONFIG_DIR}" ] ; then
      DO_PYTHON2=false
    fi

    if ${DO_PYTHON2:-false} ; then
      CONF_ARGS_PYTHON2="\
        --enable-pythoninterp \
        --with-python-config-dir=\"$PYTHON2_CONFIG_DIR\""
    fi
  else
    DO_PYTHON2=false
    return
  fi
}

# #############################################################################

_prep_python3 () {
  DO_PYTHON3=true

  if ${NO_PYTHON:-false} ; then
    DO_PYTHON3=false
    return
  fi

  if ${INTERACTIVE:-false} ; then
    echo
    echo 'Python 3 config dir...'
    echo
    echo 'Examples in Fedora 27:'
    echo '/usr/lib/python3.4/config-3.4m-x86_64-linux-gnu'
    echo '/usr/lib64/python3.4/config-3.4m-x86_64-linux-gnu'
    echo
    echo 'Enter the Python 3 config dir:'
    read PYTHON3_CONFIG_DIR
  elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then
    PYTHON3_CONFIG_DIR="/usr/lib64/python3.4/config-3.4m-x86_64-linux-gnu"
  elif egrep -i -q -r 'ubuntu' /etc/*release ; then
    PYTHON3_CONFIG_DIR="/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu"
  else
    DO_PYTHON3=false
    return
  fi

  if [ ! -d "${PYTHON3_CONFIG_DIR}" ] ; then
    DO_PYTHON3=false
  fi

  if ${DO_PYTHON3:-false} ; then
    CONF_ARGS_PYTHON3="\
      --enable-python3interp \
      --with-python3-config-dir=\"$PYTHON3_CONFIG_DIR\""
  fi
}

# #############################################################################

_prep_ruby () {
  if [ "$DO_RUBY" = y ] || [ "$DO_RUBY" = true ] ; then

    DO_RUBY=true

    if ${INTERACTIVE:-false} ; then
      echo 'Enter Ruby binary path: '
      echo '(E.g.: /usr/local/bin/ruby)'
      read RUBY_BINARY_PATH
    elif which ruby >/dev/null 2>&1 ; then
      RUBY_BINARY_PATH="$(which ruby)"
    else
      DO_RUBY=false
      return
    fi

    CONF_ARGS_RUBY="\
      --enable-rubyinterp=dynamic \
      --with-ruby-command=\"$RUBY_BINARY_PATH\""
  else
    DO_RUBY=false
    return
  fi
}

# #############################################################################
# Main installation
# Additional arguments are handed over to the configure call

_prep_lua
_prep_perl
_prep_python2
_prep_python3
_prep_ruby

VIM_PKG="${HOME}/vim.zip"
VIM_PKG_DIR="$(dirname "${VIM_PKG}")"
VIM_SETUP_DIR="${VIM_PKG_DIR}/vim-master"

if [ ! -e "${VIM_PKG}" ] ; then
  curl ${DLOPTEXTRA} -LSfs https://github.com/vim/vim/archive/master.zip > "${VIM_PKG}"
fi

if ! unzip -o "${VIM_PKG}" -d "${VIM_PKG_DIR}" ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: unzipping '${VIM_PKG}'." 1>&2
  exit 1
fi

cd "${VIM_SETUP_DIR}/src" \
  && [ "${PWD}" = "${VIM_SETUP_DIR}/src" ] \
  && make distclean

cd "${VIM_SETUP_DIR}"
[ "${PWD}" = "${VIM_SETUP_DIR}" ] || exit $?

# Other configure options:
  # --enable-gui=auto \
  # --with-x \
eval ./configure \
  "$@" \
  ${PREFIX:+--prefix="$PREFIX"} \
  ${CONF_ARGS_LUA} \
  ${CONF_ARGS_PERL} \
  ${CONF_ARGS_PYTHON2} \
  ${CONF_ARGS_PYTHON3} \
  ${CONF_ARGS_RUBY} \
  --disable-gui \
  --enable-multibyte \
  --enable-cscope \
  --with-features=huge \
  --enable-fontset \
  --enable-largefile \
  --disable-netbeans \
  --with-compiledby="${BUILD_NAME}" \
  --enable-fail-if-missing \
  && make

if [ "$?" -eq 0 ] \
  && ! ("${INTERACTIVE:-false}" && sudo checkinstall)
then
  sudo make install
fi

# #############################################################################
# Final sequence

echo
if (vim --version | grep -q "${BUILD_NAME}") ; then
  echo "${PROGNAME:+$PROGNAME: }COMPLETE: Vim - '${BUILD_NAME}' build - setup complete"
  exit 0
else
  echo "${PROGNAME:+$PROGNAME: }FAIL: Vim - '${BUILD_NAME}' build is unavailable"
  exit 1
fi

exit
