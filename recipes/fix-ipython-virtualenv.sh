#!/usr/bin/env bash

PROGNAME='fix-ipython-virtualenv.sh'

if ! which ipython >/dev/null 2>&1 ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: No ipython in PATH." 1>&2
  exit
fi

echo "${PROGNAME}: INFO: IPython virtualenv detection fix (by Henrique Bastos)..."

ipython profile create

mkdir -p "$HOME"/.ipython/profile_default/startup
if [ !-d "$HOME"/.ipython/profile_default/startup ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Dir '$HOME/.ipython/profile_default/startup' could not be created." 1>&2
fi

cat > "$HOME"/.ipython/profile_default/startup/00-add-venv-sitepackages-libs-to-sys-path.py <<'EOF'
"""IPython startup script to detect and inject actual VIRTUAL_ENV's site-packages dirs.

IPython can detect virtualenv's path and inject its site-packages dirs into sys.path.
But it can go wrong if IPython's python version differs from the VIRTUAL_ENV's one.

This module fixes it by looking up the actual dirs and prepending them into sys.path.

Only old stdlib resources are used so as to work with as many Python versions as possible.

References:
http://stackoverflow.com/a/30650831/443564
http://stackoverflow.com/questions/122327/how-do-i-find-the-location-of-my-python-site-packages-directory
https://github.com/ipython/ipython/blob/master/IPython/core/interactiveshell.py#L676

Author: Henrique Bastos <henrique@bastos.net>
License: BSD

Description above slightly updated by Cristian Stroparo
"""
import os
from os.path import join
import sys
from glob import glob


virtualenv = os.environ.get('VIRTUAL_ENV')

if virtualenv:

  for path in glob(join(virtualenv, 'lib', 'python*', '*')):
      if path not in sys.path:
          sys.path.insert(0, path)
EOF
