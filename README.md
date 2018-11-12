# Dotfiles

Dotfiles setup originally forked from https://github.com/atomantic/dotfiles.
Also draws inspiration from [Zach Holman's dotfiles](https://github.com/holman/dotfiles).

Huge thanks to both of those projects!

## New Computer Setup

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

1. _Work computer only:_ update the remote url for the dotfiles repos with the appropriate github hostname to properly associate it with your personal SSH key:

    ```bash
    git remote set-url origin git@github.com-ekweible:ekweible/dotfiles.git
    ```

## Tools

### `pbrewi [formula]`

TODO

### `pbrewic [cask]`

TODO

### `pbrewt [repo]`

TODO

### `pgadd [repo_url]`

Sets up a new git repository by cloning it into the appropriate workspace
(determined by the given github username) and configuring it for the given
identity. This also handles persisting the repo setup to a JSON file so that
your git workspaces can stay in sync and so that your entire git workspace can
be bootstrapped on a new machine.

### `pgaddr [remote_url]`

Adds a remote to an existing git repository. This also handles persisting the
remote to the aforementioned JSON file.

### `psync`

Bootstraps a git workspace from a JSON file made available by the private
dotfiles. This is idempotent and can be run multiple times. Keep your git
workspaces in sync across machines by committing changes to this JSON file and
re-running this script after pulling new changes.

[dashlane]: https://www.dashlane.com/download
[github-help-generating-ssh-key]: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
[github-help-adding-ssh-key]: https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/
