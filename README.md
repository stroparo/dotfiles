# Dotfiles

My environment setup routines and configurations.

## Setup configurations

This will call ```dotify``` and ```deploy*``` in the scripts directory, and also ```setupaliases.sh```. 

Ensure sudo access by editing the sudoers file:

```bash
sudo visudo
```

Run and ignore some errors as this sequence is as most fault tolerant as possible, already:

```bash
DO_BOX=true bash -c "$(curl -LSfs https://raw.githubusercontent.com/stroparo/dotfiles/master/setup.sh)"
```

Install desktop selections by running:

```bash
cd
unzip .dotfiles.zip
cd dotfiles-master/custom
bash ./debselects-desktop.sh
bash ./rpmselects-desktop.sh
```

## Setup Shell

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

