# Dotfiles

My environment setup routines and configurations.

## Setup configurations

Run:

```bash
git clone https://github.com/stroparo/dotfiles.git
cd dotfiles
./setup-conf.sh
```

## Setup a Linux box for development

The setup.sh routine provides a very basic, general setup for software development:

* Install [Daily Shells](http://stroparo.github.io/ds/) and [DS Extras](https://github.com/stroparo/ds-extras)
* Install Oh-My-Zsh (zsh configuration framework)
* Make an SSH RSA key-pair and echo the public key on the screen

Steps:

```
bash -c "$(curl -LSfs https://raw.githubusercontent.com/stroparo/dotfiles/master/setup.sh)"
```

Note: if you do not have curl, substitute ```curl [options]``` for ```wget -O -``` in the command.

## Setup a Linux dev box plus custom settings

Setup command:

```
bash -c "$(curl -LSfs https://raw.githubusercontent.com/stroparo/dotfiles/master/setup-custom.sh)"
```

Note: if you do not have curl, substitute ```curl [options]``` for ```wget -O -``` in the command.

* Install custom package selections for Debian, Ubuntu or RedHat
* Execute this project's setup.sh
* Make the $DEV directory (defaults to ~/workspace)
* For conveniency print a loop command on the screen which - if copied and pasted on the command line - will allow you to inform and clone several git repositories

