# Dotfiles

Custom configuration files and environment setup routines.

These are custom i.e. the best way to seize them is to fork this repository and have it your own way by changing, removing or adding new stuff etcetera.

## Requirements

* [runr](https://github.com/stroparo/runr) - routine runner, be acquainted with it first by reading its README
* [sudo setup](#sudo-setup)

---

## Basic usage

#### Base recipes

* alias
* apps
* dotfiles
* shell

---

## Automated Remote Setup

The script has self-provisioning capabilities so you can skip downloading and setting it up by calling this command:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/runr/raw/master/entry.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh alias apps dotfiles shell
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

One could also directly download whatever script in this repository and have its sequence executed in one fell swoop, like in this example for the custom aliases:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/dotfiles/raw/master/recipes/alias.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/recipes/alias.sh")"; \
  . ~/.aliases-cs
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

---

## Other recipes

For Daily Shells installation: setupds

For oh-my-zsh: setupohmyzsh

For SSH default key generation: sshkeygen sshmodes

Example issuing a direct download and execution of all these:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/runr/raw/master/entry.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh setupds setupohmyzsh sshkeygen sshmodes
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

---

## Linux desktop package selects

Download of the runr package plus installation of custom desktop package selects for Debian and Enterprise Linux families:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/runr/raw/master/entry.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh apps-debian-desktop apps-el-desktop
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

---

## Sudo setup

Ensure sudo access by editing the sudoers file (```sudo visudo``` command).

A handy command ready to do that edit for your user:

```bash
sudo grep -q "$USER" /etc/sudoers || (echo "$USER ALL=(ALL) ALL" | sudo tee -a /etc/sudoers)
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

Same as above but removing the password restriction for each call to sudo (not recommended):

```bash
sudo grep -q "$USER" /etc/sudoers || (echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers)
: # Ignore; This expedited running the above on paste; Press ENTER ;)
```

---

## Troubleshoot: curl program not available

If you do not have curl, substitute ```wget -O -``` for ```curl [options]``` in the command.

---

## Troubleshoot certificate issues in restricted networks

In case you are inside a restricted network and certificate verification fails for the curl download then try using curl's -k option which bypasses SSL (security) check -- obviously you know what you are doing and hold yourself entirely responsible for such an act.

Download & comprehensive setup:

```bash
curl -LSf -k -o ~/.runr.zip "https://github.com/stroparo/runr/archive/master.zip" \
  && unzip -o ~/.runr.zip -d "$HOME" \
  && cd "$HOME"/runr-master \
  && ./entry.sh alias apps dotfiles shell
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

---

