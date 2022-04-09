# Dotfiles

Several software deployments automated and custom configuration routines, mostly in the form of shell scripts: Bash, although there are some recipes with the purpose of setting Zsh up.

## Requirements

* [runr](https://github.com/stroparo/runr) - routine runner; the commands needed for this project are given in the examples below, but you could use it with whatever other project's or repository's scripts (see more in the linked paged).
* [sudo setup](#sudo-setup) - several of the recipes use sudo to do system installation and configuration.

---

## Run it!

The script is self provisioned i.e. the command below downloads the code and executes it. Just copy & paste the following block in a terminal session:

```bash
{
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/runr/raw/master/entry.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh shell apps-cli dotfiles
. "${ZDRA_HOME:-$HOME/.zdra}/zdra.sh"
. ~/.aliases-cs
}
# This is a dummy line for copying and pasting this whole block in a terminal emulator with bash.
```

---

## Specific recipes

Some recipes aggregate others, e.g. the 'shell' recipe calls all of these:

* Aliases recipe: alias
* For [SIDRA Scripting Library](https://github.com/stroparo/sidra) installation: setupsidra
* For oh-my-zsh: setupohmyzsh
* For SSH default key generation: sshkeygen sshmodes

Instead of using aggregate recipes like the 'shell' one above, you can always specify exactly which recipes you want and in what order to have them executed, in just one command:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/runr/raw/master/entry.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh alias setupsidra setupohmyzsh sshkeygen sshmodes
. "${ZDRA_HOME:-$HOME/.zdra}/zdra.sh"
. ~/.aliases-cs
# This is a dummy line for copying and pasting this whole block in a terminal emulator with bash.
```

Other examples:

```bash
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh alias
. ~/.aliases-cs
```

```bash
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh setupsidra
. "${ZDRA_HOME:-$HOME/.zdra}/zdra.sh"
```

```bash
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh sshkeygen sshmodes
```

```bash
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh setupvim
```

```bash
bash -c "$(curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh vscode
```

---

## Linux desktop package selects

Download of the runr package plus installation of custom desktop package selects for Linux distributions:

```bash
bash -c "$(curl -LSf "https://bitbucket.org/stroparo/runr/raw/master/entry.sh" \
  || curl -LSf "https://raw.githubusercontent.com/stroparo/runr/master/entry.sh")" \
  entry.sh apps-gui
# This is a dummy line for copying and pasting this whole block in a terminal emulator with bash.
```

---

## Sudo setup

Ensure sudo access by editing the sudoers file (```sudo visudo``` command).

Login as root then run this using your user instead of 'USER':

```bash
grep -q "USER" /etc/sudoers || (echo "USER ALL=(ALL) ALL" >> /etc/sudoers)
```

Same as above but removing the password restriction for each call to sudo (not recommended):

```bash
grep -q "USER" /etc/sudoers || (echo "USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers)
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
  && ./entry.sh alias apps-cli dotfiles shell
# This is a dummy line for copying and pasting this whole block in a terminal emulator with bash.
```

---

