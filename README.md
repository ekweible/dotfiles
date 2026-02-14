# Dotfiles

My personal dotfiles managed by [chezmoi](https://chezmoi.io).

## Features

- 🏠 Single command setup for new machines
- 🔄 Easy sync across multiple machines
- 🎯 Profile-based configs (work/personal)
- 🔐 Age encryption and Keeper CLI integration for sensitive files
- 📦 Declarative package management with Brewfile
- ⚙️ Automated macOS defaults configuration
- 🐚 Modular zsh config phased loading, plugin compilation, and Starship prompt

## Quick Start

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" init --apply ekweible
```

During init, you'll be prompted to select a profile.

### Work Machine

The only new-machine setup step not covered by the above is installing the WK CLI and running `login`. That will install and symlink the remaining work-specific dotfiles.

### SSH Keys

- Personal profile machines (MacBook, Mac Studio, etc.): `~/.ssh/id_ed25519` (personal GitHub key)
- Work profile machine: `~/.ssh/evanweible-wf.id_ed25519` (work GitHub key) and `~/.ssh/id_ed25519` (personal GitHub key)
- Work profile routing: `github.com` -> work key, `github.com-personal` -> personal key

## Daily Usage

```bash
# Pull latest and apply
chezmoi update

# Edit a file
chezmoi edit ~/.zshrc

# Add a new file
chezmoi add ~/.newconfig

# Commit changes
chezmoi cd && git add . && git commit -m "Update config" && git push
```

## Structure

- Uses `.chezmoiroot` to keep dotfiles organized in `home/` subdirectory
- Profile-based templating for work/personal differences
- Brewfile with automatic installation on changes
- Age encryption and Keeper CLI integration for sensitive files (SSH config, etc.)

### Configuration Structure

Zsh configuration uses a consolidated structure for easier maintenance:
- All path configs in one file (`path.zsh`)
- All aliases in one file with profile conditionals (`aliases.zsh.tmpl`)
- All functions in one file (`functions.zsh`)
- Clear section headers within each file for easy navigation

## Requirements

- macOS (Darwin)
- Homebrew (auto-installed during init)
- age (auto-installed during init)

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
- V5: Migrate to chezmoi as it takes care of most of the automation that was
previously being managed in this repo while still supporting profile-specific
files and configs. This allowed me to consolidate to a single repo (plus one
private repo for work) and to get rid of Mackup, which I had some trouble with
over the years.

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

## License

MIT
