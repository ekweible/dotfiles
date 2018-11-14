import os
import re
import subprocess
from sys import exit

from clint.textui import colored, puts, puts_err
from PyInquirer import prompt

from pydotfiles.util_with_io import git, profiles
from pydotfiles.constants import PATHS


def main():
    git.exit_if_cwd_not_git_repo()
    git.dotfiles_private_pull_latest()

    profile_name = profiles.get_current_name(exit_if_not_set=True)
    workspace = os.path.basename(
        os.path.abspath(os.path.join(os.curdir, os.pardir)))
    dirname = os.path.basename(os.path.abspath(os.curdir))

    puts(colored.blue('Profile: %s' % profile_name))
    puts(colored.blue('Workspace: %s' % workspace))
    puts(colored.blue('Repo: %s' % dirname))
    answers = prompt([
        {
            'name': 'url',
            'type': 'input',
            'message': 'Git url:',
        },
        {
            'name': 'name',
            'type': 'input',
            'message': 'Remote name:',
        }
    ])
    if 'url' not in answers or 'name' not in answers:
        exit(1)

    remote_url = answers['url']
    remote_name = answers['name']

    ssh_config = profiles.read_git_workspace_ssh_config(workspace)
    mapped_url = remote_url.replace(ssh_config['hostname'], ssh_config['host'])

    git.add_remote(remote_name, mapped_url, exit_on_error=True)
    git.fetch(remote_name, exit_on_error=True)
    profiles.update_profile_git_workspace_add_git_remote(
        profile_name, workspace, dirname, remote_name, remote_url)
    git.dotfiles_private_commit_and_push_changes(
        'Git Remote: %s > %s > %s' % (workspace, dirname, remote_name))


main()
