import json
from os import environ
import subprocess
from sys import exit

from clint.textui import colored, puts, puts_err

from pydotfiles.constants import ENV, PATHS
from pydotfiles.util_with_io import git

cached_profiles_json = None


def get_current_name(exit_if_not_set=False):
    current_profile_name = environ[ENV.DOTFILES_PROFILE] if ENV.DOTFILES_PROFILE in environ else None
    if exit_if_not_set and not current_profile_name:
        puts_err(colored.red('! No dotfiles profile set ($%s). Complete the bootstrap setup first.' %
                             ENV.DOTFILES_PROFILE))
        exit(1)
    return current_profile_name


def read(profile_name=None):
    if not profile_name:
        profile_name = get_current_name(exit_if_not_set=True)

    return read_all()[profile_name]


def read_all():
    global cached_profiles_json
    if not cached_profiles_json:
        with open(PATHS.PROFILES_JSON, 'r') as f:
            cached_profiles_json = json.load(f)
    return cached_profiles_json


def read_app_download_urls(profile_name=None):
    return read(profile_name)['apps']


def read_brew(profile_name=None):
    return read(profile_name)['brew']


def read_brew_casks(profile_name=None):
    return read_brew(profile_name)['casks']


def read_brew_formulae(profile_name=None):
    return read_brew(profile_name)['formulae']


def read_brew_taps(profile_name=None):
    return read_brew(profile_name)['taps']


def read_gem(profile_name=None):
    return read(profile_name)['gem']


def read_gem_rakes(profile_name=None):
    return read_gem(profile_name)['rakes']


def read_git_workspace(git_user, profile_name=None):
    return read_git_workspaces(profile_name)[git_user]


def read_git_workspace_names(profile_name=None):
    return read_git_workspaces(profile_name).keys()


def read_git_workspace_repos(git_user, profile_name=None):
    return read_git_workspace(git_user, profile_name)['repos']


def read_git_workspace_repo_items(git_user, profile_name=None):
    json = read_git_workspace_repos(git_user, profile_name)
    return [(repo_dirname, repo_json['url']) for repo_dirname, repo_json in json.items()]


def read_git_workspace_repo(git_user, repo_dirname, profile_name=None):
    return read_git_workspace_repos(git_user, profile_name)[repo_dirname]


def read_git_workspace_repo_remotes(git_user, repo_dirname, profile_name=None):
    return read_git_workspace_repo(git_user, repo_dirname, profile_name)['remotes']


def read_git_workspace_repo_remote_items(git_user, repo_dirname, profile_name=None):
    return read_git_workspace_repo_remotes(git_user, repo_dirname, profile_name).items()


def read_git_workspaces(profile_name=None):
    profile_json = read(profile_name)
    return profile_json['git_workspaces']


def read_git_workspace_config(git_user, profile_name=None):
    git_workspace = read_git_workspace(git_user, profile_name=profile_name)
    return {
        'user.name': git_workspace['user'],
        'user.email': git_workspace['email'],
        'user.signingkey': git_workspace['signingkey'],
    }


def read_git_workspace_ssh_config(git_user, profile_name=None):
    git_workspace = read_git_workspace(git_user, profile_name=profile_name)
    return git_workspace['ssh_config']


def read_names():
    return read_all().keys()


def update_all_profiles(updater):
    write_json(updater(read_all()))


def update_profile(profile_name, updater):
    def profiles_updater(profiles):
        profiles[profile_name] = updater(profiles[profile_name])
        return profiles

    update_all_profiles(profiles_updater)


def update_profile_add_app_download_url(profile_name, url):
    def profile_updater(profile):
        if url not in profile['apps']:
            profile['apps'].append(url)
        return profile

    update_profile(profile_name, profile_updater)


def update_profile_add_brew_cask(profile_name, cask):
    def profile_updater(profile):
        if cask not in profile['brew']['casks']:
            profile['brew']['casks'].append(cask)
        return profile

    update_profile(profile_name, profile_updater)


def update_profile_add_brew_formula(profile_name, formula):
    def profile_updater(profile):
        if formula not in profile['brew']['formulae']:
            profile['brew']['formulae'].append(formula)
        return profile

    update_profile(profile_name, profile_updater)


def update_profile_add_brew_tap(profile_name, tap):
    def profile_updater(profile):
        if tap not in profile['brew']['taps']:
            profile['brew']['taps'].append(tap)
        return profile

    update_profile(profile_name, profile_updater)


def update_profile_add_gem_rake(profile_name, rake):
    def proflie_updater(profile):
        if rake not in profile['gem']['rakes']:
            profile['gem']['rakes'].append(rake)
        return profile

    update_profile(profile_name, proflie_updater)

def update_profile_remove_app_download_url(profile_name, url):
    def profile_updater(profile):
        profile['apps'].remove(url)
        return profile

    update_profile(profile_name, profile_updater)


def update_profile_remove_brew_cask(profile_name, cask):
    def profile_updater(profile):
        profile['brew']['casks'].remove(cask)
        return profile

    update_profile(profile_name, profile_updater)


def update_profile_remove_brew_formula(profile_name, formula):
    def profile_updater(profile):
        profile['brew']['formulae'].remove(formula)
        return profile

    update_profile(profile_name, profile_updater)


def update_profile_remove_brew_tap(profile_name, tap):
    def profile_updater(profile):
        profile['brew']['taps'].remove(tap)
        return profile

    update_profile(profile_name, profile_updater)


def update_profile_git_workspace(profile_name, git_workspace, updater):
    def profile_updater(profile):
        profile['git_workspaces'][git_workspace] = updater(
            profile['git_workspaces'][git_workspace])
        return profile

    update_profile(profile_name, profile_updater)


def update_profile_git_workspace_add_git_remote(profile_name, git_workspace, dirname, remote_name, remote_url):
    def git_workspace_updater(git_workspace):
        git_workspace['repos'][dirname]['remotes'][remote_name] = remote_url
        return git_workspace

    return update_profile_git_workspace(profile_name, git_workspace, git_workspace_updater)


def update_profile_git_workspace_add_git_repo(profile_name, git_workspace, url, dirname):
    def git_workspace_updater(git_workspace):
        git_workspace['repos'][dirname] = {
            'url': url,
            'remotes': {},
        }
        return git_workspace

    return update_profile_git_workspace(profile_name, git_workspace, git_workspace_updater)


def update_profile_git_workspace_remove_git_remote(profile_name, git_workspace, dirname, remote_name):
    def git_workspace_updater(git_workspace):
        if remote_name in git_workspace['repos'][dirname]['remotes']:
            git_workspace['repos'][dirname]['remotes'].pop(remote_name)
        return git_workspace

    return update_profile_git_workspace(profile_name, git_workspace, git_workspace_updater)


def update_profile_git_workspace_remove_git_repo(profile_name, git_workspace, dirname):
    def git_workspace_updater(git_workspace):
        if dirname in git_workspace['repos']:
            git_workspace['repos'].pop(dirname)
        return git_workspace

    return update_profile_git_workspace(profile_name, git_workspace, git_workspace_updater)


def write_json(profiles_json):
    if not profiles_json:
        puts_err(colored.red(
            '! attempted to write to profiles.json with empty payload'))
        exit(1)

    for profile in profiles_json.values():
        profile['apps'].sort()
        profile['brew']['casks'].sort()
        profile['brew']['formulae'].sort()
        profile['brew']['taps'].sort()

    with open(PATHS.PROFILES_JSON, 'w+') as out:
        out.write(json.dumps(profiles_json, indent=2, sort_keys=True))

    global cached_profiles_json
    cached_profiles_json = profiles_json
