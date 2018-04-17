#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

# Install Vim devel/latest from source.
# Supports Lua, Perl Python, Ruby

# #############################################################################
# Remarks

# Interactive mode trigered with -i option.
# Errors may generate prompts even during a non-interactive run.

# Configure command based on:
# https://gist.github.com/odiumediae/3b22d09b62e9acb7788baf6fdbb77cf8

# #############################################################################
# Globals

PROGNAME="$(basename "${0:-setupvim.sh}")"
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
while getopts ':hip:' option ; do
  case "${option}" in
    h) echo "$USAGE"; exit;;
    i) export INTERACTIVE=true;;
    p) export PREFIX="${OPTARG}";;
  esac
done
shift "$((OPTIND-1))"

# #############################################################################
# Inform of start

echo ${BASH_VERSION:+-e} "\n==> $PROGNAME started..."

# #############################################################################
# Prompt for specific support

for arg in "$@" ; do
  case $arg in
    lua)      DO_LUA=true;;
    perl)     DO_PERL=true;;
    python2|python) DO_PYTHON2=true;;
    python3)  DO_PYTHON3=true;;
    ruby)     DO_RUBY=true;;
  esac
done

# #############################################################################
# Prep dependencies

echo ${BASH_VERSION:+-e} "\n==> Dependencies custom scripts...\n"

if ${DO_LUA:-false} ; then "setuplua.sh" ; fi
if ${DO_PERL:-false} ; then "setupperl.sh" ; fi
if ${DO_PYTHON2:-false} || ${DO_PYTHON3:-false} ; then "setuppython.sh" "system" ; fi

echo ${BASH_VERSION:+-e} "\n==> Dependencies from OS repos (deb, rpm)...\n"

if egrep -i -q 'debian|ubuntu' /etc/*release ; then

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

elif egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release ; then

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
_prep_lua

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
_prep_perl

# #############################################################################

_prep_python2 () {
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
    elif egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release ; then
      PYTHON2_CONFIG_DIR="/usr/lib64/python2.7/config"
    elif egrep -i -q 'ubuntu' /etc/*release ; then
      PYTHON2_CONFIG_DIR="/usr/lib/python2.7/config-x86_64-linux-gnu"
    else
      DO_PYTHON2=false
      return
    fi

    CONF_ARGS_PYTHON2="\
      --enable-python3interp \
      --with-python-config-dir=\"$PYTHON2_CONFIG_DIR\""
  else
    DO_PYTHON2=false
    return
  fi
}
_prep_python2

# #############################################################################

_prep_python3 () {
  if [ "$DO_PYTHON3" = y ] || [ "$DO_PYTHON3" = true ] ; then

    DO_PYTHON3=true

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
    elif egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release ; then
      PYTHON3_CONFIG_DIR="/usr/lib64/python3.4/config-3.4m-x86_64-linux-gnu"
    elif egrep -i -q 'ubuntu' /etc/*release ; then
      PYTHON3_CONFIG_DIR="/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu"
    else
      DO_PYTHON3=false
      return
    fi

    CONF_ARGS_PYTHON3="\
      --enable-python3interp \
      --with-python3-config-dir=\"$PYTHON3_CONFIG_DIR\""
  else
    DO_PYTHON3=false
    return
  fi
}
_prep_python3

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
_prep_ruby

# #############################################################################
# Main installation
# Additional arguments are handed over to the configure call

VIM_PKG="$HOME/vim.zip"
VIM_PKG_DIR="$(dirname "${VIM_PKG}")"
VIM_SETUP_DIR="$VIM_PKG_DIR/vim-master"

if [ ! -e "$VIM_PKG" ] ; then
  curl -LSfs https://github.com/vim/vim/archive/master.zip > "$VIM_PKG"
fi

if ! unzip -o "$VIM_PKG" -d "$VIM_PKG_DIR" ; then
  echo "FATAL: unzipping '$VIM_PKG'." 1>&2
  exit 1
fi

cd "$VIM_SETUP_DIR/src" \
  && [ "$PWD" = "$VIM_SETUP_DIR/src" ] \
  && make distclean

cd "$VIM_SETUP_DIR"
[ "$PWD" = "$VIM_SETUP_DIR" ] || exit $?

eval ./configure \
  "$@" \
  ${PREFIX:+--prefix="$PREFIX"} \
  $CONF_ARGS_LUA \
  $CONF_ARGS_PERL \
  $CONF_ARGS_PYTHON2 \
  $CONF_ARGS_PYTHON3 \
  $CONF_ARGS_RUBY \
  --disable-gui \
  --enable-multibyte \
  --enable-cscope \
  --with-features=huge \
  --with-x \
  --enable-fontset \
  --enable-largefile \
  --disable-netbeans \
  --with-compiledby="ds-extras" \
  --enable-fail-if-missing \
  && make

if [ "$?" -eq 0 ] \
  && ! ("${INTERACTIVE:-false}" && sudo checkinstall)
then
  sudo make install
fi
