import os
import re
import subprocess
from sys import exit

from clint.textui import colored, puts, puts_err
from PyInquirer import prompt

from pydotfiles.util_with_io import git, profiles
from pydotfiles.constants import PATHS


def main():
    git.dotfiles_private_pull_latest()

    profile_name = profiles.get_current_name(exit_if_not_set=True)
    puts(colored.blue('Profile: %s' % profile_name))
    answers = prompt([
        {
            'name': 'workspace',
            'type': 'list',
            'message': 'Workspace:',
            'choices': profiles.read_git_workspace_names(),
        },
        {
            'name': 'dirname',
            'type': 'input',
            'message': 'Directory name:',
        },
    ])

    if 'workspace' not in answers or 'dirname' not in answers:
        exit(1)

    workspace = answers['workspace']
    dirname = answers['dirname']

    if not profiles.read_git_workspace_repo(workspace, dirname):
        puts_err(colored.red(
            '! the given workspace does not include that repo: %s' % dirname))
        exit(1)

    profiles.update_profile_git_workspace_remove_git_repo(
        profile_name, workspace, dirname)
    git.dotfiles_private_commit_and_push_changes('Remove Git Repo: %s > %s' %
                                                 (workspace, dirname))
    puts(colored.yellow('This repo has been removed from your profile,'))
    puts(colored.yellow('but you must remove the cloned repo from your local filesystem.'))


main()
