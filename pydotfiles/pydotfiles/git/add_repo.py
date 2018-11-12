import os
import re
import subprocess
from sys import exit

from clint.textui import colored, puts, puts_err
from PyInquirer import prompt

from pydotfiles.common import profiles
from pydotfiles.common.constants import PATHS


def parse_repo_name_from_url(repo_url):
    """
    Parses and returns the repo name (without the .git extension) from a URL

    repo_url: git URL to parse the name from
    """
    match = re.match(
        r'git@(?:github|gitlab)\.com(?:.)*[:/].+/(.+)\.git', repo_url)
    if not match:
        raise ValueError('repo_url must be a valid git URL')
    return match.group(1)


def main():
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
        }
    ])

    if 'url' not in answers or 'workspace' not in answers or 'dirname' not in answers:
        exit(1)

    url = answers['url']
    workspace = answers['workspace']
    target_dirname = answers['dirname']
    if not target_dirname:
        target_dirname = parse_repo_name_from_url(url)

    ssh_config = profiles.read_git_workspace_ssh_config(workspace)
    mapped_url = url.replace(ssh_config['hostname'], ssh_config['host'])

    workspace_dir = '%s/%s' % (PATHS.DEV_WORKSPACE, workspace)
    repo_dir = '%s/%s' % (workspace_dir, target_dirname)

    if os.path.isdir(repo_dir):
        puts_err(colored.red('! target directory already exists: %s' % repo_dir))
        exit(1)

    puts(colored.magenta('>> Cloning %s into %s' % (url, repo_dir)))
    p = subprocess.Popen(
        ['git', 'clone', mapped_url, target_dirname], cwd=workspace_dir)
    return_code = p.wait()
    if return_code == 0:
        profiles.update_profile_git_workspace_add_git_repo(
            profile_name, workspace, url, target_dirname)
        puts(colored.green('✔'))
    else:
        puts_err(colored.red('! git clone failed'))
        exit(return_code)


main()
