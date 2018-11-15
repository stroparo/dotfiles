#!/usr/bin/env bash

# Install Ruby, Rails, Bundler and common gems
# Argument is a gemfile to use to install global packages

UBUNTU_VERSION_SUPPORTED="16.04"

echo
echo "################################################################################"
echo "Setup Ruby stack in Ubuntu $UBUNTU_VERSION_SUPPORTED"

# #############################################################################
# Globals

export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt

# #############################################################################
# Checks

if (! grep -q "Ubuntu" /etc/os-release || ! fgrep -q -r "$UBUNTU_VERSION_SUPPORTED" /etc/os-release) ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: Only Ubuntu supported." 1>&2
  exit
fi

# #############################################################################
# Helpers

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
# Functions

installDependencies () {

    typeset deps="git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs"

    sudo $APTPROG update || return $?
    sudo $APTPROG install -y $deps || return $?
}

installRbenv () {

    typeset rbenvcheckexpr=".rbenv/"
    typeset rbenvprofile="export PATH=\"\$HOME/.rbenv/bin:\$PATH\"
eval \"\$(rbenv init -)\"
export PATH=\"\$HOME/.rbenv/plugins/ruby-build/bin:\$PATH\""

    if [ -e ~/.rbenv ] ; then
        echo 'installRbenv: SKIP: ~/.rbenv present already.' 1>&2
        return
    else
        git clone --depth 1 "https://github.com/rbenv/rbenv.git" ~/.rbenv || return $?
    fi

    if [ ! -e ~/.rbenv/plugins/ruby-build ] ; then
        git clone --depth 1 "https://github.com/rbenv/ruby-build.git" ~/.rbenv/plugins/ruby-build || return $?
    fi

    if [[ "$(uname -a)" = *[Uu]buntu* ]] && [[ "$-" = *i* ]] ; then
        # Ubuntu desktop edge case as pointed out in
        #   https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-14-04
        if ! grep -F -q "$rbenvcheckexpr" ~/.bashrc ; then
            echo "$rbenvprofile" >> ~/.bashrc
        fi
    else
        if ! grep -F -q "$rbenvcheckexpr" ~/.bash_profile ; then
            echo "$rbenvprofile" >> ~/.bash_profile
        fi
    fi

    if [ -e ~/.zshrc ] ; then
        if ! grep -F -q "$rbenvcheckexpr" ~/.zshrc ; then
            echo "$rbenvprofile" >> ~/.zshrc
        fi
    fi

    exec $SHELL
}

installVm () {

    typeset version="$1"

    rbenv install -v "$version" || return $?
}

setDefaultVm () {

    typeset version="$1"

    rbenv global "$version" || return $?
    rbenv rehash
    ruby -v
}

installBundler () {

    echo "gem: --no-document" > ~/.gemrc

    gem install bundler || return $?
    rbenv rehash

}

installGemDeps () {

    typeset deps

    if _user_confirm "Install imagemagick?" ; then
        deps="$deps imagemagick libmagick++-dev"
    fi

    if _user_confirm "Install PostgreSQL database?" ; then
        deps="$deps postgresql postgresql-doc libpq-dev postgresql-server-dev-all"
    fi

    sudo $APTPROG install -y $deps || return $?
}

# #############################################################################
# Ruby

installDependencies || exit $?
installRbenv || exit $?

export RUBY_VERSION='2.3.3'
userinput "Enter desired ruby version (default: $RUBY_VERSION)"
export RUBY_VERSION="${userinput:-$RUBY_VERSION}"
installVm "$RUBY_VERSION" || exit $?

setDefaultVm "$RUBY_VERSION" || exit $?

# #############################################################################
# Gems

installBundler || exit $?
installGemDeps || exit $?

if [ -f "$1" ]; then
    BUNDLE_GEMFILE="$1" bundle || exit $?
fi

# #############################################################################
# Display version of main packages

echo ${BASH_VERSION:+-e} "sqlite3\c " ; sqlite3 --version
ruby -v
rails -v

# #############################################################################
# Finish

echo "FINISHED Ruby setup"
echo
