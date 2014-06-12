# system imports
import json
import os

# internal imports
import log
from process import Process


def repo_exists(workspace_path, repo):
    return os.path.exists(os.path.join(workspace_path, repo['name']))


def remote_exists(workspace_path, repo, remote):
    repo_path = os.path.join(workspace_path, repo['name'])
    return Process('git remote | grep %s' % remote['name'], cwd=repo_path, silent=True).run().succeeded()


def setup_git_repo(workspace_path, repo):
    repo_path = os.path.join(workspace_path, repo['name'])
    log.info('cloning "%s" repo (%s) into %s' % (repo['name'], repo['origin'], repo_path))

    command = 'git clone %s %s' % (repo['origin'], repo['name'])
    Process(command,
            cwd=workspace_path,
            error_msg='cloning "%s" (%s) failed' % (repo['name'], repo['origin']),
            exit_on_fail=True).run()
    log.success('%s repo (%s) cloned into %s' % (repo['name'], repo['origin'], repo_path))

    upstream = repo['upstream']
    if upstream:
        log.info('adding upstream to %s' % repo['name'])
        command = 'git remote add upstream %s && git fetch %s' % (upstream, upstream)
        Process(command,
                cwd=repo_path,
                error_msg='adding upstream to %s failed' % repo['name'],
                exit_on_fail=True).run()


def add_git_remotes(workspace_path, repo):
    if not repo['remotes'] or len(repo['remotes']) == 0:
        return

    for remote in repo['remotes']:
        log.info(' - adding remote "%s" to %s' % (remote['name'], repo['name']))

        if not remote_exists(workspace_path, repo, remote):
            repo_path = os.path.join(workspace_path, repo['name'])
            Process('git remote add %s %s && git fetch %s' % (remote['name'], remote['url'], remote['name']),
                    cwd=repo_path,
                    exit_on_fail=True).run()
            log.success(' - remote "%s" added to %s' % (remote['name'], repo['name']))
        else:
            log.success(' - remote "%s" already exists in %s' % (remote['name'], repo['name']))


def setup_git_workspace(workspace):
    for repo in workspace['repos']:
        if not repo_exists(workspace['path'], repo):
            setup_git_repo(workspace['path'], repo)
        else:
            log.success('%s repo already exists' % repo['name'])

        add_git_remotes(workspace['path'], repo)


def run():
    git_workspaces = json.load(open('conf/git.json'))
    for workspace in git_workspaces:
        setup_git_workspace(workspace)


if __name__ == '__main__':
    run()