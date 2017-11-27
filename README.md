# Dotfiles

My environment setup routines and configurations.

## Setup a Linux box for development and custom configurations

Setup command:

```
sh -c "$(curl -LSfs https://raw.githubusercontent.com/stroparo/dotfiles/master/setup-custom.sh)"
```

Note: if you do not have curl, substitute ```curl [options]``` for ```wget -O -``` in the command.

This script leverages the setup.sh script (explained below) and on top of that performs these actions:

* Install custom package selections for Debian, Ubuntu or RedHat
* Make the ~/workspace directory
* Print a loop command on the screen which - if copied and pasted on the command line - will allow you to inform and clone several git repositories

## Setup a Linux box for development

The setup.sh routine provides a very basic, general setup for software development:

* Install oh-my-zsh Z shell plugin
* Install [Daily Shells](http://stroparo.github.io/ds/)
* Make an SSH RSA key-pair, echo the public key on the screen

Steps:

```
sh -c "$(curl -LSfs https://raw.githubusercontent.com/stroparo/dotfiles/master/setup.sh)"
```

Note: if you do not have curl, substitute ```curl [options]``` for ```wget -O -``` in the command.
