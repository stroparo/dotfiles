# Dotfiles

Custom configuration files and shell script recipes.

## Requirements

* [runr](https://github.com/stroparo/runr) - routine runner, be acquainted with it first by reading its README
* [sudo setup](#sudo-setup)

---

## Run it!

The script is self provisioned, just copy & paste the following block in a terminal session:

```bash
{
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/runr/raw/master/entry.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh shell apps alias dotfiles
dsload || . "${DS_HOME:-$HOME/.ds}/ds.sh"
}
: # Select the code above, this line being a no-op to help selecting, copying & pasting
```

---

## Specific recipes

Some recipes aggregate others, e.g. the 'shell' recipe calls all of these:

* Aliases recipe: alias
* For Daily Shells installation: setupds
* For oh-my-zsh: setupohmyzsh
* For SSH default key generation: sshkeygen sshmodes

Instead of using aggregate recipes like the 'shell' one above, you can always specify exactly which recipes you want and in what order to have them executed, in just one command:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/runr/raw/master/entry.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh alias setupds setupohmyzsh sshkeygen sshmodes
. ~/.aliases-cs
: # Select the code above, this line being a no-op to help selecting, copying & pasting
```

Othe examples:

```bash
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" entry.sh alias && . ~/.aliases-cs
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" entry.sh setupds; . "${DS_HOME:-$HOME/.ds}/ds.sh"
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" entry.sh setupohmyzsh
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" entry.sh sshkeygen sshmodes
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" entry.sh dotfiles
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" entry.sh git
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" entry.sh python
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" entry.sh setupvim
```

---

## Linux desktop package selects

Download of the runr package plus installation of custom desktop package selects for Linux distributions:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/runr/raw/master/entry.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh apps-desktop
: # Select the code above, this line being a no-op to help selecting, copying & pasting
```

---

## Sudo setup

Ensure sudo access by editing the sudoers file (```sudo visudo``` command).

A handy command ready to do that edit for your user:

```bash
sudo grep -q "$USER" /etc/sudoers || (echo "$USER ALL=(ALL) ALL" | sudo tee -a /etc/sudoers)
: # Select the code above, this line being a no-op to help selecting, copying & pasting
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
  && cd "$HOME"/.runr \
  && ./entry.sh alias apps dotfiles shell
: # Select the code above, this line being a no-op to help selecting, copying & pasting
```

---

