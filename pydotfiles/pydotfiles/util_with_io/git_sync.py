import os

from pydotfiles.constants import PATHS
from pydotfiles.util_with_io import git, profiles


def run(profile_name=None):
    # Sync each git workspace for this profile.
    git_workspaces = profiles.read_git_workspace_names(profile_name)
    for workspace_name in git_workspaces:
        workspace_path = os.path.join(
            PATHS.DEV_WORKSPACE, workspace_name)
        git_configs = profiles.read_git_workspace_config(
            workspace_name, profile_name)
        ssh_config = profiles.read_git_workspace_ssh_config(
            workspace_name, profile_name)
        repos = profiles.read_git_workspace_repo_items(
            workspace_name, profile_name)

        for dirname, url in repos:
            # Clone repo if not already cloned.
            repo_path = os.path.join(workspace_path, dirname)
            if not os.path.isdir(repo_path):
                mapped_url = url.replace(
                    ssh_config['hostname'], ssh_config['host'])
                git.clone(mapped_url, dirname, cwd=workspace_path)

            # Always set git configs to ensure they're up-to-date.
            git.set_configs(git_configs, cwd=repo_path)

            # Add remotes that aren't already added.
            remotes = profiles.read_git_workspace_repo_remote_items(
                workspace_name, dirname, profile_name)
            for remote_name, remote_url in remotes:
                if not git.remote_exists(repo_path, remote_name):
                    git.add_remote(remote_name, remote_url, cwd=repo_path)
