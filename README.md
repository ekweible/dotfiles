# Dotfiles

- [Credit](#credit)
- [What/why?](#whatwhy)
- [How](#how)
- [Tools](#tools)
- [New machine setup](#new-machine-setup)

## Credit

Dotfiles setup originally forked from [atomantic's dotfiles][atomantic-dotfiles].
Also draws inspiration from [Zach Holman's dotfiles][holman-dotfiles].
And more recently, a minimal zsh theme and some iTerm2 configuration inspired by
[Stefan Judis' iTerm2 + zsh setup][judas-iterm-zsh].

Huge thanks to all of these people and the resources they've shared!

## What/Why

The primary goal of this repo is to make it easy to setup a new machine to be
immediately ready for development work.

This is partly accomplished via a bootstrap script that installs some core
dependencies and links dotfiles from this repo into the `$HOME` directory. This
works well for dotfiles due to the nature of symlinks – if you need to make
changes, you do so in the locally cloned git repo and commit them. But for other
things like your git workspace, system dependencies, and applications, the
bootstrap script becomes outdated as soon as you add something new.

To solve this problem, this repo includes several command-line tools that wrap
`brew tap`, `brew install`, `brew cask install`, `git clone`, and `git remote add`. These
tools will perform the intended task, but will also add the new dependency to
a local JSON file that is then committed and pushed automatically. Then, another
command-line tool provided by this repo makes it easy to sync all brew formulae,
brew casked apps, and your git workspace from the latest JSON representation.

While this may seem overkill, it is especially useful in two scenarios:

- In the event of a new machine setup (or old machine crash).

    If you're using the dotfiles repo to store your dotfiles and if you're
    always using these command-line tools to install new system dependencies,
    your "profile" will always be up-to-date and ready to be used to bootstrap a
    new machine.

- When you have more than one development machine.

    You may have a work and a personal machine. While you likely don't work on
    the same things across these two machines, the _way_ you work is likely very
    similar. And the way you work is largely shaped by the dependencies and
    applications installed on your machine.

    The dotfiles setup and the command-line tools in this repo are designed to
    support multiple profiles out of the box.

## How

All of the tooling and bootstrap logic is fairly generic and most of the
dotfiles don't actually contain any secrets, so they are okay to live in a
public repo. But some information required for setting up a machine should be
private (e.g. GPG keys, certain environment variables, names of cloned repos,
etc). So a dual-repo approach is taken to allow the majority of the setup to
exist as OSS (and hopefully benefit from the community):

- `dotfiles_private`

    Contains the JSON representation of the profiles (git workspaces, brew
    formulae and casks, ssh config, gpg signing key), any dotfiles that need
    to remain private, and GPG keys.

- `dotfiles`

    This repo. Contains the bootstrap script, most of the dotfiles, the
    oh-my-zsh submodule and configuration, and the supporting command-line
    tools.

It is assumed that these repos will be cloned as siblings in the `~/dev/`
directory.

### `dotfiles_private` structure

TODO

### `dotfiles` structure

- `bin/`

    This directory is added to your path, meaning that any executable in this
    directory will be available in your path.

    The following executables are included:

  - `pbrewi` - wrapper for `brew install <formula>`
  - `pbrewic` - wrapper for `brew cask install <cask>`
  - `pbrewt` - wrapper for `brew tap <repo>`
  - `pbrewu` - wrapper for `brew uninstall <formula>` _(TODO)_
  - `pbrewuc` - wrapper for `brew cask uninstall <cask>` _(TODO)_
  - `pbrewut` - wrapper for `brew untap <repo>` _(TODO)_
  - `pgaddr` - wrapper for `git remote add <name> <url>`
  - `pgclone` - wrapper for `git clone <repo> <url>`
  - `psync` - tool for syncing all brew items and git workspace for current
    profile

- `configs/`

    Contains color presets for iTerm2. These are imported automatically during
    bootstrap. _TODO: is this still needed?_

- `fonts/`

    Includes the `SymbolNeu` font used in the powerline9k oh-my-zsh theme as
    well as an `install.sh` script that loads them into the appropriate system
    font folder. This script is run during bootstrap.

- `homedir/`

    Every file in this directory is linked to your home directory (`~/`). These
    are the titular dotfiles. Most of them exist and can be edited directly in
    this directory, but a few are generated.

  - `.gnupg/gpg-agent.conf` - configuration for GPG agent
  - `.ssh/config` - **generated** during bootstrap from the git workspaces
    included in the selected dotfiles profile
  - `.gitconfig` - **generated** from the `templates/.gitconfig` file; the
    primary git user name and email are read from the selected dotfiles profile
    and injected into this file
  - `.iterm2_shell_integration.zsh` - needed to use zsh and iTerm2 together
  - `.profile` - generic configuration that applies to all shells
  - `.screenrc` - configures the terminal window and caption
  - `.shellaliases` - self-explanatory
  - `.shellfn` - utility shell functions
  - `.shellpaths` - anything that needs to be added to the path
  - `.shellvars` - environment variables
  - `.shellvars_private` - **generated** from the `templates/.shellvars_private`
    file; exports the following:
    - `DOTFILES_PROFILE` - currently selected dotfiles profile
    - `DOTFILES_PRIVATE` - path to this profile directory within the
      `dotfiles_private` repo
    - `HOMEDIR_PRIVATE` - path to the `homedir/` directory within the currently
      selected dotfiles profile (i.e. the private version of this directory)

      Additionally, this file will source a `.shellvars` file from the private
      homedir if one exists.
  - `.zprofile`, `.zshenv` - zsh-specific shell config
  - `.zshrc` - configuration of zsh itself (e.g. zsh theme, plugins, etc)

- `iterm2_profile/` - serialized iTerm2 preferences (auto-updated when iTerm2
  exits). iTerm2 should be configured to load preferences from this folder.

- `pydotfiles/` - (almost) all of the bootstrap and command-line tools are
  written in python and are housed here. The shell script entry points for these
  tools handle activating a python virtualenv so that the necessary dependencies
  are installed and available (without polluting the global env).

- `scripts/` - just a couple of scripts that are run during bootstrap – they were
  easier to do via a shell script rather than running the commands directly via
  python subprocesses.

- `submodules/` - git submodules used by this dotfiles setup:
  - [`oh-my-zsh/` - zsh shell](https://github.com/robbyrussell/oh-my-zsh)
  - [`zsh-autosuggestions/` - zsh plugin](https://git@github.com/zsh-users/zsh-autosuggestions)
  - [`zsh-syntax-highlighting/` - zsh plugin](https://git@github.com/zsh-users/zsh-syntax-highlighting)
  - [`powerlevel9k/` - oh-my-zsh theme](https://github.com/bhilburn/powerlevel9k)

- `templates/` - templates used to generate a couple dotfiles using information
  that is not known until a dotfiles profile is selected.

- `bootstrap.sh` - the entry point for bootstrapping a new machine (or
  refreshing a machine setup after making changes to dotfiles setup – it's safe
  to run multiple times).

## Tools

### `./bootstrap.sh`

This shell script first installs a few core system requirements:

- homebrew for Mac
- python3 from brew (replaces the Mac python)
- virtualenvwrapper

Then, it will create a virtualenv for the python tools in `pydotfiles/`–if one
doesn't already exist–and activate it before installing all necessary
dependencies via pip.

At this point, the shell script hands execution off to the python bootstrap
tool. The rest of the bootstrap process handles:

- selecting a dotfiles profile from available profiles
- generating dotfiles from templates as necessary
- symlinking dotfiles to the home directory (`~/`)
- initializing and updating git submodules used by this dotfiles setup
- updating brew, tapping brew repos, installing/upgrading brew formulae/casks
- importing GPG keys
- creating and syncing git workspaces
- configuring some iTerm2 and system settings
- installing fonts
- changing the user shell to `zsh`
- opening download links for all non-casked applications

_TODO: insert gif_

### `pbrewi <formula>`

Wrapper for `brew install <formula>`.

Asks you to select which of the available dotfiles profiles the given formula
should be associated with (multiple profiles can be selected). Adds the formula
to `profiles.json` under the selected dotfiles profiles configs. Commits and
pushes the change when complete.

_TODO: insert gif_

### `pbrewic <cask>`

Wrapper for `brew cask install <cask>`.

Asks you to select which of the available dotfiles profiles the given cask
should be associated with (multiple profiles can be selected). Adds the cask to `profiles.json` under the selected dotfiles profiles configs. Commits and pushes
the change when complete.

_TODO: insert gif_

### `pbrewt <repo>`

Wrapper for `brew tap <repo>`.

Asks you to select which of the available dotfiles profiles the given repo
should be associated with (multiple profiles can be selected). Adds the repo to `profiles.json` under the selected dotifles profiles configs. Commits and pushes
the change when complete.

_TODO: insert gif_

### `pbrewu <formula>`

Wrapper for `brew uninstall <formula>`.

_TODO: insert gif_

### `pbrewuc <cask>`

Wrapper for `brew cask uninstall <cask>`.

_TODO: insert gif_

### `pbrewut <repo>`

Wrapper for `brew untap <repo>`.

_TODO: insert gif_

### `pgclone <url>`

Wrapper for `git clone <url>`.

Sets up a new git repository by cloning it into the selected workspace and
configuring it for the identity (`user.name`, `user.email`, `user.signingkey`)
in that workspace. Adds the repo URL and dirname to `profiles.json` under the
selected git workspace config. Commits and pushes the change when complete.

_TODO: insert gif_

### `pgaddr <url>`

Wrapper for `git remote add <name> <url>`.

Must be run in an existing git repo. Adds and fetches a git remote. Adds the
remote URL and name to `profiles.json` under the current repo's config. Commits
and pushes the change when complete.

_TODO: insert gif_

### `psync`

Syncs your machine with the latest profile representation:

- Pulls latest changes in `dotfiles_private` repo

- Installs missing brew formulae, casks, and taps

- Upgrades existing brew formulae, casks, and taps

- Installs missing git repos

- Adds missing git remotes

_TODO: insert gif_

## New machine setup

1. [Configure system preferences (see below)](#system-preferences)

1. [Install Dashlane password manager][dashlane]

1. Sign in to Chrome and GitHub

1. Generate SSH keys:

    [github-help-generating-ssh-key]

    [github-help-adding-ssh-key]

    - `mkdir -p ~/.ssh/ekweible/ && cd ~/.ssh/ekweible`
    - `ssh-keygen -t rsa -C "[email]"`
    - save it here instead of the default ssh location: `./id_rsa`
    - create a passphrase & write it down
    - `ssh-add ~/.ssh/ekweible/id_rsa`
    - `pbcopy < ~/.ssh/ekweible/id_rsa.pub`
    - GitHub > Account Settings > SSH Keys > Add SSH Key
    - Test it out: `ssh -T git@github.com`

    Do the same for additional profiles.

1. Clone the dotfiles repo:

    ```bash
    mkdir ~/dev && cd ~/dev && git clone --recurse-submodules git@github.com:ekweible/dotfiles.git && cd ~/dev/dotfiles
    ```

    > Don't forget to clone your private dotfiles repo, too.

1. Configure the dotfiles repo(s) to the correct identity:

    ```bash
    cd dotfiles && git config user.name [github_username] && git config user.email [github_email] && git config user.signingkey [signingkey]
    ```

1. Run the bootstrap script:

    ```bash
    ~/dev/dotfiles/bootstrap.sh
    ```

    **This script is idempotent and safe to run multiple times.**

1. Configure iterm2 preferences:

    - Appearance > Theme > "Dark"
    - Profiles > Colors > Color Presets > "Solarized Dark Patch"
    - Profiles > Text
      - Font > "13pt Hack Regular"
      - Enable "Use a different font for non-ASCII text"
      - Non-ASCII Font >  "13pt Roboto Mono for Powerline"

1. _Work machine only:_ update the remote url for the dotfiles repos with the appropriate github hostname to properly associate it with your personal SSH key:

    ```bash
    git remote set-url origin git@github.com-ekweible:ekweible/dotfiles.git
    git remote set-url origin git@github.com-ekweible:ekweible/dotfiles_private.git
    ```

### System Preferences

TODO

[atomantic-dotfiles]: https://github.com/atomantic/dotfiles
[holman-dotfiles]: https://github.com/holman/dotfiles
[judas-iterm-zsh]: https://www.stefanjudis.com/blog/declutter-emojify-and-prettify-your-iterm2-terminal/
[dashlane]: https://www.dashlane.com/download
[github-help-generating-ssh-key]: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
[github-help-adding-ssh-key]: https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/
