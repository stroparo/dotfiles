#!/usr/bin/env bash

# This pyenv setup recipe is based on Henrique Bastos gist at:
# https://gist.github.com/henriquebastos/0a45c39115ca5b3776a93c89dbddfacb

# The final pyenv global PATH priority setup will be:
# PY3 PY2 jupyter(3) ipython(2) tools(3) tools(2)

# pyenv projects:
# https://github.com/yyuu/pyenv-installer (https://github.com/yyuu/pyenv)
# https://github.com/yyuu/pyenv-virtualenv
# https://github.com/yyuu/pyenv-virtualenvwrapper

# pyenv common problems:
# https://github.com/pyenv/pyenv/wiki/Common-build-problems

export PROGNAME="pyenv.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: Python pyenv & virtualenv wrapper setup"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals / env

[ -n "$ZSH_VERSION" ] && set -o shwordsplit

export PROJS="${HOME}/workspace"
export VENVS="${HOME}/.ve"

export PYV2='2.7.18'
export PYV3='3.8.3'
export VENVJUPYTER="jupyter$(echo ${PYV3%.*} | tr -d .)"
export VENVIPYTHON="ipython$(echo ${PYV2%.*} | tr -d .)"
export VENVTOOLS3="tools$(echo ${PYV3%.*} | tr -d .)"
export VENVTOOLS2="tools$(echo ${PYV2%.*} | tr -d .)"
export PYENV_GLOBAL_DEFAULT="$PYV3 $PYV2 $VENVJUPYTER $VENVIPYTHON $VENVTOOLS3 $VENVTOOLS2"

export PYENV_INSTALLER="https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer"

export PYENV_SHELL_INIT='
export PYENV_ROOT="$HOME/.pyenv"
export PATH="${PYENV_ROOT:-$HOME/.pyenv}/bin:${PATH}"
if command -v pyenv >/dev/null 2>&1 ; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi'

export PYENV_VENVWRAPPER_INIT="
# Virtualenv Wrapper initialization
export VIRTUALENVWRAPPER_PYTHON=~/.pyenv/versions/$VENVTOOLS3/bin/python
source ~/.pyenv/versions/$VENVTOOLS3/bin/virtualenvwrapper.sh"

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Prep PROJECT_HOME ($PROJS) and WORKON_HOME ($VENVS) directories..."

mkdir -p "${PROJS}"
mkdir -p "${VENVS}"
if ! ls -ld "${PROJS}" "${VENVS}" ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Could not make either of '${PROJS}' or '${VENVS}' directories." 1>&2
  exit 1
fi

echo ${BASH_VERSION:+-e} "\n\n==> Prep shell profiles with WORKON_HOME global..."
if ! grep -q 'WORKON_HOME=' ~/.bashrc ; then echo "export WORKON_HOME=\"${VENVS}\"" >> ~/.bashrc
if ! grep -q 'WORKON_HOME=' ~/.zshrc ; then echo "export WORKON_HOME=\"${VENVS}\"" >> ~/.zshrc
if ! grep -q 'WORKON_HOME=' ~/.bashrc ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Could not write WORKON_HOME global in shell profiles." 1>&2
  exit 1
fi

echo ${BASH_VERSION:+-e} "\n\n==> Prep shell profiles with PROJECT_HOME global..."
if ! grep -q 'PROJECT_HOME=' ~/.bashrc ; then echo "export PROJECT_HOME=\"${PROJS}\"" >> ~/.bashrc
if ! grep -q 'PROJECT_HOME=' ~/.zshrc ; then echo "export PROJECT_HOME=\"${PROJS}\"" >> ~/.zshrc
if ! grep -q 'PROJECT_HOME=' ~/.bashrc ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Could not write PROJECT_HOME global in shell profiles." 1>&2
  exit 1
fi

# Speed up disabling prompt as it is going to be discontinued anyway:
if ! grep -q 'DISABLE_PROMPT=1' ~/.bashrc ; then echo "export PYENV_VIRTUALENV_DISABLE_PROMPT=1" >> ~/.bashrc
if ! grep -q 'DISABLE_PROMPT=1' ~/.zshrc ; then echo "export PYENV_VIRTUALENV_DISABLE_PROMPT=1" >> ~/.zshrc

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Setup and load into this session..."

grep -q 'pyenv init' "$HOME/.bashrc" || echo "$PYENV_SHELL_INIT" >> "$HOME/.bashrc"
grep -q 'pyenv init' "$HOME/.zshrc" || echo "$PYENV_SHELL_INIT" >> "$HOME/.zshrc"

if ! (cd "${HOME}/.pyenv" && [[ $PWD = */.pyenv ]] && git pull >/dev/null 2>&1) ; then
  bash -c "$(curl -L "$PYENV_INSTALLER")"
fi

eval "$PYENV_SHELL_INIT"

if ! which pyenv >/dev/null 2>&1 ; then
  echo "FATAL: There was some error installing pyenv." 1>&2
  exit 1
fi

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Setup Python interpreters..."

pyenv install "$PYV3" || exit $?
pyenv install "$PYV2"

echo ${BASH_VERSION:+-e} "\n\n==> pip upgrade for Python interpreters...\n"
~/.pyenv/versions/${PYV3}/bin/pip install --upgrade pip
~/.pyenv/versions/${PYV2}/bin/pip install --upgrade pip

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Setup virtualenv's for tooling..."

pyenv virtualenv -f "$PYV3" $VENVJUPYTER
pyenv virtualenv -f "$PYV2" $VENVIPYTHON
pyenv virtualenv -f "$PYV3" $VENVTOOLS3
pyenv virtualenv -f "$PYV2" $VENVTOOLS2

echo ${BASH_VERSION:+-e} "\n\n==> pip upgrade for tooling virtualenv's...\n"
~/.pyenv/versions/$VENVJUPYTER/bin/pip install --upgrade pip
~/.pyenv/versions/$VENVTOOLS3/bin/pip install --upgrade pip
~/.pyenv/versions/$VENVIPYTHON/bin/pip install --upgrade pip
~/.pyenv/versions/$VENVTOOLS2/bin/pip install --upgrade pip

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Install Jupyter and iPython in its own virtualenv..."

# iPython dependency gets automatically installed with jupyter:
~/.pyenv/versions/$VENVJUPYTER/bin/pip install jupyter
~/.pyenv/versions/$VENVJUPYTER/bin/python -m ipykernel install --user
~/.pyenv/versions/$VENVJUPYTER/bin/pip install jupyter_nbextensions_configurator rise
~/.pyenv/versions/$VENVJUPYTER/bin/jupyter nbextensions_configurator enable --user

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Install IPython for Python 2 in its own virtualenv..."

~/.pyenv/versions/$VENVIPYTHON/bin/pip install ipykernel
~/.pyenv/versions/$VENVIPYTHON/bin/python -m ipykernel install --user

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Install virtualenvwrapper in tooling virtualenv..."

~/.pyenv/versions/$VENVTOOLS3/bin/pip install virtualenvwrapper

grep -q 'virtualenvwrapper.sh' "$HOME/.bashrc" || echo "$PYENV_VENVWRAPPER_INIT" >> "$HOME/.bashrc"
grep -q 'virtualenvwrapper.sh' "$HOME/.zshrc" || echo "$PYENV_VENVWRAPPER_INIT" >> "$HOME/.zshrc"

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Write-protect lib dir for globals interpreters..."

chmod -R -w ~/.pyenv/versions/$PYV2/lib/
chmod -R -w ~/.pyenv/versions/$PYV3/lib/

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Setup pyenv PATH priority ($PYENV_GLOBAL_DEFAULT)..."

pyenv global $PYENV_GLOBAL_DEFAULT

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE"
echo
echo

exit
