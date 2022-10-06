# Dotfiles

- [Dotfiles](#dotfiles)
  - [What/Why](#whatwhy)
  - [How](#how)
    - [Submodules](#submodules)
  - [Scripts](#scripts)
    - [Dotfiles Bootstrapping & Upkeep](#dotfiles-bootstrapping--upkeep)
  - [New machine setup](#new-machine-setup)
  - [Versions/Credits](#versionscredits)

## What/Why

The primary goals of this repo are:

1. Make it easy to setup a new machine to be ready for development work
2. Provide tools and workflows for adding dependencies, apps, and so on while
also tracking those changes in this repo. This allows other workstations to stay
in sync and prevents this repo from becoming outdated.

## How

- [`brew bundle`][brew-bundle] lets me list dependencies and applications in a
declarative `Brewfile` format so that they can then be installed automatically
via homebrew and the [Mac App Store CLI][mas].
- [`mackup`][mackup] symlinks config files from a git submodule into their
target destinations (usually the `$HOME` directory).
- [`zplug`][zplug] (configured in `~/.zshrc`) installs and loads zsh-specific
plugins.
- A few [shell scripts](#Scripts) in this repo help with initial bootstrapping
and then the upkeep of this system over time.

### Submodules

- The `Mackup` submodule contains everything that `mackup` syncs. For now, I'm
keeping this as a private submodule in case those files contain something
sensitive. Ideally these could all be included directly in this repo.
- The `private` submodule contains config files, scripts, and gpg keys that need
to be kept private and thus can't live in this repo. The scripts below and the
shell profile/rc files will check for similarly named files in this submodule
and source them appropriately.

For both of these, I have a shell script that I run periodically that commits
and pushes any changes within these submodules and then updates the submodule
revisions in this parent repo.

## Scripts

### Dotfiles Bootstrapping & Upkeep

- `,asdf-bootstrap.sh` installs all of the asdf plugins that I use along
with the latest version of each of the languages provided by these plugins. Note
that this depends on asdf already being installed.
- `,bootstrap.sh` runs everything needed to setup a new machine, but
should also be safe to run at any time.
  - If a `bootstrap.sh` script exists in the `private/` submodule, it will be
  sourced last.
- `,brew-bundle.sh` installs homebrew if missing and then runs
`brew bundle` to install all dependencies in the `Brewfile`
  - If a `Brewfile` exists in the `private/` submodule, it will be used to run
  `brew bundle`, as well.
- `,brew-upgrade.sh` runs `,brew-bundle.sh` to ensure that Brew
and everything in the `Brewfile`s are installed. Then upgrades all Brew formulae
and casks. Finally updates the `Brewfile.lock.json`s.
- `,mackup-restore.sh` runs `mackup restore` which links all of the
config files from the `Mackup/` submodule into the expected location (typically
the HOME directory).
  - If a `mackup-restore.sh` script exists in the `private/` submodule, it is
  sourced after running `mackup restore`. This allows for profile-specific
  linking of configuration files. For example, you may have multiple profiles
  each with a unique `.pip/pip.conf`.
- `,mackup-update.sh` runs `mackup backup` to capture the latest config
files, then commits and pushes them (via the private submodule), and then
updates the submodule ref in the root of this repo.
- `,macos.sh` will update Mac OS settings and user preferences.
- `,private-update.sh` commits and pushes any updates in the `private/`
submodule and then updates the submodule ref in the root of this repo.

## New machine setup

1. Sign in to Chrome and GitHub

1. Generate SSH keys. Follow these instructions, but name the files based on the
GitHub username instead of the defaults.

    [github-help-generating-ssh-key]

    [github-help-adding-ssh-key]

1. Clone the dotfiles repo:

    ```bash
    mkdir ~/.config; cd ~/.config && git clone --recurse-submodules git@github.com:ekweible/dotfiles.git && cd dotfiles
    ```

1. Select a profile by updating the `branch` of the private submodule

1. Run the bootstrap script:

    ```bash
    ./bin/,bootstrap.sh
    ```

    **This script is idempotent and safe to run multiple times.**

1. Run `p10k configure` to configure the powerlevel10k theme and install fonts.

1. See private repo README for configuring Internet Accounts.

## Versions/Credits

- V1: Originally forked from [atomantic's dotfiles][atomantic-dotfiles].
- V2: Overall setup inspired by [Zach Holman's dotfiles][holman-dotfiles].
- V2: A minimal zsh theme and some iTerm2 configuration inspired by
[Stefan Judis' iTerm2 + zsh setup][judas-iterm-zsh].
- V3: A simplified approach that relies on [brew bundle][brew-bundle] for
declarative dependencies, [mackup][mackup] for syncing config/settings, and
shell config and shell scripts for everything else.

Huge thanks to all of these people and the resources they've shared!

[atomantic-dotfiles]: https://github.com/atomantic/dotfiles
[brew-bundle]: https://github.com/Homebrew/homebrew-bundle
[github-help-generating-ssh-key]: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
[github-help-adding-ssh-key]: https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/
[holman-dotfiles]: https://github.com/holman/dotfiles
[judas-iterm-zsh]: https://www.stefanjudis.com/blog/declutter-emojify-and-prettify-your-iterm2-terminal/
[mackup]: https://github.com/lra/mackup
[mas]: https://github.com/mas-cli/mas
[p10k-fonts]: https://github.com/romkatv/powerlevel10k#manual-font-installation
[zplug]: https://github.com/zplug/zplug
