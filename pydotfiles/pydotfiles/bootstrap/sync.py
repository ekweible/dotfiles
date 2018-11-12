from sys import exit

from PyInquirer import prompt
from clint.textui import colored, puts, puts_err

from pydotfiles.common import profiles
from pydotfiles.common import util


def main():
    current_profile_name = profiles.get_current_name(exit_if_not_set=True)
    puts(colored.blue('Profile: %s' % current_profile_name))

    num_brew_casks = len(profiles.read_brew_casks())
    num_brew_formulae = len(profiles.read_brew_formulae())
    num_brew_taps = len(profiles.read_brew_taps())
    num_brew_items = num_brew_casks + num_brew_formulae + num_brew_taps

    workspace_names = profiles.read_git_workspace_names()
    workspace_info = []
    for workspace_name in workspace_names:
        num_repos = len(profiles.read_git_workspace(
            workspace_name)['repos'].keys())
        workspace_info.append('%s: %d repos' % (workspace_name, num_repos))

    answers = prompt([
        {
            'name': 'jobs',
            'type': 'checkbox',
            'message': 'What would you like to sync:',
            'choices': [
                {
                    'name': 'Brew (%d items)' % num_brew_items,
                    'checked': True,
                },
                {
                    'name': 'Git workspaces (%s)' % ', '.join(workspace_info),
                    'checked': True,
                },
            ],
        },
    ])
    if 'jobs' not in answers:
        exit(1)

    for job in answers['jobs']:
        if job.startswith('Brew'):
            util.update_brew()
            util.install_or_upgrade_brew_formulae()
            util.install_or_upgrade_brew_casks()

        if job.startswith('Git workspaces'):
            for workspace_name in workspace_names:
                puts(colored.magenta('>> Syncing %s workspace:' % workspace_name))


main()
