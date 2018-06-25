# Dotfiles

Custom configuration files and environment setup routines.

These are custom i.e. the best way to seize them is to fork this repository and have it your own way by changing, removing or adding new stuff etcetera.

## Requirements

* [sudo setup](#sudo-setup)
* Call the ```./entry.sh``` script only from inside the dotfiles directory i.e. first ```cd /path/to/dotfiles``` (automatically done by the automated remote setup below)

## Basic usage

The main script is ```entry.sh``` at the root directory. Enter the dotfiles directory before calling it -- this is VERY IMPORTANT -- otherwise it will provision itself to ```$HOME/dotfiles-master``` and cd into it by itself before starting.

Running with no options nor arguments is the same as ```./entry.sh -d``` ('d' for "dotfiles"). Besides dotfiles themselves this will also apply configurations in the ```scripts/deploy*.sh``` routines, providing for:

* Create the workspace directory ($HOME/workspace)
* Git custom configuration
* Sublime Text custom configuration
* Vim custom configuration

#### Other options

* ```-a``` aliases
* ```-b``` basic software selects
* ```-d``` dotfiles i.e. tools' configurations
* ```-s``` shell setup: [Daily Shells](http://stroparo.github.io/ds/), [Oh-My-Zsh](https://ohmyz.sh/) etcetera
* ```-f``` (f for full): aliases, basic software, dotfiles, shell

#### Recipes

After the options you might specify arguments. These are a list of recipes to be executed. These recipes are scripts in the ```recipes``` directory. You might omit the ```.sh``` extension and the script will put it back in.

## Automated Remote Setup

The script has self-provisioning capabilities so you can skip downloading and setting it up by calling this command:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/dotfiles/raw/master/entry.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/entry.sh")" \
  entry.sh -f
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

Instead of the ```-f``` option you could give it ```-a``` to have only custom aliases deployed or even directly download the script invoked by ```-a``` (```setupaliases.sh```) and execute it in one fell swoop directly:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/dotfiles/raw/master/setupaliases.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/setupaliases.sh")"; \
  . ~/.aliases-cs
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

## Shell setup

If only shell setup is desired then execute ```./entry.sh -s```.

The ```setupshell.sh``` routine provides for useful shell features:

* Installs [Daily Shells](http://stroparo.github.io/ds/) and [Daily Shells Extras](https://github.com/stroparo/ds-extras)
* Installs Oh-My-Zsh (zsh configuration framework)
* Makes an SSH RSA key-pair and prints the public key

Direct download and execution:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/dotfiles/raw/master/setupshell.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/setupshell.sh")"
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

---

## Linux desktop package selects

Download of the dotfiles package plus installation of custom desktop package selects for Debian and Enterprise Linux families:

```bash
curl -LSf -k -o ~/.dotfiles.zip https://github.com/stroparo/dotfiles/archive/master.zip \
  && unzip -o ~/.dotfiles.zip -d "$HOME" \
  && cd "$HOME"/dotfiles-master/recipes \
  && (bash ./apps-debian-desktop.sh || bash ./apps-el-desktop.sh)
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

---

## Sudo setup

Ensure sudo access by editing the sudoers file (or making the edit with the commands after this one):

```bash
sudo visudo
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

Recipe to add sudo access for your user:

```bash
sudo grep -q "$USER" /etc/sudoers || (echo "$USER ALL=(ALL) ALL" | sudo tee -a /etc/sudoers)
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

For not having to type in the password (not recommended to keep this):

```bash
sudo grep -q "$USER" /etc/sudoers || (echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers)
: # Ignore; This expedited running the above on paste; Press ENTER ;)
```

---

## Troubleshoot curl not available / not found

If you do not have curl, substitute ```wget -O -``` for ```curl [options]``` in the command.

---

## Troubleshoot certificate issues in restricted networks

In case you are inside a restricted network and certificate verification fails for the curl download then try using curl's -k option.

Download & comprehensive setup:

```bash
curl -LSf -k -o ~/.dotfiles.zip "https://github.com/stroparo/dotfiles/archive/master.zip" \
  && unzip -o ~/.dotfiles.zip -d "$HOME" \
  && cd "$HOME"/dotfiles-master \
  && ./entry.sh -f
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

Aliases:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/dotfiles/raw/master/setupaliases.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/setupaliases.sh")"; \
  . ~/.aliases-cs
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

---

