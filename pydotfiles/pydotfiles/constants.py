from os import environ


class ENV:
    DOTFILES_PROFILE = 'DOTFILES_PROFILE'


class PATHS:
    HOME = environ['HOME']
    DOTFILES = '%s/dev/dotfiles' % HOME
    DOTFILES_PRIVATE = '%s/dev/dotfiles_private' % HOME
    SSH = '%s/.ssh' % HOME
    DEV_WORKSPACE = '%s/dev' % HOME

    PROFILES_JSON = '%s/profiles.json' % DOTFILES_PRIVATE

    HOMEDIR = '%s/homedir' % DOTFILES
    HOMEDIR_GITCONFIG = '%s/.gitconfig' % HOMEDIR
    HOMEDIR_SHELLVARS_PRIVATE = '%s/.shellvars_private' % HOMEDIR
    HOMEDIR_SSH = '%s/.ssh' % HOMEDIR
    HOMEDIR_SSH_CONFIG = '%s/config' % HOMEDIR_SSH

    TEMPLATES = '%s/templates' % DOTFILES
    TEMPLATES_GITCONFIG = '%s/.gitconfig' % TEMPLATES
    TEMPLATES_SHELLVARS_PRIVATE = '%s/.shellvars_private' % TEMPLATES

    POWERLEVEL9K_THEME = '%s/oh-my-zsh/custom/themes/powerlevel9k' % DOTFILES

    FONTS_INSTALL_SCRIPT = '%s/fonts/install.sh' % DOTFILES

    SCRIPTS = '%s/scripts' % DOTFILES
    SCRIPTS_CONFIGURE_ITERM2 = '%s/configure_iterm2.sh' % SCRIPTS
    SCRIPTS_CONFIGURE_SYSTEM_SETTINGS = '%s/configure_system_settings.sh' % SCRIPTS
    SCRIPTS_INSTALL_NVM = '%s/install_nvm.sh' % SCRIPTS
