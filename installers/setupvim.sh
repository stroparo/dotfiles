#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

# Install Vim devel/latest from source.
# Supports Lua, Perl Python, Ruby

# #############################################################################
# Remarks

# Interactive script.

# Configure command based on:
# https://gist.github.com/odiumediae/3b22d09b62e9acb7788baf6fdbb77cf8

# #############################################################################
# Globals

PROGNAME="$(basename "${0:-aptinstall.sh}")"
USAGE="[-p prefix_path]"

export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf

unset CONF_ARGS_LUA
unset CONF_ARGS_PERL
unset CONF_ARGS_PYTHON
unset CONF_ARGS_RUBY

# #############################################################################
# Dynamic globals

# Options:
OPTIND=1
while getopts ':hp:' option ; do
  case "${option}" in
    h) echo "$USAGE"; exit;;
    p) PREFIX="${OPTARG}";;
  esac
done
shift "$((OPTIND-1))"

export PREFIX

# #############################################################################
# Inform of start

echo ${BASH_VERSION:+-e} "\n==> $PROGNAME started..."

# #############################################################################

echo 'Support Lua?'
read DO_LUA

if [ "$DO_LUA" = y ] || [ "$DO_LUA" = true ] ; then
  DO_LUA=true
  CONF_ARGS_LUA="\
    --enable-luainterp \
    --with-luajit"
else
  DO_LUA=false
fi

# #############################################################################

echo 'Support Perl?'
read DO_PERL

if [ "$DO_PERL" = y ] || [ "$DO_PERL" = true ] ; then
  DO_PERL=true
  CONF_ARGS_PERL="--enable-perlinterp=dynamic"
else
  DO_PERL=false
fi

# #############################################################################

echo 'Support Python2?'
read DO_PYTHON2

if [ "$DO_PYTHON2" = y ] || [ "$DO_PYTHON2" = true ] ; then

  DO_PYTHON2=true

  echo 'Enter Python2 config dir: '
  echo 'Examples in Fedora 27:'
  echo '/usr/lib/python2.7/config'
  echo '/usr/lib64/python2.7/config'
  read PYTHON2_CONFIG_DIR

  CONF_ARGS_PYTHON2="\
    --enable-python3interp \
    --with-python-config-dir=\"$PYTHON2_CONFIG_DIR\""
else
  DO_PYTHON2=false
fi

# #############################################################################

echo 'Support Python3?'
read DO_PYTHON3

if [ "$DO_PYTHON3" = y ] || [ "$DO_PYTHON3" = true ] ; then

  DO_PYTHON3=true

  echo 'Enter Python3 config dir: '
  echo 'Examples in Fedora 27:'
  echo '/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu'
  echo '/usr/lib64/python3.6/config-3.6m-x86_64-linux-gnu'
  read PYTHON3_CONFIG_DIR

  CONF_ARGS_PYTHON3="\
    --enable-python3interp \
    --with-python3-config-dir=\"$PYTHON3_CONFIG_DIR\""
else
  DO_PYTHON3=false
fi

# #############################################################################

echo 'Support Ruby?'
read DO_RUBY
if [ "$DO_RUBY" = y ] || [ "$DO_RUBY" = true ] ; then

  DO_RUBY=true

  if which ruby >/dev/null 2>&1 ; then
    RUBY_BINARY_PATH="$(which ruby)"
  else
    echo 'Enter Ruby binary path: '
    echo '(E.g.: /usr/local/bin/ruby)'
    read RUBY_BINARY_PATH
  fi

  CONF_ARGS_RUBY="\
    --enable-rubyinterp=dynamic \
    --with-ruby-command=\"$RUBY_BINARY_PATH\""
else
  DO_RUBY=false
fi

# #############################################################################
# Prep dependencies

if egrep -i -q 'debian|ubuntu' /etc/*release* ; then

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
  if "$DO_LUA" ; then
    sudo $APTPROG install -y liblua5.1-dev luajit libluajit-5.1
  fi
  if "$DO_PERL" ; then
    sudo $APTPROG install -y perl libperl-dev
  fi
  if "$DO_PYTHON2" ; then
    sudo $APTPROG install -y python-dev python-pip
  fi
  if "$DO_PYTHON3" ; then
    sudo $APTPROG install -y python3-dev python3-pip
  fi

  # Optional: so vim can be uninstalled again via `dpkg -r vim`
  sudo $APTPROG install checkinstall

elif egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release* ; then

  # Utilities:
  sudo $RPMPROG -y install ctags
  which cmake >/dev/null 2>&1 || sudo $RPMPROG -y install cmake
  which curl >/dev/null 2>&1 || sudo $RPMPROG -y install curl
  which gcc >/dev/null 2>&1 || sudo $RPMPROG -y install gcc
  which git >/dev/null 2>&1 || sudo $RPMPROG -y install git
  sudo $RPMPROG -y groupinstall 'Development Tools'

  # Libraries:
  sudo $RPMPROG -y install ncurses ncurses-devel
  # TODO include Lua installation commands
  if "$DO_PERL" ; then
    sudo $RPMPROG install -y perl perl-devel perl-ExtUtils-Embed
  fi
  if "$DO_PYTHON2" ; then
    sudo $RPMPROG install -y python python-devel
  fi
  if "$DO_PYTHON3" ; then
    sudo $RPMPROG install -y python3 python3-devel
  fi
fi

# #############################################################################
# Main installation
# Additional arguments are handed over to the configure call

VIM_PKG="$HOME/vim.zip"
VIM_PKG_DIR="$(dirname "${VIM_PKG}")"
VIM_SETUP_DIR="$VIM_PKG_DIR/vim-master"

if [ ! -e "$VIM_PKG" ] ; then
  curl -LSfs https://github.com/vim/vim/archive/master.zip > "$VIM_PKG"
fi

if ! unzip "$VIM_PKG" -d "$VIM_PKG_DIR" ; then
  echo "FATAL: unzipping '$VIM_PKG'." 1>&2
  exit 1
fi

cd "$VIM_SETUP_DIR/src" \
  && [ "$PWD" = "$VIM_SETUP_DIR/src" ] \
  && make distclean

cd "$VIM_SETUP_DIR" \
  && [ "$PWD" = "$VIM_SETUP_DIR" ] \
  && eval ./configure \
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
  && make \
  && (sudo checkinstall || sudo make install)
