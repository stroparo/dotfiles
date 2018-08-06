# Dotfiles

Custom configuration files and environment setup routines.

These are custom i.e. the best way to seize them is to fork this repository and have it your own way by changing, removing or adding new stuff etcetera.

## Requirements

* [sudo setup](#sudo-setup)
* Call the ```./entry.sh``` script only from inside the dotfiles directory i.e. first ```cd /path/to/dotfiles``` (automatically done by the automated remote setup below)

---

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

After the options you might specify arguments. These are a list of recipes to be executed. These recipes are scripts filenames in either the ```installers``` or ```recipes``` directory. You might omit the ```.sh``` extension and that recipe/script will still be called correctly.

---

## Automated Remote Setup

The script has self-provisioning capabilities so you can skip downloading and setting it up by calling this command:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/dotfiles/raw/master/entry.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/entry.sh")" \
  entry.sh -f
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

Instead of the ```-f``` option you could give it ```-a``` to have only the custom aliases deployed.

One could also directly download whatever script in this repository and have its sequence executed in one fell swoop, like in this example for the custom aliases:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/dotfiles/raw/master/setupaliases.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/setupaliases.sh")"; \
  . ~/.aliases-cs
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

---

## Shell setup

For Daily Shells installation execute ```./entry.sh setupds```.

For oh-my-zsh execute ```./entry.sh setupohmyzsh```.

For SSH default key generation execute ```./entry.sh sshkeygen```.

Direct download and execution of all these shell recipes & setups:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/dotfiles/raw/master/entry.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/entry.sh")" \
  entry.sh setupds setupohmyzsh sshkeygen
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

---

## Linux desktop package selects

Download of the dotfiles package plus installation of custom desktop package selects for Debian and Enterprise Linux families:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/dotfiles/raw/master/entry.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/dotfiles/master/entry.sh")" \
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
curl -LSf -k -o ~/.dotfiles.zip "https://github.com/stroparo/dotfiles/archive/master.zip" \
  && unzip -o ~/.dotfiles.zip -d "$HOME" \
  && cd "$HOME"/dotfiles-master \
  && ./entry.sh -f
: # Ignore this; It expedited running the previous command on paste; Press ENTER ;)
```

---

