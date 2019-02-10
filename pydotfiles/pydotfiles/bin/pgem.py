import os
import re
import subprocess
from sys import exit

from clint.textui import colored, puts, puts_err
from PyInquirer import prompt

from pydotfiles.util_with_io import gem, git, profiles
from pydotfiles.constants import PATHS


class GemCommand:
    def __init__(self, input_name, command_runner, json_updater):
        self.input_name = input_name
        self.command_runner = command_runner
        self.json_updater = json_updater


GEM_INSTALL_RAKE = GemCommand(
    'Rake',
    gem.install_gem,
    profiles.update_profile_add_gem_rake)


def run(gem_command):
    git.dotfiles_private_pull_latest()

    profile = profiles.get_current_name(exit_if_not_set=True)
    profile_names = profiles.read_names()
    profile_choices = [{'name': n, 'checked': n == profile}
                       for n in profile_names]
    answers = prompt([
        {
            'name': 'input',
            'type': 'input',
            'message': '%s:' % gem_command.input_name,
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

    if gem_command.command_runner(input):
        for profile_name in selected_profiles:
            gem_command.json_updater(profile_name, input)
        git.dotfiles_private_commit_and_push_changes(
            'Gem %s: %s' % (gem_command.input_name, input))
