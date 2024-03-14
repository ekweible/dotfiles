# Dotfiles

- [Dotfiles](#dotfiles)
  - [What/Why](#whatwhy)
  - [How/Details](#howdetails)
    - [Prompt](#prompt)
    - [Zsh Config](#zsh-config)
    - [Sibling Repos](#sibling-repos)
    - [Scripts](#scripts)
  - [New machine setup](#new-machine-setup)
  - [Benchmarking/Profiling](#benchmarkingprofiling)
  - [Versions/Credits](#versionscredits)

## What/Why

The primary goals of this repo are:

1. Make it easy to setup a new machine to be ready for development work
2. Provide tools and workflows for adding dependencies, apps, and so on while
also tracking those changes in this repo. This allows other workstations to stay
in sync and prevents this repo from becoming outdated.

## How/Details

- [`brew bundle`][brew-bundle] lets me list dependencies and applications in a
declarative `Brewfile` format so that they can then be installed automatically
via homebrew and the [Mac App Store CLI][mas].
- [`mackup`][mackup] symlinks config files from a git submodule into their
target destinations (usually the `$HOME` directory).
- [`zcompile-many`][zcompile-many] is a DIY alternative to zsh plugin managers
like [`zplug`][zplug] (which I previously used). It is configured in `.zshrc`
and is used to install and load zsh-specific plugins.
- A few [shell scripts](#Scripts) in this repo help with initial bootstrapping
and then the upkeep of this system over time.

### Prompt

For my shell prompt, I use [starship.rs][starship]. It's fast and the default
theme and integration with the tools and languages I use is plenty sufficient.

### Zsh Config

The `.zshrc` is broken into phases:

1. Path config - loads all `path.zsh` files found in this repo.
1. General config - loads the remaining `*.zsh` files found in this repo,
excluding `completion.zsh` files (that happens later).
1. Install zsh plugins - installs and compiles zsh plugins.
1. Enable zsh completion.
1. Load zsh plugins.
1. Completion config - loads all `completion.zsh` files found in this repo.
1. Finally, initializes the shell prompt.

Finding and automatically loading `.zsh` files from this repo in a particular
order allows us to organize zsh config more sensibly rather than putting
everything in `.zshrc`. Most of the top-level directories in this repo contain
`.zsh` files that provide necessary zsh configuration for those languages,
tools, etc.

### Sibling Repos

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

### Scripts

- `,asdf-bootstrap.sh` installs all of the asdf plugins that I use along
with the latest version of each of the languages provided by these plugins. Note
that this depends on asdf already being installed.
- `,backup.sh` runs `mackup backup` to capture the latest config
files, then commits and pushes them (via the private submodule), and then
updates the submodule ref in the root of this repo.
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
- `,link.sh` symlinks shell config files from these dotfiles repos into the home and config directories. Used by the `,bootstrap.sh` script.
- `,macos.sh` will update Mac OS settings and user preferences.
- `,restore.sh` runs `mackup restore` which links all of the
config files from the `Mackup/` submodule into the expected location (typically
the HOME directory).
  - If a `restore.sh` script exists in the `private/` submodule, it is
  sourced after running `mackup restore`. This allows for profile-specific
  linking of configuration files. For example, you may have multiple profiles
  each with a unique `.pip/pip.conf`.

## New machine setup

1. Sign in to Chrome and GitHub

1. Generate SSH keys. Follow these instructions, but name the files based on the
GitHub username instead of the defaults.

    [github-help-generating-ssh-key]

    [github-help-adding-ssh-key]

    > Note: Be sure to create a `~/.ssh/config` that uses this SSH key with the
    > `github.com` host. The bootstrap script below will then override it.

1. Clone the dotfiles repo:

    ```bash
    mkdir ~/.config; cd ~/.config && git clone git@github.com:ekweible/dotfiles.git && cd dotfiles
    ```

1. Clone the two sibling dotfiles repos (private config and the applicable profile config for this machine).

1. Run the bootstrap script:

    ```bash
    ./bin/,bootstrap.sh
    ```

    **This script is idempotent and safe to run multiple times.**

1. See private repo README for configuring Internet Accounts.

## Benchmarking/Profiling

- Uncomment the `zprof` lines at the top and bottom of `.zshrc` and then load a
new shell to see profiling information.
- Use [zsh-bench][zsh-bench].

## Versions/Credits

- V1: Originally forked from [atomantic's dotfiles][atomantic-dotfiles].
- V2: Overall setup inspired by [Zach Holman's dotfiles][holman-dotfiles].
- V2: A minimal zsh theme and some iTerm2 configuration inspired by
[Stefan Judis' iTerm2 + zsh setup][judas-iterm-zsh].
- V3: A simplified approach that relies on [brew bundle][brew-bundle] for
declarative dependencies, [mackup][mackup] for syncing config/settings, and
shell config and shell scripts for everything else.
- V4: To improve shell startup time, switched from zplug to custom zsh plugin
management (thanks to [zsh-bench][zsh-bench]!) and switched to
[starship.rs][starship] for the shell prompt. To improve organization, switched
to a module-based layout with directories containing zsh config for each thing
(like a language or tool) that gets auto-loaded by `.zshrc`.

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
[starship]: https://starship.rs/
[zcompile-many]: https://github.com/romkatv/zsh-bench/tree/master/configs/diy%2B%2B/skel
[zsh-bench]: https://github.com/romkatv/zsh-bench
[zplug]: https://github.com/zplug/zplug
