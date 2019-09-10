from clint.textui import colored, puts, puts_err
from PyInquirer import prompt

from pydotfiles.bootstrap.constants import JOBS
from pydotfiles.util_with_io import profiles


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
                    'name': JOBS.CHANGE_SHELL,
                    'checked': True,
                },
                {
                    'name': JOBS.LINK_DOTFILES,
                    'checked': True,
                },
                {
                    'name': JOBS.UPDATE_SUBMODULES,
                    'checked': True,
                },
                {
                    'name': JOBS.UPGRADE_BREW_PACKAGES,
                    'checked': True,
                },
                {
                    'name': JOBS.UPGRADE_BREW_CASKS,
                    'checked': True,
                },
                {
                    'name': JOBS.UPGRADE_GEM_RAKES,
                    'checked': True,
                },
                {
                    'name': JOBS.INSTALL_NVM,
                    'checked': True
                },
                {
                    'name': JOBS.SYNC_GIT,
                    'checked': True,
                },
                {
                    'name': JOBS.CONFIGURE_SETTINGS,
                    'checked': False,
                },
                {
                    'name': JOBS.IMPORT_GPG_KEYS,
                    'checked': False,
                },
                {
                    'name': JOBS.INSTALL_FONTS,
                    'checked': False,
                },
                {
                    'name': JOBS.OPEN_NON_CASKED_APPS,
                    'checked': False,
                },
            ],
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
