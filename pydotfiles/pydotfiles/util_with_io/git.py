from clint.textui import colored, puts, puts_err

from pydotfiles.constants import PATHS
from pydotfiles.util import git
from pydotfiles.util.git import remote_exists, parse_repo_name_from_url


def add_remote(name, url, cwd=None, exit_on_error=False):
    puts(colored.magenta('>> git remote add %s %s' % (name, url)))
    success, return_code = git.add_remote(name, url, cwd=cwd)
    if success:
        puts(colored.green('✔\n'))
        return True

    puts_err(colored.red('! failed: git remote add %s %s' % (name, url)))
    if exit_on_error:
        exit(return_code)
    else:
        return False


def clone(url, dest_dirname, cwd=None, exit_on_error=False):
    puts(colored.magenta('>> git clone %s %s' % (url, dest_dirname)))
    success, return_code = git.clone(url, dest_dirname, cwd)
    if success:
        puts(colored.green('✔\n'))
        return True

    puts_err(colored.red('! failed: git clone %s %s' % (url, dest_dirname)))
    if exit_on_error:
        exit(return_code)
    else:
        return False


def dotfiles_private_exit_if_master_branch_not_checked_out():
    if not git.dotfiles_private_is_master_branch_checked_out():
        puts_err(colored.red('! master branch not checked out here: %s' %
                             PATHS.DOTFILES_PRIVATE))
        exit(1)


def dotfiles_private_exit_if_has_changes_staged():
    if git.dotfiles_private_has_staged_changes():
        puts_err(colored.red(
            '! There are already changes staged; cannot commit and push profiles.json changes.'))
        exit(1)


def dotfiles_private_commit_and_push_changes(commit_message):
    dotfiles_private_exit_if_master_branch_not_checked_out()
    dotfiles_private_exit_if_has_changes_staged()

    puts(colored.magenta('>> Committing and pushing changes to profiles.json:'))

    success, return_code = git.dotfiles_private_add_profiles_json()
    if not success:
        puts_err(colored.red('! failed: git add profiles.json'))
        exit(return_code)

    success, return_code = git.dotfiles_private_commit_with_message(
        commit_message)
    if not success:
        puts_err(colored.red('! failed: git commit -m "%s"' % commit_message))
        exit(return_code)

    success, return_code = git.dotfiles_private_push_master_to_origin()
    if not success:
        puts_err(colored.red('! failed: git push origin master'))
        exit(return_code)

    puts(colored.green('✔\n'))


def dotfiles_private_pull_latest():
    dotfiles_private_exit_if_master_branch_not_checked_out()
    dotfiles_private_exit_if_has_changes_staged()

    puts(colored.magenta('>> Pulling latest dotfiles_private changes:'))
    success, return_code = git.dotfiles_private_pull_latest()
    if success:
        puts(colored.green('✔\n'))
        return True

    puts_err(colored.red('! git pull failed'))
    exit(return_code)


def exit_if_cwd_not_git_repo():
    if not git.is_cwd_git_repo():
        puts_err(colored.red(
            '! Current working directory is not a git repository.'))
        exit(1)


def fetch(remote_name, exit_on_error=False):
    puts(colored.magenta('>> git fetch %s' % remote_name))
    success, return_code = git.fetch(remote_name)
    if success:
        puts(colored.green('✔\n'))
        return True

    puts_err(colored.red('! failed: git fetch %s' % remote_name))
    if exit_on_error:
        exit(return_code)
    else:
        return False


def remove_remote(name, exit_on_error=False):
    exit_if_cwd_not_git_repo()

    puts(colored.magenta('>> git remote rm %s' % name))
    success, return_code = git.remove_remote(name)
    if success:
        puts(colored.green('✔\n'))
        return True

    puts_err(colored.red('! failed: git remote rm %s' % name))
    if exit_on_error:
        exit(return_code)
    else:
        return False


def set_configs(configs, cwd=None, exit_on_error=False):
    puts(colored.magenta('>> Configuring git repo: %s' % cwd or ''))
    for key, value in configs.items():
        success, _ = git.set_config(key, value, cwd=cwd)
        if success:
            puts('%s=%s' % (key, value))
        else:
            puts_err(colored.red('! failed: git config %s %s' % (key, value)))
            if exit_on_error:
                exit(1)
            else:
                return False
    puts(colored.green('✔\n'))
    return True


def init_and_update_submodules(cwd=None):
    puts(colored.magenta('>> Initializing and updating submodules:'))
    success, _ = git.init_and_update_submodules(cwd=cwd)
    if success:
        puts(colored.green('✔\n'))
    else:
        puts_err(colored.red('! failed to initialize or update submodules\n'))
