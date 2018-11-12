#!/usr/bin/env bash

# installing the Solarized Light theme for iTerm (opening file)
open "./configs/Solarized Light.itermcolors"

# installing the Patched Solarized Dark theme for iTerm (opening file)
open "./configs/Solarized Dark Patch.itermcolors"

# hiding tab title bars
defaults write com.googlecode.iterm2 HideTab -bool true

# hiding pane titles in split panes
defaults write com.googlecode.iterm2 ShowPaneTitles -bool false

# making iTerm2 load new tabs in the same directory
/usr/libexec/PlistBuddy -c "set \"New Bookmarks\":0:\"Custom Directory\" Recycle" ~/Library/Preferences/com.googlecode.iterm2.plist

# setting fonts
defaults write com.googlecode.iterm2 "Normal Font" -string "Hack-Regular 12"
defaults write com.googlecode.iterm2 "Non Ascii Font" -string "RobotoMonoForPowerline-Regular 12"

# reading iterm settings
defaults read -app iTerm > /dev/null 2>&1
