#############################################################
# Generic configuration that applies to all shells
#############################################################

source ~/.shellvars
source ~/.shellfn
source ~/.shellpaths
source ~/.shellaliases
source ~/.iterm2_shell_integration.`basename $SHELL`

# Private/Proprietary shell profile (not to be checked into the public repo) :)
[ -f ~/.dotfiles_profile ] && source ~/.dotfiles_profile
[ -f ~/.profile_private ] && source ~/.profile_private
