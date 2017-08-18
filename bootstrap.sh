#!/usr/bin/env bash

# Include library helpers for colorized echo and require_brew, etc
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh
source ./lib_sh/requirers.sh
source ./lib_sh/runner.sh

export DOTFILES="$HOME/dev/dotfiles"
export HOMEDIR="$DOTFILES/homedir"

# Ask for the administrator password upfront
bot "Enter your sudo password"
sudo -v

# Keep-alive: update existing sudo time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# -----------------------------------------------------------------------------
# Profile Selection
# -----------------------------------------------------------------------------
group "Selecting a profile"

while [[ ! "$profile" ]]
do
  response=$(prompt "Select a profile to bootstrap: [personal | workiva]")

  if [[ "$response" = "personal" ]]
  then
    profile="personal"
  elif [[ "$response" = "workiva" ]]
  then
    profile="workiva"
  fi
done

export DOTFILES_PRIVATE="$HOME/dev/dotfiles_private/$profile"
export HOMEDIR_PRIVATE="$DOTFILES_PRIVATE/homedir"
source "$DOTFILES_PRIVATE"/profile.sh

sed -e "s/DOTFILES_PROFILE/$profile/g" \
    ./templates/.shellvars_private > ./homedir/.shellvars_private

running "$profile profile selected"
ok

running "generating .gitconfig"
sed -e "s/GIT_AUTHOR_NAME/$BOOTSTRAP_GIT_AUTHOR_NAME/g" \
    -e "s/GIT_AUTHOR_EMAIL/$BOOTSTRAP_GIT_AUTHOR_EMAIL/g" \
    ./templates/.gitconfig > ./homedir/.gitconfig
ok

# -----------------------------------------------------------------------------
# Brew & Brew Cask
# -----------------------------------------------------------------------------
group "Setting up brew and brew cask"

brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]
then
  runing "installing homebrew"
  run_command "ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\""

  if [[ $? != 0 ]]
  then
    error "unable to install homebrew, script $0 abort!"
    exit 2
  fi
else
  running "homebrew already installed"
  ok

  # Make sure we’re using the latest Homebrew
  running "updating homebrew"
  run_command "brew update"

  response=$(prompt "run brew upgrade? [y|N]")
  if [[ $response =~ ^(y|yes|Y) ]]
  then
    # Upgrade any already-installed formulae
    running "upgrading brew packages"
    run_command "brew upgrade"
  fi
fi

output=$(brew tap | grep cask)
if [[ $? != 0 ]]
then
  running "installing brew-cask"
  require_brew caskroom/cask/brew-cask
else
  running "brew-cask already installed"
  ok
fi

running "tapping caskroom"
run_command "brew tap caskroom/versions"


# -----------------------------------------------------------------------------
# Dart
# -----------------------------------------------------------------------------
group "Setting up Dart"

require_brew dart


# -----------------------------------------------------------------------------
# Node Version Manager
# -----------------------------------------------------------------------------
group "Setting up NVM"

# node version manager
require_brew nvm

# nvm
require_nvm stable


# -----------------------------------------------------------------------------
# Python
# -----------------------------------------------------------------------------
group "Setting up python"

# replace Mac python with brew python
require_brew python

# install pip if necessary
if [ ! $(which pip) ]
then
  running "downloading and installing pip"
  run_command curl -O https://bootstrap.pypa.io/get-pip.py && sudo python2.7 get-pip.py && rm get-pip.py
fi

# upgrade pip
running "upgrading pip"
run_command pip install -U pip

# install virtualenvwrapper
if [ ! -f /usr/local/bin/virtualenvwrapper.sh ]
then
  running "installing virtualenvwrapper"
  run_command sudo -A pip install virtualenvwrapper
fi


# -----------------------------------------------------------------------------
# Java
# -----------------------------------------------------------------------------
group "Setting up Java"

require_cask java
require_brew ant


# -----------------------------------------------------------------------------
# Brew Packages
# -----------------------------------------------------------------------------
group "Installing brew packages"

require_brew coreutils
require_brew git
require_brew glide
require_brew gnatsd
require_brew gpg2
require_brew lcov
require_brew sassc
require_brew zsh


# -----------------------------------------------------------------------------
# Brew Casks
# -----------------------------------------------------------------------------
group "Installing brew casked applications"

require_cask 1password
# require_cask alfred  # need to upgrade to v3
require_cask bartender
require_cask bitbar
require_cask caffeine
require_cask dropbox
require_cask evernote
require_cask filezilla
require_cask firefox
require_cask flux
require_cask google-chrome
require_cask google-drive
require_cask google-photos-backup
require_cask hipchat
require_cask iterm2
require_cask macdown
require_cask mamp
require_cask recordit
require_cask sourcetree
# require_cask spotify  # .dmg installation is failing currently
require_cask viscosity
require_cask visual-studio-code



# -----------------------------------------------------------------------------
# Zsh Shell
# -----------------------------------------------------------------------------
group "Configuring Zsh shell"

# set zsh as the user login shell
CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
if [[ "$CURRENTSHELL" != "/usr/local/bin/zsh" ]]
then
  bot "setting latest homebrew zsh (/usr/local/bin/zsh) as your shell (password required)"
  # sudo bash -c 'echo "/usr/local/bin/zsh" >> /etc/shells'
  # chsh -s /usr/local/bin/zsh
  # sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/zsh
  sudo dscl . change /users/$USER UserShell /bin/bash $(which zsh)
  ok
else
  running "shell is already set to zsh"
  ok
fi

if [[ ! -d "./oh-my-zsh/custom/themes/powerlevel9k" ]]
then
  running "installing powerlevel9k oh-my-zsh theme"
  run_command "git clone https://github.com/bhilburn/powerlevel9k.git oh-my-zsh/custom/themes/powerlevel9k"
else
  response=$(prompt "Update the powerlevel9k oh-my-zsh theme? [y|N]")
  if [[ $response =~ ^(y|yes|Y) ]]
  then
    running "updating powerlevel9k oh-my-zsh theme"
    cd $DOTFILES/oh-my-zsh/custom/themes/powerlevel9k
    run_command "git fetch origin && git pull"
    cd $DOTFILES
  fi
fi


# -----------------------------------------------------------------------------
# Symlinking Dotfiles
# -----------------------------------------------------------------------------
group "Symlinking dotfiles"

response=$(prompt "Do you want to link all dotfiles? [Y|n]")

if [[ $response =~ ^(no|n|N) ]]
then
  running "skipping symlinking dotfiles"
  ok
else
  running "symlinking dotfiles"
  echo -e ""

  overwrite_all=false backup_all=false skip_all=false

  # symlink all dotfiles in homedir/
  for src in $(find "$HOMEDIR" -mindepth 1 -maxdepth 1 -type f)
  do
    dst="$HOME/$(basename $src)"
    link_file "$src" "$dst"
  done

  # symlink all dotfiles that require a parent dir in homedir/
  for dir in $(find "$HOMEDIR" -mindepth 1 -maxdepth 1 -type d)
  do
    parent_dir="`dirname \"$dir\"`"
    dst_dir="$HOME/`basename \"$dir\"`"

    for src in $(find "$dir" -mindepth 1 -maxdepth 1 -type f)
    do
      dst="$dst_dir/$(basename $src)"

      if ! [ -d "$dst_dir" ]
      then
        mkdir "$dst_dir"
      fi

      link_file "$src" "$dst"
    done
  done

  # symlink all private dotfiles from the path defined by the selected profile
  for src in $(find "$HOMEDIR_PRIVATE" -mindepth 1 -maxdepth 1 -type f)
  do
    dst="$HOME/$(basename $src)"
    link_file "$src" "$dst"
  done

  # symlink all private dotfiles that require a parent dir
  for dir in $(find "$HOMEDIR_PRIVATE" -mindepth 1 -maxdepth 1 -type d)
  do
    parent_dir="`dirname \"$dir\"`"
    dst_dir="$HOME/`basename \"$dir\"`"

    for src in $(find "$dir" -mindepth 1 -maxdepth 1 -type f)
    do
      dst="$dst_dir/$(basename $src)"

      if ! [ -d "$dst_dir" ]
      then
        mkdir "$dst_dir"
      fi

      link_file "$src" "$dst"
    done
  done
fi


# -----------------------------------------------------------------------------
# Private Dotfiles Bootstrap
# -----------------------------------------------------------------------------
group "Running private dotfiles bootstrap script (profile: $profile)"

source $DOTFILES_PRIVATE/bootstrap.sh


# -----------------------------------------------------------------------------
# Fonts
# -----------------------------------------------------------------------------
group "Fonts"

running "installing fonts"
run_command "./fonts/install.sh"

running "tapping cask fonts"
run_command "brew tap caskroom/fonts"

require_cask font-fontawesome
require_cask font-awesome-terminal-fonts
require_cask font-hack
require_cask font-inconsolata-dz-for-powerline
require_cask font-inconsolata-g-for-powerline
require_cask font-inconsolata-for-powerline
require_cask font-roboto-mono
require_cask font-roboto-mono-for-powerline
require_cask font-source-code-pro


# -----------------------------------------------------------------------------
# iTerm2
# -----------------------------------------------------------------------------
group "Configuring iTerm2"

running "installing the Solarized Light theme for iTerm (opening file)"
open "./configs/Solarized Light.itermcolors"
ok

running "installing the Patched Solarized Dark theme for iTerm (opening file)"
open "./configs/Solarized Dark Patch.itermcolors"
ok

running "hiding tab title bars"
defaults write com.googlecode.iterm2 HideTab -bool true
ok

running "hiding pane titles in split panes"
defaults write com.googlecode.iterm2 ShowPaneTitles -bool false
ok

running "making iTerm2 load new tabs in the same directory"
/usr/libexec/PlistBuddy -c "set \"New Bookmarks\":0:\"Custom Directory\" Recycle" ~/Library/Preferences/com.googlecode.iterm2.plist
ok

running "setting fonts"
defaults write com.googlecode.iterm2 "Normal Font" -string "Hack-Regular 12"
defaults write com.googlecode.iterm2 "Non Ascii Font" -string "RobotoMonoForPowerline-Regular 12"
ok

running "reading iterm settings"
defaults read -app iTerm > /dev/null 2>&1
ok


# -----------------------------------------------------------------------------
# System Settings
# -----------------------------------------------------------------------------
group "Configuring system settings"

running "stop iTunes from responding to the keyboard media keys"
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null
ok

running "disable the sound effects on boot"
sudo nvram SystemAudioVolume=" "
ok

running "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 10
ok

running "Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
ok

running "Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"
ok

running "Show path bar"
defaults write com.apple.finder ShowPathbar -bool true
ok

running "Show the ~/Library folder"
chflags nohidden ~/Library
ok

running "Set the icon size of Dock items to 36 pixels"
defaults write com.apple.dock tilesize -int 36
ok

running "Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true
ok

running "Don’t show Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool true
ok

running "Don’t animate opening applications from the Dock"
defaults write com.apple.dock launchanim -bool false
ok

running "Disable automatic emoji substitution (i.e. use plain text smileys)"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false
ok

running "Disable smart quotes as it’s annoying for messages that contain code"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false
ok

running "Disable continuous spell checking"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false
ok


# -----------------------------------------------------------------------------
# Git Repositories
# -----------------------------------------------------------------------------
group "Bootstrapping git repositories"

response=$(prompt "Do you want to bootstrap your git repositories? [Y|n]")

if [[ $response =~ ^(no|n|N) ]]
then
  running "skipping git bootstrap"
  ok
else
  source $DOTFILES_PRIVATE/bin/gboot
fi


# -----------------------------------------------------------------------------
# Non-casked Applications
# -----------------------------------------------------------------------------
group "Opening download pages for non-casked applications"

response=$(prompt "Do you want to open these download pages now? [Y|n]")

if [[ $response =~ ^(no|n|N) ]]
then
  running "skipping opening download pages"
  ok
else
  running "opening"

  # BetterSnapTool
  open https://itunes.apple.com/us/app/bettersnaptool/id417375580
  # Chrome Canary
  open https://www.google.com/chrome/browser/canary.html
  # Todoist
  open https://todoist.com/mac

  ok
fi


# -----------------------------------------------------------------------------
# DONE
# -----------------------------------------------------------------------------

bot "Done!"
