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
            'name': 'url',
            'type': 'input',
            'message': 'Git url:',
        },
        {
            'name': 'workspace',
            'type': 'list',
            'message': 'Workspace:',
            'choices': profiles.read_git_workspace_names(),
        },
        {
            'name': 'dirname',
            'type': 'input',
            'message': 'Directory name (or leave blank to use the repo name):',
        },
    ])

    if 'url' not in answers or 'workspace' not in answers or 'dirname' not in answers:
        exit(1)

    url = answers['url']
    workspace = answers['workspace']
    dest_dirname = answers['dirname']
    if not dest_dirname:
        dest_dirname = git.parse_repo_name_from_url(url)

    ssh_config = profiles.read_git_workspace_ssh_config(workspace)
    mapped_url = url.replace(ssh_config['hostname'], ssh_config['host'])

    workspace_dir = '%s/%s' % (PATHS.DEV_WORKSPACE, workspace)
    repo_dir = '%s/%s' % (workspace_dir, dest_dirname)

    if os.path.isdir(repo_dir):
        puts_err(colored.red('! target directory already exists: %s' % repo_dir))
        exit(1)

    git.clone(mapped_url, dest_dirname, cwd=workspace_dir, exit_on_error=True)
    git.set_configs(profiles.read_git_workspace_config(
        workspace), cwd=repo_dir, exit_on_error=True)
    profiles.update_profile_git_workspace_add_git_repo(
        profile_name, workspace, url, dest_dirname)
    git.dotfiles_private_commit_and_push_changes('Git Repo: %s > %s' %
                                                 (workspace, dest_dirname))


main()
