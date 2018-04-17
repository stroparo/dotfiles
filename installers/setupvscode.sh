#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

# #############################################################################
# Globals

PROGNAME="setupvscode.sh"

# #############################################################################
# Main

echo ${BASH_VERSION:+-e} "\n==> Visual Studio Code setup guide\n"

cat <<'EOF'

Links:
https://code.visualstudio.com/download
https://marketplace.visualstudio.com/items?itemName=nonoroazoro.syncing
https://gist.github.com/stroparo/5ae1e0c8fe2e7a5401a9f52b3aaec9f1
https://github.com/viatsko/awesome-vscode
EOF

# #############################################################################
# Open links

if (ps -ef | grep -i -q xorg) && which firefox >/dev/null 2>&1 ; then

  echo ${BASH_VERSION:+-e} "\n==> Opening download and gist links...\n"

  firefox \
    'https://code.visualstudio.com/download' \
    'https://marketplace.visualstudio.com/items?itemName=nonoroazoro.syncing' \
    'https://gist.github.com/stroparo/5ae1e0c8fe2e7a5401a9f52b3aaec9f1' \
    'https://github.com/viatsko/awesome-vscode' \
    &
fi
disown

# #############################################################################
# Tips on extensions

cat <<EOF

Dark themes:

Chocolate Contrast (rainglow)
Heroku (rainglow)
Jewel Contrast (rainglow)
Juicy (rainglow)

Light themes:

Quiet Light
Solarized Light
EOF

# #############################################################################

