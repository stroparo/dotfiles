# Dotfiles

My environment setup routines and configurations.

## Setup configurations

This will call ```dotify``` and ```deploy*``` in the scripts directory, and also ```setupaliases.sh```. 

Ensure sudo access by editing the sudoers file:

```bash
sudo visudo
```

Run and ignore some errors as this sequence is already as fault tolerant as possible:

```bash
DO_BOX=true bash -c "$(curl -LSfs https://raw.githubusercontent.com/stroparo/dotfiles/master/setup.sh)"
```

Install desktop selections by running:

```bash
unzip "$HOME"/.dotfiles.zip -d "$HOME"
cd "$HOME"/dotfiles-master/installers
bash ./debselects-desktop.sh
bash ./rpmselects-desktop.sh
```

## Setup aliases

```bash
bash -c "$(curl -LSfs https://raw.githubusercontent.com/stroparo/dotfiles/master/setupaliases.sh)"
```

## Setup shell

If only shell setup is desired then execute this sequence.

The setupshell.sh routine provides a setup with foundational shell capabilities, it:

* Installs [Daily Shells](http://stroparo.github.io/ds/) and [DS Extras](https://github.com/stroparo/ds-extras)
* Installs Oh-My-Zsh (zsh configuration framework)
* Makes an SSH RSA key-pair and echo the public key on the screen

Setup command:

```bash
bash -c "$(curl -LSfs https://raw.githubusercontent.com/stroparo/dotfiles/master/setupshell.sh)"
```

Note: if you do not have curl, substitute ```curl [options]``` for ```wget -O -``` in the command.

## Setup a development box

If only shell setup and package selections are desired then execute this sequence.

This setup is comprehensive and it does the following:

* Installs custom package selections for Debian, Ubuntu or RedHat
* Executes setupshell.sh
* Makes the $DEV directory (defaults to ~/workspace)

Setup command:

```bash
bash -c "$(curl -LSfs https://raw.githubusercontent.com/stroparo/dotfiles/master/setupbox.sh)"
```

Note: if you do not have curl, substitute ```curl [options]``` for ```wget -O -``` in the command.

## Restricted network installation

Download the zip file, unzip, and run setup.sh:

```bash
curl -o ~/dotfiles.zip https://github.com/stroparo/dotfiles/archive/master.zip
unzip ~/dotfiles.zip -d "$HOME"
cd "$HOME"/dotfiles-master
./setup.sh -b
```

Setup only aliases:

```bash
curl -o ~/dotfiles.zip https://github.com/stroparo/dotfiles/archive/master.zip
unzip ~/dotfiles.zip -d "$HOME"
cd "$HOME"/dotfiles-master
./setup.sh -a
```

Setup everything but setupbox.sh:
```bash
curl -o ~/dotfiles.zip https://github.com/stroparo/dotfiles/archive/master.zip
unzip ~/dotfiles.zip -d "$HOME"
cd "$HOME"/dotfiles-master
./setup.sh
```

