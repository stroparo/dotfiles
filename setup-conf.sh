#!/usr/bin/env sh

echo "Sublime path:"
read SUBLIME_PATH

cp -v ./conf/exrc ~/.exrc
cp -v ./conf/vimrc ~/.vimrc
cp -v ./conf/sshconfig ~/.ssh/config

mkdir -p "$SUBLIME_PATH"/Data/Packages/User/
cp -v ./conf/sublime3/* "$SUBLIME_PATH"/Data/Packages/User/
