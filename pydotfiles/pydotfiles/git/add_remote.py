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


def remote_exists(repo_path, remote_name):
    """
    Checks if a remote for a repo exists by checking the output of `git remote`
    in the repo directory

    Returns True if the remote already exists, False otherwise
    """
    p = subprocess.Popen(['git', 'remote'], cwd=repo_path,
                         stdout=subprocess.PIPE)
    p.text_mode = True
    stdout, _ = p.communicate()
    remotes = str(stdout)
    return remote_name in remotes


def main():
    if not os.path.isdir('.git'):
        puts_err(colored.red(
            '! Current working directory is not a git repository.'))
        exit(1)

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

    puts(colored.magenta('>> Adding and fetching remote "%s": %s' %
                         (remote_name, remote_url)))
    add_proc = subprocess.Popen(
        ['git', 'remote', 'add', remote_name, mapped_url])
    return_code = add_proc.wait()
    if return_code != 0:
        puts_err(colored.red('! git add remote failed'))
        exit(return_code)
        return

    fetch_proc = subprocess.Popen(['git', 'fetch', remote_name])
    return_code = fetch_proc.wait()
    if return_code == 0:
        profiles.update_profile_git_workspace_add_git_remote(
            profile_name, workspace, dirname, remote_name, remote_url)
        puts(colored.green('✔'))
        puts('')
        profiles.commit_and_push_changes(
            'Git Remote: %s > %s > %s' % (workspace, dirname, remote_name))
    else:
        puts_err(colored.red('! git fetch failed'))
        exit(return_code)


main()
