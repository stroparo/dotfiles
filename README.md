# Dotfiles

My environment setup routines and configurations.

## Setup configurations

This will call ```dotify``` and ```deploy*``` in the scripts directory, and also ```setupaliases.sh```. 
Run:

```bash
curl -LSfs -o "$HOME"/dotfiles.zip \
  https://github.com/stroparo/dotfiles/archive/master.zip \
  && unzip "$HOME"/dotfiles.zip -d "$HOME" \
  && cd dotfiles-master \
  && [ "$PWD" = "$HOME"/dotfiles-master ] \
  && ./setup.sh
```

## Setup Shell

The setupshell.sh routine provides a setup with foundational shell capabilities, it:

* Installs [Daily Shells](http://stroparo.github.io/ds/) and [DS Extras](https://github.com/stroparo/ds-extras)
* Installs Oh-My-Zsh (zsh configuration framework)
* Makes an SSH RSA key-pair and echo the public key on the screen

Setup command:

```
bash -c "$(curl -LSfs https://raw.githubusercontent.com/stroparo/dotfiles/master/setupshell.sh)"
```

Note: if you do not have curl, substitute ```curl [options]``` for ```wget -O -``` in the command.

## Setup a development box

This setup is comprehensive and it does the following:

* Installs custom package selections for Debian, Ubuntu or RedHat
* Executes setupshell.sh
* Makes the $DEV directory (defaults to ~/workspace)
* Conveniently prints a loop command on the screen which - if copied and pasted on the command line - will allow you to inform and clone several git repositories

Setup command:

```
bash -c "$(curl -LSfs https://raw.githubusercontent.com/stroparo/dotfiles/master/setupbox.sh)"
```

Note: if you do not have curl, substitute ```curl [options]``` for ```wget -O -``` in the command.

