import json
from os import environ
import subprocess
from sys import exit

from clint.textui import puts, puts_err, colored

from .constants import ENV, PATHS

cached_profiles_json = None


def ensure_master_branch_checked_out():
    master_branch_check = subprocess.Popen(
        ['git', 'rev-parse', '--abbrev-ref', 'HEAD'], cwd=PATHS.DOTFILES_PRIVATE, stdout=subprocess.PIPE)
    master_branch_check.text_mode = True
    stdout, _ = master_branch_check.communicate()
    current_branch = str(stdout)
    if 'master' not in current_branch:
        puts_err(colored.red('! master branch not checked out here: %s' %
                             PATHS.DOTFILES_PRIVATE))
        exit(1)
        return


def fail_if_staged_changes():
    # Check for pre-existing staged changes. This will exit with 1 if there are
    # any staged changes, in which case we should exit early.
    staged_changes_check = subprocess.Popen(
        ['git', 'diff', '--cached', '--quiet'], cwd=PATHS.DOTFILES_PRIVATE)
    return_code = staged_changes_check.wait()
    if return_code != 0:
        puts_err(colored.red(
            '! There are already changes staged; cannot commit and push profiles.json changes.'))
        exit(return_code)
        return


def commit_and_push_changes(commit_msg):
    ensure_master_branch_checked_out()
    fail_if_staged_changes()

    puts(colored.magenta('>> Committing and pushing changes to profiles.json:'))

    def run_git_cmd(command_and_args):
        p = subprocess.Popen(command_and_args, cwd=PATHS.DOTFILES_PRIVATE)
        return_code = p.wait()
        if return_code != 0:
            puts_err(colored.red('! %s failed' % ' '.join(command_and_args)))
            exit(return_code)

    run_git_cmd(['git', 'add', 'profiles.json'])
    run_git_cmd(['git', 'commit', '-m', commit_msg])
    run_git_cmd(['git', 'push', 'origin', 'master'])
    puts(colored.green('✔'))


def pull_changes():
    ensure_master_branch_checked_out()

    puts(colored.magenta('>> Pulling latest dotfiles_private changes:'))
    p = subprocess.Popen(['git', 'pull'], cwd=PATHS.DOTFILES_PRIVATE)
    return_code = p.wait()
    if return_code == 0:
        puts(colored.green('✔'))
        return True

    puts_err(colored.red('! git pull failed'))
    exit(return_code)


def get_current_name(exit_if_not_set=False):
    current_profile_name = environ[ENV.DOTFILES_PROFILE] if ENV.DOTFILES_PROFILE in environ else None
    if exit_if_not_set and not current_profile_name:
        puts_err(colored.red('! No dotfiles profile set ($%s). Complete the bootstrap setup first.' %
                             ENV.DOTFILES_PROFILE))
        exit(1)
    return current_profile_name


def load_json():
    global cached_profiles_json
    if not cached_profiles_json:
        with open(PATHS.PROFILES_JSON, 'r') as f:
            cached_profiles_json = json.load(f)
    return cached_profiles_json


def read(profile_name=None):
    if not profile_name:
        profile_name = get_current_name(exit_if_not_set=True)

    return read_all()[profile_name]


def read_all():
    return load_json()


def read_brew(profile_name=None):
    return read(profile_name)['brew']


def read_brew_casks(profile_name=None):
    return read_brew(profile_name)['casks']


def read_brew_formulae(profile_name=None):
    return read_brew(profile_name)['formulae']


def read_brew_taps(profile_name=None):
    return read_brew(profile_name)['taps']


def read_git_workspace(git_user, profile_name=None):
    return read_git_workspaces(profile_name)[git_user]


def read_git_workspace_names(profile_name=None):
    return read_git_workspaces(profile_name).keys()


def read_git_workspaces(profile_name=None):
    profile_json = read(profile_name)
    return profile_json['git_workspaces']


def read_git_workspace_ssh_config(git_user, profile_name=None):
    git_workspace = read_git_workspace(
        git_user, profile_name=profile_name)
    return git_workspace['ssh_config']


def read_names():
    return read_all().keys()


def update_profiles(updater):
    write_json(updater(read_all()))


def update_profile(profile_name, updater):
    def profiles_updater(profiles):
        profiles[profile_name] = updater(profiles[profile_name])
        return profiles

    update_profiles(profiles_updater)


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


def update_profile_git_workspace_add_git_repo(profile_name, git_workspace, url, dirname):
    def git_workspace_updater(git_workspace):
        git_workspace['repos'][dirname] = {
            'url': url,
            'remotes': {},
        }
        return git_workspace

    return update_profile_git_workspace(profile_name, git_workspace, git_workspace_updater)


def update_profile_git_workspace_add_git_remote(profile_name, git_workspace, dirname, remote_name, remote_url):
    def git_workspace_updater(git_workspace):
        git_workspace['repos'][dirname]['remotes'][remote_name] = remote_url
        return git_workspace

    return update_profile_git_workspace(profile_name, git_workspace, git_workspace_updater)


def write_json(profiles_json):
    if not profiles_json:
        puts_err(colored.red(
            '! attempted to write to profiles.json with empty payload'))
        exit(1)

    for profile in profiles_json.values():
        profile['brew']['casks'].sort()
        profile['brew']['formulae'].sort()
        profile['brew']['taps'].sort()

    with open(PATHS.PROFILES_JSON, 'w+') as out:
        out.write(json.dumps(profiles_json, indent=2, sort_keys=True))

    global cached_profiles_json
    cached_profiles_json = profiles_json
