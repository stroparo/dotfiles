#!/bin/bash 

# Save this script into set_colors.sh, make this file executable and run it: 
# 
# $ chmod +x set_colors.sh 
# $ ./set_colors.sh 
# 
# Alternatively copy lines below directly into your shell. 

gconftool-2 -s -t string /apps/guake/style/background/color '#1d1d1f1f2121'
gconftool-2 -s -t string /apps/guake/style/font/color '#c5c5c8c8c6c6'
gconftool-2 -s -t string /apps/guake/style/font/palette '#1d1d1f1f2121:#cccc66666666:#b5b5bdbd6868:#f0f0c6c67474:#8181a2a2bebe:#b2b29494bbbb:#8a8abebeb7b7:#c5c5c8c8c6c6:#969698989696:#cccc66666666:#b5b5bdbd6868:#f0f0c6c67474:#8181a2a2bebe:#b2b29494bbbb:#8a8abebeb7b7:#ffffffffffff'
