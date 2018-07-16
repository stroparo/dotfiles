#!/bin/bash 

# Save this script into set_colors.sh, make this file executable and run it: 
# 
# $ chmod +x set_colors.sh 
# $ ./set_colors.sh 
# 
# Alternatively copy lines below directly into your shell. 

gconftool-2 -s -t string /apps/guake/style/background/color '#000000000000'
gconftool-2 -s -t string /apps/guake/style/font/color '#d9d9e6e6f2f2'
gconftool-2 -s -t string /apps/guake/style/font/palette '#000000000000:#353535353535:#c6c66c6c8181:#e3e3b5b5c0c0:#8181c6c66c6c:#c0c0e3e3b5b5:#c6c6b1b16c6c:#e3e3d8d8b5b5:#6c6c8181c6c6:#b5b5c0c0e3e3:#b1b16c6cc6c6:#d8d8b5b5e3e3:#6c6cc6c6b1b1:#b5b5e3e3d8d8:#d9d9d9d9d9d9:#ffffffffffff'
