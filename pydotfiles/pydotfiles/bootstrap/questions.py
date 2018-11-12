from clint.textui import colored, puts, puts_err
from PyInquirer import prompt

from pydotfiles.bootstrap.constants import JOBS
from pydotfiles.common import profiles


def jobs_filter(answers):
    answer_map = {
        'Change shell to zsh': JOBS.CHANGE_SHELL,
        'Configure iterm2 and system settings': JOBS.CONFIGURE_SETTINGS,
        'Import GPG keys': JOBS.IMPORT_GPG_KEYS,
        'Install fonts': JOBS.INSTALL_FONTS,
        'Generate & link all dotfiles': JOBS.LINK_DOTFILES,
        'Open non-casked app download pages': JOBS.OPEN_NON_CASKED_APPS,
        'Sync git repositories': JOBS.SYNC_GIT,
        'Install/update the powerlevel9k oh-my-zsh theme': JOBS.UPDATE_ZSH_THEME,
        'Install/upgrade brew casks': JOBS.UPGRADE_BREW_CASKS,
        'Install/upgrade brew packages': JOBS.UPGRADE_BREW_PACKAGES,
    }
    return [answer_map.get(answer) for answer in answers]


def ask_bootstrap_questions():
    profile_names = list(profiles.read_names())
    current_profile_name = profiles.get_current_name(exit_if_not_set=False)

    if current_profile_name:
        def sort_current_profile_first(a=None, b=None):
            if a == current_profile_name:
                return -1
            if b == current_profile_name:
                return 1
            return 0
        profile_names.sort(key=sort_current_profile_first)

    puts('\n')
    answers = prompt([
        {
            'name': 'jobs',
            'type': 'checkbox',
            'message': 'What would you like to do?',
            'choices': [
                {
                    'name': 'Change shell to zsh',
                    'checked': True,
                },
                {
                    'name': 'Generate & link all dotfiles',
                    'checked': True,
                },
                {
                    'name': 'Install/upgrade brew packages',
                    'checked': True,
                },
                {
                    'name': 'Install/upgrade brew casks',
                    'checked': True,
                },
                {
                    'name': 'Install/update the powerlevel9k oh-my-zsh theme',
                    'checked': True,
                },
                {
                    'name': 'Sync git repositories',
                    'checked': True,
                },
                {
                    'name': 'Configure iterm2 and system settings',
                    'checked': False,
                },
                {
                    'name': 'Import GPG keys',
                    'checked': False,
                },
                {
                    'name': 'Install fonts',
                    'checked': False,
                },
                {
                    'name': 'Open non-casked app download pages',
                    'checked': False,
                },
            ],
            'filter': jobs_filter,
        },
        {
            'name': 'profile',
            'type': 'list',
            'message': 'Which profile should be used to setup this computer?',
            'choices': profile_names,
        },
    ])

    if 'jobs' not in answers or 'profile' not in answers:
        exit(1)

    puts('\n')
    return answers['jobs'], answers['profile']
