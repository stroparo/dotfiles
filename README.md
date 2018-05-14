# Dotfiles

My environment setup routines and configurations.

## Requirements

* [sudo setup](#sudo-setup)

## Setup configurations

Run and ignore some errors as this sequence is already as fault tolerant as possible:

```bash
bash -c "$(curl -LSf "https://gitlab.com/stroparo/dotfiles/raw/master/setupdotfiles.sh" || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/setupdotfiles.sh")" dummy -f
```

In case you are inside a restricted network and certificate verification fails for the curl download, then try adding the -k option to the curl commands in your command line(s).

Install desktop selections by running:

```bash
{
unzip -o "$HOME"/.dotfiles.zip -d "$HOME"
cd "$HOME"/dotfiles-master/installers
bash ./debselects-desktop.sh
bash ./rpmselects-desktop.sh
}

```

## Setup aliases

```bash
bash -c "$(curl -LSf "https://gitlab.com/stroparo/dotfiles/raw/master/setupaliases.sh" || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/setupaliases.sh")"
```

## Setup shell

If only shell setup is desired then execute this sequence.

The setupshell.sh routine provides a setup with foundational shell capabilities, it:

* Installs [Daily Shells](http://stroparo.github.io/ds/) and [DS Extras](https://github.com/stroparo/ds-extras)
* Installs Oh-My-Zsh (zsh configuration framework)
* Makes an SSH RSA key-pair and echo the public key on the screen

Setup command:

```bash
bash -c "$(curl -LSf "https://gitlab.com/stroparo/dotfiles/raw/master/setupshell.sh" || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/setupshell.sh")"
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
bash -c "$(curl -LSf "https://gitlab.com/stroparo/dotfiles/raw/master/setuppackages.sh" || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/setuppackages.sh")"
```

Note: if you do not have curl, substitute ```curl [options]``` for ```wget -O -``` in the command.

## Restricted network installation

Download the zip file, unzip, and run setupdotfiles.sh:

```bash
curl -LSfk -o ~/.dotfiles.zip https://github.com/stroparo/dotfiles/archive/master.zip \
  && unzip -o ~/.dotfiles.zip -d "$HOME" \
  && cd "$HOME"/dotfiles-master \
  && ./setupdotfiles.sh -f
```

Setup everything but setuppackages.sh:

```bash
curl -LSfk -o ~/.dotfiles.zip https://github.com/stroparo/dotfiles/archive/master.zip \
  && unzip -o ~/.dotfiles.zip -d "$HOME" \
  && cd "$HOME"/dotfiles-master \
  && ./setupdotfiles.sh -a -d -s
```

Setup only aliases:

```bash
curl -LSfk -o ~/.dotfiles.zip https://github.com/stroparo/dotfiles/archive/master.zip \
  && unzip -o ~/.dotfiles.zip -d "$HOME" \
  && cd "$HOME"/dotfiles-master \
  && ./setupdotfiles.sh -a
```

## Sudo setup

Ensure sudo access by editing the sudoers file (or making the edit with the commands after this one):

```bash
sudo visudo
```

Recipe to add sudo access for your user:

```
sudo grep -q "$USER" /etc/sudoers || (echo "$USER ALL=(ALL) ALL" | sudo tee -a /etc/sudoers)
```

For not having to type in the password (not recommended to keep this):

```
sudo grep -q "$USER" /etc/sudoers || (echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers)
```


