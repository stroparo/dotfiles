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
. "${DS_HOME:-$HOME/.ds}/ds.sh"
. ~/.aliases-cs
}
# Select this whole code block, copy and paste in your terminal
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
. "${DS_HOME:-$HOME/.ds}/ds.sh"
. ~/.aliases-cs
# Select this whole code block, copy and paste in your terminal
```

Other examples:

```bash
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh alias
. ~/.aliases-cs
```

```bash
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh setupds
. "${DS_HOME:-$HOME/.ds}/ds.sh"
```

```bash
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh sshkeygen sshmodes
```

```bash
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh setupvim
```

---

## Linux desktop package selects

Download of the runr package plus installation of custom desktop package selects for Linux distributions:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/runr/raw/master/entry.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh apps-desktop
# Select this whole code block, copy and paste in your terminal
```

---

## Sudo setup

Ensure sudo access by editing the sudoers file (```sudo visudo``` command).

A handy command ready to do that edit for your user:

```bash
sudo grep -q "$USER" /etc/sudoers || (echo "$USER ALL=(ALL) ALL" | sudo tee -a /etc/sudoers)
# Select this whole code block, copy and paste in your terminal
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
# Select this whole code block, copy and paste in your terminal
```

---

