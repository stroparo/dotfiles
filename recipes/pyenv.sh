#!/usr/bin/env bash

# This pyenv setup recipe is based on Henrique Bastos gist at:
# https://gist.github.com/henriquebastos/0a45c39115ca5b3776a93c89dbddfacb

# The final pyenv global PATH priority setup will be:
# PY3 PY2 poetry(3) jupyter(3) ipython(2) tools(3) tools(2)

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
export PYV3='3.9.1'

# Python 3 VENV's:
export VENVJUPYTER="jupyter$(echo ${PYV3%.*} | tr -d .)"
export VENVPOETRY="poetry$(echo ${PYV3%.*} | tr -d .)"
export VENVTOOLS3="tools$(echo ${PYV3%.*} | tr -d .)"

# Python 2 VENV's:
export VENVIPYTHON="ipython$(echo ${PYV2%.*} | tr -d .)"
export VENVTOOLS2="tools$(echo ${PYV2%.*} | tr -d .)"

export PYENV_GLOBAL_DEFAULT="$PYV3 $PYV2 $VENVJUPYTER $VENVIPYTHON $VENVPOETRY $VENVTOOLS3 $VENVTOOLS2"

export PYENV_INSTALLER="https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer"

export PYENV_SHELL_INIT='export PYENV_ROOT="$HOME/.pyenv"
export PATH="${PYENV_ROOT:-$HOME/.pyenv}/bin:${PATH}"
if command -v pyenv >/dev/null 2>&1 ; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi
'

export PYENV_VENVWRAPPER_INIT="
# Virtualenv Wrapper initialization
export VIRTUALENVWRAPPER_PYTHON=~/.pyenv/versions/$VENVTOOLS3/bin/python
source ~/.pyenv/versions/$VENVTOOLS3/bin/virtualenvwrapper.sh
"

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Prep PROJECT_HOME ($PROJS) and WORKON_HOME ($VENVS) directories..."

mkdir -p "${PROJS}"
mkdir -p "${VENVS}"
if ! ls -ld "${PROJS}" "${VENVS}" ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Could not make either of '${PROJS}' or '${VENVS}' directories." 1>&2
  exit 1
fi

echo ${BASH_VERSION:+-e} "\n\n==> Prep shell profiles with WORKON_HOME global..."
if ! grep -q 'WORKON_HOME=' ~/.bashrc ; then echo "export WORKON_HOME=\"${VENVS}\"" >> ~/.bashrc ; fi
if ! grep -q 'WORKON_HOME=' ~/.zshrc ; then echo "export WORKON_HOME=\"${VENVS}\"" >> ~/.zshrc ; fi
if ! grep -q 'WORKON_HOME=' ~/.bashrc ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Could not write WORKON_HOME global in shell profiles." 1>&2
  exit 1
fi

echo ${BASH_VERSION:+-e} "\n\n==> Prep shell profiles with PROJECT_HOME global..."
if ! grep -q 'PROJECT_HOME=' ~/.bashrc ; then echo "export PROJECT_HOME=\"${PROJS}\"" >> ~/.bashrc ; fi
if ! grep -q 'PROJECT_HOME=' ~/.zshrc ; then echo "export PROJECT_HOME=\"${PROJS}\"" >> ~/.zshrc ; fi
if ! grep -q 'PROJECT_HOME=' ~/.bashrc ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Could not write PROJECT_HOME global in shell profiles." 1>&2
  exit 1
fi

# Speed up disabling prompt as it is going to be discontinued anyway:
if ! grep -q 'DISABLE_PROMPT=1' ~/.bashrc ; then echo "export PYENV_VIRTUALENV_DISABLE_PROMPT=1
" >> ~/.bashrc ; fi
if ! grep -q 'DISABLE_PROMPT=1' ~/.zshrc ; then echo "export PYENV_VIRTUALENV_DISABLE_PROMPT=1
" >> ~/.zshrc ; fi

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Setup and load into this session..."

if ! grep -q 'pyenv init' "$HOME/.bashrc" ; then echo "$PYENV_SHELL_INIT" >> "$HOME/.bashrc" ; fi
if ! grep -q 'pyenv init' "$HOME/.zshrc" ; then echo "$PYENV_SHELL_INIT" >> "$HOME/.zshrc" ; fi

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

pyenv install -s "$PYV3"
if ! pyenv versions | grep -q -w "$PYV3" ; then exit 1 ; fi

pyenv install -s "$PYV2"

echo ${BASH_VERSION:+-e} "\n\n==> pip upgrade for Python interpreters...\n"
~/.pyenv/versions/${PYV3}/bin/pip install --upgrade pip
~/.pyenv/versions/${PYV2}/bin/pip install --upgrade pip

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Setup virtualenvs dedicated to tooling..."

pyenv virtualenv -f "$PYV3" $VENVJUPYTER
pyenv virtualenv -f "$PYV3" $VENVPOETRY
pyenv virtualenv -f "$PYV3" $VENVTOOLS3

# Python 2:
pyenv virtualenv -f "$PYV2" $VENVIPYTHON
pyenv virtualenv -f "$PYV2" $VENVTOOLS2

echo ${BASH_VERSION:+-e} "\n\n==> pip upgrade for tooling virtualenvs...\n"
~/.pyenv/versions/$VENVJUPYTER/bin/pip install --upgrade pip
~/.pyenv/versions/$VENVPOETRY/bin/pip install --upgrade pip
~/.pyenv/versions/$VENVTOOLS3/bin/pip install --upgrade pip
~/.pyenv/versions/$VENVIPYTHON/bin/pip install --upgrade pip
~/.pyenv/versions/$VENVTOOLS2/bin/pip install --upgrade pip

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Install Jupyter in its own virtualenv ('$VENVJUPYTER')..."

# iPython dependency gets automatically installed with jupyter:
~/.pyenv/versions/$VENVJUPYTER/bin/pip install jupyter
~/.pyenv/versions/$VENVJUPYTER/bin/python -m ipykernel install --user
~/.pyenv/versions/$VENVJUPYTER/bin/pip install jupyter_nbextensions_configurator rise
~/.pyenv/versions/$VENVJUPYTER/bin/jupyter nbextensions_configurator enable --user

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Install IPython for Python 2 in its own virtualenv ('$VENVIPYTHON')..."

~/.pyenv/versions/$VENVIPYTHON/bin/pip install ipykernel
~/.pyenv/versions/$VENVIPYTHON/bin/python -m ipykernel install --user

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Install Poetry for Python 3 in its own virtualenv ('$VENVPOETRY')..."

~/.pyenv/versions/$VENVPOETRY/bin/pip install poetry

# #############################################################################
echo ${BASH_VERSION:+-e} "\n\n==> Install virtualenvwrapper in virtualenv '$VENVTOOLS3'..."

~/.pyenv/versions/$VENVTOOLS3/bin/pip install virtualenvwrapper

if ! grep -q 'virtualenvwrapper.sh' "$HOME/.bashrc" ; then echo "$PYENV_VENVWRAPPER_INIT" >> "$HOME/.bashrc" ; fi
if ! grep -q 'virtualenvwrapper.sh' "$HOME/.zshrc" ; then echo "$PYENV_VENVWRAPPER_INIT" >> "$HOME/.zshrc" ; fi

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
