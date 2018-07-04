#!/usr/bin/env bash
cat <<EOF
################################################################################
Development stacks
################################################################################
EOF

bash "${DOTFILES_DIR:-.}"/installers/setuppython.sh
bash "${DOTFILES_DIR:-.}"/installers/setuprust.sh
