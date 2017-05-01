# Dotfiles

Dotfiles setup originally forked from https://github.com/atomantic/dotfiles.
Also draws inspiration from [Zach Holman's dotfiles](https://github.com/holman/dotfiles).

Huge thanks to both of those projects!


## Setup

1. Generate SSH keys:

    https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
    https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/

  - `mkdir -p ~/.ssh/ekweible/ && cd ~/.ssh/ekweible`
  - `ssh-keygen -t rsa -C "[email]"`
  - create a passphrase & write it down
  - `ssh-add ~/.ssh/ekweible/id_rsa`
  - `pbcopy < ~/.ssh/ekweible/id_rsa.pub`
  - GitHub > Account Settings > SSH Keys > Add SSH Key
  - Test it out: ssh -T git@github.com


2. Clone this dotfiles repo:

    ```bash
    $ mkdir  ~/dev
    ```

    **Personal Computer:**
    ```bash
    $ cd ~/dev && git clone git@github.com:ekweible/dotfiles.git
    ```

    **Work Computer:**
    ```bash
    $ cd ~/dev && git clone git@github.com-ekweible:ekweible/dotfiles.git
    ```

    Then configure the repo to the correct identity:

    ```bash
    $ cd dotfiles && \
      git config user.name [github_username] && \
      git config user.email [github_email] && \
      git config user.signingkey [signingkey]
    ```


3. Run the bootstrap script:

    ```bash
    $ cd ~/dev/dotfiles
    $ ./bootstrap.sh
    ```

    **This script is idempotent and safe to run multiple times.**


4. Link 1Password to Dropbox


## Tools

#### `gadd [repo_url]`

Sets up a new git repository by cloning it into the appropriate workspace
(determined by the given github username) and configuring it for the given
identity. This also handles persisting the repo setup to a JSON file so that
your git workspaces can stay in sync and so that your entire git workspace can
be bootstrapped on a new machine.

#### `gaddr [remote_url]`

Adds a remote to an existing git repository. This also handles persisting the
remote to the aforementioned JSON file.

#### `gboot`

Bootstraps a git workspace from a JSON file made available by the private
dotfiles. This is idempotent and can be run multiple times. Keep your git
workspaces in sync across machines by committing changes to this JSON file and
re-running this script after pulling new changes.
