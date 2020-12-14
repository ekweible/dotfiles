import subprocess


cached_brew_cask_list = None
cached_brew_list = None
cached_brew_tap_list = None


def install_cask(cask):
    p = subprocess.Popen(['brew', 'install', '--cask', cask])
    return_code = p.wait()
    return return_code == 0, return_code


def install_formula(formula):
    p = subprocess.Popen(['brew', 'install', formula])
    return_code = p.wait()
    return return_code == 0, return_code


def is_cask_installed(cask):
    global cached_brew_cask_list
    if cached_brew_cask_list is None:
        brew_cask_list_proc = subprocess.Popen(
            ['brew', 'cask', 'list'], stdout=subprocess.PIPE)
        brew_cask_list_proc.text_mode = True
        stdout, _ = brew_cask_list_proc.communicate()
        cached_brew_cask_list = str(stdout)

    return cask in cached_brew_cask_list


def is_formula_installed(formula):
    global cached_brew_list
    if cached_brew_list is None:
        brew_list_proc = subprocess.Popen(
            ['brew', 'list'], stdout=subprocess.PIPE)
        brew_list_proc.text_mode = True
        stdout, _ = brew_list_proc.communicate()
        cached_brew_list = str(stdout)

    return formula in cached_brew_list


def is_repo_tapped(repo):
    global cached_brew_tap_list
    if cached_brew_list is None:
        brew_list_proc = subprocess.Popen(
            ['brew', 'tap'], stdout=subprocess.PIPE)
        brew_list_proc.text_mode = True
        stdout, _ = brew_list_proc.communicate()
        cached_brew_tap_list = str(stdout)

    return repo in cached_brew_tap_list


def tap_repo(repo):
    p = subprocess.Popen(['brew', 'tap', repo])
    return_code = p.wait()
    return return_code == 0, return_code


def uninstall_cask(cask):
    p = subprocess.Popen(['brew', 'uninstall', '--cask', cask])
    return_code = p.wait()
    return return_code == 0, return_code


def uninstall_formula(formula):
    p = subprocess.Popen(['brew', 'uninstall', formula])
    return_code = p.wait()
    return return_code == 0, return_code


def untap_repo(repo):
    p = subprocess.Popen(['brew', 'untap', repo])
    return_code = p.wait()
    return return_code == 0, return_code


def update():
    p = subprocess.Popen(['brew', 'update'])
    return_code = p.wait()
    return return_code == 0, return_code


def upgrade_all():
    p = subprocess.Popen(['brew', 'upgrade'])
    return_code = p.wait()
    return return_code == 0, return_code


def upgrade_cask(cask):
    p = subprocess.Popen(['brew', 'upgrade', '--cask', cask])
    return_code = p.wait()
    return return_code == 0, return_code
