# Dotfiles

- [Dotfiles](#dotfiles)
  - [Versions/Credits](#versionscredits)
  - [What/Why](#whatwhy)
  - [How](#how)
  - [New machine setup](#new-machine-setup)

## Versions/Credits

- V1: Originally forked from [atomantic's dotfiles][atomantic-dotfiles].
- V2: Overall setup inspired by [Zach Holman's dotfiles][holman-dotfiles].
- V2: A minimal zsh theme and some iTerm2 configuration inspired by
[Stefan Judis' iTerm2 + zsh setup][judas-iterm-zsh].
- V3: A simplified approach that relies on [brew bundle][brew-bundle] for
declarative dependencies, [mackup][mackup] for syncing config/settings, and
shell config and shell scripts for everything else.

Huge thanks to all of these people and the resources they've shared!

## What/Why

The primary goal of this repo is to make it easy to setup a new machine to be
immediately ready for development work and to provide a way to continuously
track changes to dependencies and config files.

## How

- `brew bundle` installs dependencies and applications via homebrew and the
[Mac App Store CLI][mas].
- `mackup restore` symlinks config files from a git submodule into their
target destinations (usually the `$HOME` directory).
- `zplug` (configured in `~/.zshrc`) installs and loads zsh-specific plugins.
- A few shell scripts in this repo help with initial bootstrapping and then the
upkeep of this system over time.
  - `bootstrap.sh` runs everything needed to setup a new machine, but should
  also be safe to run at any time.
  - `brew-bundle.sh` will install homebrew if missing and then runs
  `brew bundle` to install all dependencies in the `Brewfile`
  - `macos.sh` will update Mac OS settings, typically via the `defaults` CLI
  - `mackup-restore.sh` runs `mackup restore` and then also runs a script to
  allow the profile to do some supplemental linking, which is necessary to
  support profiles with different config requirements.
  - `mackup-update.sh` runs `mackup backup` to capture the latest config files,
  commits and pushes them (via a private submodule), and then updates the
  submodule ref in the root of this repo.
- The `Mackup` submodule contains everything that `mackup` syncs. For now, I'm
keeping this as a private submodule in case those files contain something
sensitive. Ideally these could all be included directly in this repo.
- The `private` submodule contains config files, scripts, and gpg keys that need
to be kept private and thus can't live in this repo. The above scripts and the
shell profile/rc files will check for similarly named files in this submodule
and source them appropriately.

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
    cd ~/.config/dotfiles && ./bin/bootstrap.sh
    ```

    **This script is idempotent and safe to run multiple times.**

1. Run `p10k configure` to configure the powerlevel10k theme and install fonts.


[atomantic-dotfiles]: https://github.com/atomantic/dotfiles
[brew-bundle]: https://github.com/Homebrew/homebrew-bundle
[github-help-generating-ssh-key]: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
[github-help-adding-ssh-key]: https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/
[holman-dotfiles]: https://github.com/holman/dotfiles
[judas-iterm-zsh]: https://www.stefanjudis.com/blog/declutter-emojify-and-prettify-your-iterm2-terminal/
[mackup]: https://github.com/lra/mackup
[mas]: https://github.com/mas-cli/mas
[p10k-fonts]: https://github.com/romkatv/powerlevel10k#manual-font-installation
