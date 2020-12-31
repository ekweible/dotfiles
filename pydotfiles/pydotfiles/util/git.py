import os
import re
import subprocess

from pydotfiles.constants import PATHS


def add_remote(name, url, cwd=None):
    p = subprocess.Popen(['git', 'remote', 'add', name, url], cwd=cwd)
    return_code = p.wait()
    return return_code == 0, return_code


def clone(url, dest_dirname, cwd=None):
    p = subprocess.Popen(
        ['git', 'clone', url, dest_dirname], cwd=cwd)
    return_code = p.wait()
    return return_code == 0, return_code


def dotfiles_private_add_profiles_json():
    return dotfiles_private_run_git_cmd(['git', 'add', 'profiles.json'])


def dotfiles_private_commit_with_message(commit_message):
    return dotfiles_private_run_git_cmd(['git', 'commit', '-m', commit_message])


def dotfiles_private_push_master_to_origin():
    return dotfiles_private_run_git_cmd(['git', 'push', 'origin', 'master'])


def dotfiles_private_has_staged_changes():
    # This will exit with 1 if there are any staged changes.
    p = subprocess.Popen(
        ['git', 'diff', '--cached', '--quiet'], cwd=PATHS.DOTFILES_PRIVATE)
    return_code = p.wait()
    return return_code != 0


def dotfiles_private_is_master_branch_checked_out():
    p = subprocess.Popen(
        ['git', 'rev-parse', '--abbrev-ref', 'HEAD'], cwd=PATHS.DOTFILES_PRIVATE, stdout=subprocess.PIPE)
    p.text_mode = True
    stdout, _ = p.communicate()
    current_branch = str(stdout)
    return 'master' in current_branch


def dotfiles_private_pull_latest():
    p = subprocess.Popen(['git', 'pull'], cwd=PATHS.DOTFILES_PRIVATE)
    return_code = p.wait()
    return return_code == 0, return_code


def dotfiles_private_run_git_cmd(command_and_args):
    p = subprocess.Popen(command_and_args, cwd=PATHS.DOTFILES_PRIVATE)
    return_code = p.wait()
    return return_code == 0, return_code


def init_and_update_submodules(cwd=None):
    submodule_proc = subprocess.Popen(
        ['git', 'submodule', 'update', '--init', '--remote'],
        cwd=cwd)
    return_code = submodule_proc.wait()
    return return_code == 0, return_code


def is_cwd_git_repo():
    return os.path.isdir('.git')


def fetch(remote_name):
    p = subprocess.Popen(['git', 'fetch', remote_name])
    return_code = p.wait()
    return return_code == 0, return_code


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


def remove_remote(name):
    p = subprocess.Popen(['git', 'remote', 'rm', name])
    return_code = p.wait()
    return return_code == 0, return_code


def set_config(key, value, cwd=None):
    p = subprocess.Popen(['git', 'config', key, value], cwd=cwd)
    return_code = p.wait()
    return return_code == 0, return_code
