# Dotfiles

Custom configuration files and environment setup routines.

## Requirements

* [sudo setup](#sudo-setup)

## Comprehensive setup

Items: [Aliases](#aliases), dotfiles, [shell setup](#shell-setup) etcetera.

```bash
bash -c "$(curl -LSf "https://gitlab.com/stroparo/dotfiles/raw/master/setupdotfiles.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/setupdotfiles.sh")" \
  setupdotfiles.sh -f
: # empty command, makes no need to pressing ENTER for the previous command ;)
```

## Aliases

```bash
bash -c "$(curl -LSf "https://gitlab.com/stroparo/dotfiles/raw/master/setupaliases.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/setupaliases.sh")"; \
  . ~/.aliases-cs
: # empty command, makes no need to pressing ENTER for the previous command ;)
```

## Shell setup

If only shell setup is desired then execute this sequence.

The setupshell.sh routine provides for useful shell features:

* Installs [Daily Shells](http://stroparo.github.io/ds/) and [Daily Shells Extras](https://github.com/stroparo/ds-extras)
* Installs Oh-My-Zsh (zsh configuration framework)
* Makes an SSH RSA key-pair and prints the public key

```bash
bash -c "$(curl -LSf "https://gitlab.com/stroparo/dotfiles/raw/master/setupshell.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/setupshell.sh")"
: # empty command, makes no need to pressing ENTER for the previous command ;)
```

## Linux desktop packages

Custom selections of Linux desktop packages:

```bash
curl -LSf -k -o ~/.dotfiles.zip https://github.com/stroparo/dotfiles/archive/master.zip \
  && unzip -o ~/.dotfiles.zip -d "$HOME" \
  && cd "$HOME"/dotfiles-master/installers \
  && (bash ./debselects-desktop.sh || bash ./rpmselects-desktop.sh)
: # empty command, makes no need to pressing ENTER for the previous command ;)
```

---

## Sudo setup

Ensure sudo access by editing the sudoers file (or making the edit with the commands after this one):

```bash
sudo visudo
: # empty command, makes no need to pressing ENTER for the previous command ;)
```

Recipe to add sudo access for your user:

```bash
sudo grep -q "$USER" /etc/sudoers || (echo "$USER ALL=(ALL) ALL" | sudo tee -a /etc/sudoers)
: # empty command, makes no need to pressing ENTER for the previous command ;)
```

For not having to type in the password (not recommended to keep this):

```bash
sudo grep -q "$USER" /etc/sudoers || (echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers)
: # empty command, makes no need to pressing ENTER for the previous command ;)
```

## Troubleshoot curl not available / not found

If you do not have curl, substitute ```wget -O -``` for ```curl [options]``` in the command.

## Troubleshoot certificate issues in restricted networks

In case you are inside a restricted network and certificate verification fails for the curl download then try using curl's -k option.

Download the zip file, unzip, and run setupdotfiles.sh:

```bash
curl -LSf -k -o ~/.dotfiles.zip https://github.com/stroparo/dotfiles/archive/master.zip \
  && unzip -o ~/.dotfiles.zip -d "$HOME" \
  && cd "$HOME"/dotfiles-master \
  && ./setupdotfiles.sh -f
: # empty command, makes no need to pressing ENTER for the previous command ;)
```

Setup only aliases:

```bash
curl -LSfk -o ~/.dotfiles.zip https://github.com/stroparo/dotfiles/archive/master.zip \
  && unzip -o ~/.dotfiles.zip -d "$HOME" \
  && cd "$HOME"/dotfiles-master \
  && ./setupdotfiles.sh -a
: # empty command, makes no need to pressing ENTER for the previous command ;)
```


