from sys import exit

from PyInquirer import prompt
from clint.textui import colored, puts, puts_err

from pydotfiles.util_with_io import brew, git, git_sync, profiles


def main():
    git.dotfiles_private_pull_latest()
    current_profile_name = profiles.get_current_name(exit_if_not_set=True)
    puts(colored.blue('Profile: %s' % current_profile_name))

    num_brew_casks = len(profiles.read_brew_casks())
    num_brew_formulae = len(profiles.read_brew_formulae())
    num_brew_taps = len(profiles.read_brew_taps())
    num_brew_items = num_brew_casks + num_brew_formulae + num_brew_taps

    workspace_names = profiles.read_git_workspace_names()
    workspace_info = []
    for workspace_name in workspace_names:
        num_repos = len(profiles.read_git_workspace_repos(workspace_name))
        workspace_info.append('%s: %d repos' % (workspace_name, num_repos))

    answers = prompt([
        {
            'name': 'jobs',
            'type': 'checkbox',
            'message': 'What would you like to sync:',
            'choices': [
                {
                    'name': 'Dotfiles submodules',
                    'checked': True,
                },
                {
                    'name': 'Git workspaces (%s)' % ', '.join(workspace_info),
                    'checked': True,
                },
                {
                    'name': 'Brew (%d items)' % num_brew_items,
                    'checked': True,
                },
            ],
        },
    ])
    if 'jobs' not in answers:
        exit(1)

    for job in answers['jobs']:
        if job.startswith('Brew'):
            brew.update()
            brew.tap_all_repos(profiles.read_brew_taps())
            brew.install_or_upgrade_all_formulae(profiles.read_brew_formulae())
            brew.install_or_upgrade_all_casks(profiles.read_brew_casks())

        if job.startswith('Git workspaces'):
            git_sync.run()

        if 'submodules' in job:
            git.init_and_update_submodules()


main()
