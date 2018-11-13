import os
import re
import subprocess
from sys import exit

from clint.textui import colored, puts, puts_err
from PyInquirer import prompt

from pydotfiles.common import profiles
from pydotfiles.common.constants import PATHS
from pydotfiles.common import util


class BrewCommand:
    def __init__(self, input_name, command_runner, json_updater):
        self.input_name = input_name
        self.command_runner = command_runner
        self.json_updater = json_updater


BREW_INSTALL_FORMULA = BrewCommand(
    'Formula',
    util.install_brew_formula,
    profiles.update_profile_add_brew_formula)
BREW_INSTALL_CASK = BrewCommand(
    'Cask',
    util.install_brew_cask,
    profiles.update_profile_add_brew_cask)
BREW_TAP = BrewCommand(
    'Tap',
    util.tap_brew_repo,
    profiles.update_profile_add_brew_tap)
# BREW_UNINSTALL_FORMULA = BrewCommand(
#     'Formula',
#     # ['brew', 'uninstall'],
#     profiles.update_profile_remove_brew_formula)
# BREW_UNINSTALL_CASK = BrewCommand(
#     'Cask',
#     # ['brew', 'cask', 'uninstall'],
#     profiles.update_profile_remove_brew_cask)
# BREW_UNTAP = BrewCommand(
#     'Tap',
#     # ['brew', 'untap'],
#     profiles.update_profile_remove_brew_tap)


def run_brew(brew_command):
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
            'message': 'Which profiles should this be associated with:',
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
        profiles.commit_and_push_changes(
            'Brew %s: %s' % (brew_command.input_name, input))
