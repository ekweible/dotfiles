import io
import json
import os
import re
import subprocess
import sys

from clint.textui import colored, puts, puts_err
from PyInquirer import prompt

from pydotfiles.bootstrap.constants import JOBS
from pydotfiles.bootstrap.questions import ask_bootstrap_questions
from pydotfiles.constants import PATHS
from pydotfiles.util_with_io import brew, gem, git, git_sync, profiles


link_dotfiles_overwrite_all = None
link_dotfiles_backup_all = None
link_dotfiles_skip_all = None


def change_shell_to_zsh():
    read_shell_proc = subprocess.Popen(
        ['dscl', '.', '-read', PATHS.HOME, 'UserShell'])
    read_shell_proc.text_mode = True
    stdout, _ = read_shell_proc.communicate()
    user_shell = str(stdout)
    if not user_shell.endswith('/usr/local/bin/zsh'):
        puts(colored.magenta('>> Changing user shell to zsh (requires password):'))
        change_shell_proc = subprocess.Popen(
            ['sudo', 'dscl', '.', 'change', PATHS.HOME, 'UserShell', '/bin/bash', '/bin/zsh'])
        return_code = change_shell_proc.wait()
        if return_code == 0:
            puts(colored.green('✔\n'))
        else:
            puts_err(colored.red('! failed to change user shell to zsh\n'))
    puts('')


def configure_iterm2():
    puts(colored.magenta('>> Configuring iterm2:'))
    p = subprocess.Popen(['/bin/bash', PATHS.SCRIPTS_CONFIGURE_ITERM2])
    return_code = p.wait()
    if return_code == 0:
        puts(colored.green('✔\n'))
    else:
        puts_err(colored.red('! failed to configure iterm2\n'))


def configure_system_settings():
    puts(colored.magenta('>> Configuring system settings:'))
    p = subprocess.Popen(
        ['/bin/bash', PATHS.SCRIPTS_CONFIGURE_SYSTEM_SETTINGS])
    return_code = p.wait()
    if return_code == 0:
        puts(colored.green('✔\n'))
    else:
        puts_err(colored.red('! failed to configure system settings\n'))


def create_git_workspace_dirs(profile_name):
    puts(colored.magenta('>> Creating dev workspace dirs:'))
    for git_workspace in profiles.read_git_workspaces(profile_name).values():
        user = git_workspace['user']
        workspace_path = '%s/%s' % (PATHS.DEV_WORKSPACE, user)
        os.makedirs(workspace_path, exist_ok=True)
        puts(workspace_path)
    puts(colored.green('✔\n'))


def import_gpg_keys(profile_name):
    puts(colored.magenta('>> Importing GPG keys:'))

    gpg_dir = '%s/%s/gpg' % (PATHS.DOTFILES_PRIVATE, profile_name)
    if not os.path.isdir(gpg_dir):
        puts_err(colored.red('! no `gpg` directory here: %s\n' % gpg_dir))
        return

    owner_trust_txt = '%s/ownertrust.txt' % gpg_dir
    if not os.path.isfile(owner_trust_txt):
        puts_err(colored.red('! no `ownertrust.txt` found here: %s\n' % gpg_dir))
        return

    errors = False

    p = subprocess.Popen(['gpg', '--import-ownertrust', owner_trust_txt])
    return_code = p.wait()
    if return_code == 0:
        puts('imported %s' % owner_trust_txt)
    else:
        puts_err(colored.red('! failed to import %s\n' % owner_trust_txt))
        errors = True

    for _, _, filenames in os.walk(gpg_dir):
        for filename in filenames:
            if filename.endswith('_secret_gpg.key'):
                path = '%s/%s' % (gpg_dir, filename)
                p = subprocess.Popen(['gpg', '--import', path])
                return_code = p.wait()
                if return_code == 0:
                    puts('imported %s' % path)
                else:
                    puts_err(colored.red('! failed to import %s\n' % path))
                    errors = True

    if not errors:
        puts(colored.green('✔\n'))


def install_fonts():
    puts(colored.magenta('>> Installing fonts:'))

    p = subprocess.Popen(['/bin/bash', PATHS.FONTS_INSTALL_SCRIPT])
    return_code = p.wait()
    if return_code == 0:
        puts(colored.green('✔\n'))
    else:
        puts_err(colored.red('! failed to install fonts\n'))


def install_nvm():
    puts(colored.magenta('>> Installing Node Version Manager:'))
    p = subprocess.Popen(['/bin/bash', PATHS.SCRIPTS_CONFIGURE_ITERM2])
    return_code = p.wait()
    if return_code == 0:
        puts(colored.green('✔\n'))
    else:
        puts_err(colored.red('! failed to install nvm\n'))


def install_or_update_powerlevel9k_theme():
    if not os.path.isdir(PATHS.POWERLEVEL9K_THEME):
        puts(colored.magenta('>> Installing powerlevel9k oh-my-zsh theme:'))
        clone_proc = subprocess.Popen(
            ['git', 'clone', 'https://github.com/bhilburn/powerlevel9k.git', PATHS.POWERLEVEL9K_THEME])
        return_code = clone_proc.wait()
        if return_code == 0:
            puts(colored.green('✔\n'))
        else:
            puts_err(colored.red(
                '! failed to install powerlevel9k oh-my-zsh theme\n'))
    else:
        puts(colored.magenta('>> Updating powerlevel9k oh-my-zsh theme:'))
        clone_proc = subprocess.Popen(
            ['git', 'pull'], cwd=PATHS.POWERLEVEL9K_THEME)
        return_code = clone_proc.wait()
        if return_code == 0:
            puts(colored.green('✔\n'))
        else:
            puts_err(colored.red(
                '! failed to update powerlevel9k oh-my-zsh theme\n'))


def link_file(src, dest):
    global link_dotfiles_overwrite_all
    global link_dotfiles_backup_all
    global link_dotfiles_skip_all
    overwrite, backup, skip = (False, False, False)

    if os.path.isfile(dest) or os.path.islink(dest):
        if not link_dotfiles_overwrite_all and not link_dotfiles_backup_all and not link_dotfiles_skip_all:
            short_file_path = dest.replace(PATHS.HOME, '~')
            answers = prompt([
                {
                    'name': 'action',
                    'type': 'list',
                    'message': '%s already exists' % short_file_path,
                    'choices': [
                        'overwrite',
                        'overwrite all',
                        'backup',
                        'backup all',
                        'skip',
                        'skip all',
                    ]
                }
            ])

            if 'action' not in answers:
                exit(1)

            action = answers['action']
            overwrite = action == 'overwrite'
            link_dotfiles_overwrite_all = action == 'overwrite all'
            backup = action == 'backup'
            link_dotfiles_backup_all = action == 'backup all'
            skip = action == 'skip'
            link_dotfiles_skip_all = action == 'skip all'

        if overwrite or link_dotfiles_overwrite_all:
            os.remove(dest)
            puts(colored.yellow('deleted %s' % dest))

        if backup or link_dotfiles_backup_all:
            os.rename(dest, '%s.bak' % dest)
            puts(colored.cyan('moved %s to %s.bak' % (dest, dest)))

    if skip or link_dotfiles_skip_all:
        puts(colored.cyan('skipped %s' % dest))
    else:
        os.symlink(src, dest)
        puts('linked %s -> %s' % (src, dest))


def link_dotfiles(profile_name):
    puts(colored.magenta('>> Linking dotfiles to ~/'))
    link_dotfiles_dir(PATHS.HOMEDIR)
    link_dotfiles_dir('%s/%s/homedir' % (PATHS.DOTFILES_PRIVATE, profile_name))
    puts(colored.green('✔\n'))


def link_dotfiles_dir(home_dirname):
    # Link top-level dotfiles
    for _, _, filenames in os.walk(home_dirname):
        for filename in filenames:
            src = '%s/%s' % (home_dirname, filename)
            dest = '%s/%s' % (PATHS.HOME, filename)
            link_file(src, dest)
        # only linking the top-level files (i.e. max-depth=1)
        break

    # Link dotfiles that require a parent dir in homedir/
    for _, dirnames, _ in os.walk(home_dirname):
        for dirname in dirnames:
            dest_dir = '%s/%s' % (PATHS.HOME, dirname)
            for _, _, filenames in os.walk('%s/%s' % (home_dirname, dirname)):
                for filename in filenames:
                    src = '%s/%s/%s' % (home_dirname, dirname, filename)
                    dest = '%s/%s' % (dest_dir, filename)
                    if not os.path.isdir(dest_dir):
                        os.mkdir(dest_dir)
                    link_file(src, dest)
                # only linking top-level files in each dir (i.e. max-depth=1)
                break
        # only linking the top-level dirs (i.e. max-depth=1)
        break


def open_app_download_urls(urls):
    puts(colored.magenta('>> Opening download urls for non-casked apps:'))
    for url in urls:
        p = subprocess.Popen(['open', url])
        p.wait()
    puts(colored.green('✔\n'))


def write_shellvars_private(profile_name):
    puts(colored.magenta('>> Writing private profile vars:'))
    with open(PATHS.TEMPLATES_SHELLVARS_PRIVATE, 'r') as f:
        lines = f.readlines()
    with open(PATHS.HOMEDIR_SHELLVARS_PRIVATE, 'w+') as out:
        for line in lines:
            out.write(re.sub(r'export DOTFILES_PROFILE="DOTFILES_PROFILE"',
                             'export DOTFILES_PROFILE="%s"' % profile_name, line))
    puts(colored.green('✔\n'))


def write_git_config(profile_name):
    for git_workspace in profiles.read_git_workspaces(profile_name).values():
        if not git_workspace['primary']:
            continue

        user = git_workspace['user']
        email = git_workspace['email']
        puts(colored.magenta('>> Writing global gitconfig (primary user=%s):' % user))

        with open(PATHS.TEMPLATES_GITCONFIG, 'r') as f:
            lines = f.readlines()
        with open(PATHS.HOMEDIR_GITCONFIG, 'w+') as out:
            for line in lines:
                line = re.sub(r'GIT_AUTHOR_NAME', user, line)
                line = re.sub(r'GIT_AUTHOR_EMAIL', email, line)
                out.write(line)

        puts(colored.green('✔\n'))
        break


def write_ssh_config(profile_name):
    puts(colored.magenta('>> Writing SSH config:'))
    os.makedirs(PATHS.HOMEDIR_SSH, exist_ok=True)
    with open(PATHS.HOMEDIR_SSH_CONFIG, 'w+') as out:
        for git_workspace in profiles.read_git_workspaces(profile_name).values():
            user = git_workspace['user']
            host = git_workspace['ssh_config']['host']
            hostname = git_workspace['ssh_config']['hostname']

            lines = [
                '# %s @ %s' % (user, hostname),
                'Host %s' % host,
                '    HostName %s' % hostname,
                '    IdentityFile %s/%s/id_rsa' % (PATHS.SSH, user),
                '    User git',
            ]

            out.write('\n'.join(lines) + '\n\n')
            for line in lines:
                puts(line)
    puts(colored.green('✔\n'))


def main():
    jobs, selected_profile_name = ask_bootstrap_questions()

    if JOBS.LINK_DOTFILES in jobs:
        write_shellvars_private(selected_profile_name)
        create_git_workspace_dirs(selected_profile_name)
        write_ssh_config(selected_profile_name)
        write_git_config(selected_profile_name)
        link_dotfiles(selected_profile_name)

    if JOBS.UPGRADE_BREW_PACKAGES in jobs or JOBS.UPGRADE_BREW_CASKS in jobs:
        brew.update()
        brew_taps = profiles.read_brew_taps(selected_profile_name)
        brew.tap_all_repos(brew_taps)

    if JOBS.UPGRADE_BREW_PACKAGES in jobs:
        brew_formulae = profiles.read_brew_formulae(selected_profile_name)
        brew.install_or_upgrade_all_formulae(brew_formulae)

    if JOBS.UPGRADE_BREW_CASKS in jobs:
        brew_casks = profiles.read_brew_casks(selected_profile_name)
        brew.install_or_upgrade_all_casks(brew_casks)

    if JOBS.UPGRADE_GEM_RAKES in jobs:
        gem_rakes = profiles.read_gem_rakes(selected_profile_name)
        gem.install_or_upgrade_all_gems(gem_rakes)

    if JOBS.INSTALL_NVM in jobs:
        install_nvm()

    if JOBS.IMPORT_GPG_KEYS in jobs:
        import_gpg_keys(selected_profile_name)

    if JOBS.SYNC_GIT in jobs:
        git_sync.run(selected_profile_name)

    if JOBS.CONFIGURE_SETTINGS in jobs:
        configure_iterm2()
        configure_system_settings()

    if JOBS.INSTALL_FONTS in jobs:
        install_fonts()

    if JOBS.UPDATE_ZSH_THEME in jobs:
        install_or_update_powerlevel9k_theme()

    if JOBS.CHANGE_SHELL in jobs:
        change_shell_to_zsh()

    if JOBS.OPEN_NON_CASKED_APPS in jobs:
        app_download_urls = profiles.read_app_download_urls(
            selected_profile_name)
        open_app_download_urls(app_download_urls)


main()
