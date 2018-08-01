#!/usr/bin/env bash

echo "################################################################################"
echo "Development stacks"

bash "${DOTFILES_DIR:-.}"/installers/setuppython.sh
bash "${DOTFILES_DIR:-.}"/installers/setuprust.sh
