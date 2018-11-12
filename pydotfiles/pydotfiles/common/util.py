import io
import json
import os
import re
import subprocess
import sys

from clint.textui import colored, puts, puts_err

from pydotfiles.common.constants import PATHS
from pydotfiles.common import profiles

cached_brew_list = None
cached_brew_cask_list = None
cached_brew_tap_list = None


def install_brew_cask(cask):
    puts(colored.magenta('>> brew cask install %s' % cask))
    p = subprocess.Popen(['brew', 'cask', 'install', cask])
    return_code = p.wait()

    if return_code == 0:
        puts(colored.green('✔'))
        puts('')
        return True

    puts_err(colored.red('! failed to install: %s' % cask))
    puts('')
    return False


def install_brew_formula(formula):
    puts(colored.magenta('>> brew install %s' % formula))
    p = subprocess.Popen(['brew', 'install', formula])
    return_code = p.wait()

    if return_code == 0:
        puts(colored.green('✔'))
        puts('')
        return True

    puts_err(colored.red('! failed to install: %s' % formula))
    puts('')
    return False


def install_or_upgrade_brew_casks(profile_name=None):
    puts(colored.magenta('>> Installing/upgrading brew casks:'))
    for cask in profiles.read_brew_casks(profile_name):
        command = 'upgrade' if is_brew_cask_installed(cask) else 'install'
        puts(colored.cyan('brew cask %s %s' % (command, cask)))
        p = subprocess.Popen(['brew', 'cask', command, cask])
        return_code = p.wait()
        if return_code == 0:
            puts(colored.green('✔'))
        else:
            puts_err(colored.red('! failed to %s: %s' % (command, cask)))
        puts('')
    puts('')


def install_or_upgrade_brew_formulae(profile_name=None):
    for formula in profiles.read_brew_formulae(profile_name):
        formula_parts = formula.split(' ')
        if is_brew_formula_installed(formula_parts[0]):
            continue
        install_brew_formula(formula)
    upgrade_brew()


def is_brew_cask_installed(cask):
    global cached_brew_cask_list
    if cached_brew_cask_list is None:
        brew_cask_list_proc = subprocess.Popen(
            ['brew', 'cask', 'list'], stdout=subprocess.PIPE)
        brew_cask_list_proc.text_mode = True
        stdout, _ = brew_cask_list_proc.communicate()
        cached_brew_cask_list = str(stdout)

    return cask in cached_brew_cask_list


def is_brew_formula_installed(formula):
    global cached_brew_list
    if cached_brew_list is None:
        brew_list_proc = subprocess.Popen(
            ['brew', 'list'], stdout=subprocess.PIPE)
        brew_list_proc.text_mode = True
        stdout, _ = brew_list_proc.communicate()
        cached_brew_list = str(stdout)

    return formula in cached_brew_list


def is_brew_repo_tapped(repo):
    global cached_brew_tap_list
    if cached_brew_list is None:
        brew_list_proc = subprocess.Popen(
            ['brew', 'tap'], stdout=subprocess.PIPE)
        brew_list_proc.text_mode = True
        stdout, _ = brew_list_proc.communicate()
        cached_brew_tap_list = str(stdout)

    return repo in cached_brew_tap_list


def tap_brew_repo(repo):
    puts(colored.magenta('>> brew tap %s' % repo))
    p = subprocess.Popen(['brew', 'tap', repo])
    return_code = p.wait()

    if return_code == 0:
        puts(colored.green('✔'))
        puts('')
        return True

    puts_err(colored.red('! failed to tap: %s' % repo))
    puts('')
    return False


def tap_brew_repos(profile_name=None):
    for repo in profiles.read_brew_taps(profile_name):
        if is_brew_repo_tapped(repo):
            continue
        tap_brew_repo(repo)


def update_brew():
    puts(colored.magenta('>> brew update'))
    p = subprocess.Popen(['brew', 'update'])
    return_code = p.wait()
    if return_code == 0:
        puts(colored.green('✔'))
    else:
        puts_err(colored.red('! Failed to update brew'))
        sys.exit(return_code)
    puts('')


def upgrade_brew():
    puts(colored.magenta('>> brew upgrade'))
    p = subprocess.Popen(['brew', 'upgrade'])
    return_code = p.wait()
    if return_code == 0:
        puts(colored.green('✔'))
    else:
        puts_err(colored.red('! failed to upgrade brew packages'))
    puts('')
