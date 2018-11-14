import os
import re
import subprocess
from sys import exit

from clint.textui import colored, puts, puts_err
from PyInquirer import prompt

from pydotfiles.util_with_io import brew, git, profiles
from pydotfiles.constants import PATHS


class BrewCommand:
    def __init__(self, input_name, command_runner, json_updater):
        self.input_name = input_name
        self.command_runner = command_runner
        self.json_updater = json_updater


BREW_INSTALL_FORMULA = BrewCommand(
    'Formula',
    brew.install_formula,
    profiles.update_profile_add_brew_formula)
BREW_INSTALL_CASK = BrewCommand(
    'Cask',
    brew.install_cask,
    profiles.update_profile_add_brew_cask)
BREW_TAP = BrewCommand(
    'Tap',
    brew.tap_repo,
    profiles.update_profile_add_brew_tap)
BREW_UNINSTALL_FORMULA = BrewCommand(
    'Uninstall Formula',
    brew.uninstall_formula,
    profiles.update_profile_remove_brew_formula)
BREW_UNINSTALL_CASK = BrewCommand(
    'Uninstall Cask',
    brew.uninstall_cask,
    profiles.update_profile_remove_brew_cask)
BREW_UNTAP = BrewCommand(
    'Untap',
    brew.untap_repo,
    profiles.update_profile_remove_brew_tap)


def run(brew_command):
    git.dotfiles_private_pull_latest()

    profile = profiles.get_current_name(exit_if_not_set=True)
    profile_names = profiles.read_names()
    profile_choices = [{'name': n, 'checked': n == profile}
                       for n in profile_names]
    answers = prompt([
        {
            'name': 'input',
            'type': 'input',
            'message': '%s:' % brew_command.input_name,
        },
        {
            'name': 'profiles',
            'type': 'checkbox',
            'message': 'Which profiles should this affect:',
            'choices': profile_choices,
        },
    ])

    if 'input' not in answers or 'profiles' not in answers:
        exit(1)

    selected_profiles = answers['profiles']
    input = answers['input']

    if brew_command.command_runner(input):
        for profile_name in selected_profiles:
            brew_command.json_updater(profile_name, input)
        git.dotfiles_private_commit_and_push_changes(
            'Brew %s: %s' % (brew_command.input_name, input))
