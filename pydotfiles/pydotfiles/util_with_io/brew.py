from clint.textui import colored, puts, puts_err

from pydotfiles.util import brew


def install_cask(cask):
    puts(colored.magenta('>> brew cask install %s' % cask))
    success, _ = brew.install_cask(cask)

    if success:
        puts(colored.green('✔\n'))
        return True

    puts_err(colored.red('! failed to install: %s\n' % cask))
    return False


def install_formula(formula):
    puts(colored.magenta('>> brew install %s' % formula))
    success, _ = brew.install_formula(formula)

    if success:
        puts(colored.green('✔\n'))
        return True

    puts_err(colored.red('! failed to install: %s\n' % formula))
    return False


def install_or_upgrade_all_casks(casks):
    for cask in casks:
        if brew.is_cask_installed(cask):
            upgrade_cask(cask)
        else:
            install_cask(cask)


def install_or_upgrade_all_formulae(formulae):
    for formula in formulae:
        formula_parts = formula.split(' ')
        if brew.is_formula_installed(formula_parts[0]):
            continue
        install_formula(formula)
    upgrade_all()


def tap_repo(repo):
    puts(colored.magenta('>> brew tap %s' % repo))
    success, _ = brew.tap_repo(repo)

    if success:
        puts(colored.green('✔\n'))
        return True

    puts_err(colored.red('! failed to tap: %s\n' % repo))
    return False


def tap_all_repos(repos):
    for repo in repos:
        if brew.is_repo_tapped(repo):
            continue
        tap_repo(repo)


def uninstall_cask(cask):
    puts(colored.magenta('>> brew cask uninstall %s' % cask))
    success, _ = brew.uninstall_cask(cask)
    if success:
        puts(colored.green('✔\n'))
        return True

    puts_err(colored.red('! failed to uninstall cask %s\n' % cask))
    return False


def uninstall_formula(formula):
    puts(colored.magenta('>> brew uninstall %s' % formula))
    success, _ = brew.uninstall_formula(formula)
    if success:
        puts(colored.green('✔\n'))
        return True

    puts_err(colored.red('! failed to uninstall %s\n' % formula))
    return False


def untap_repo(repo):
    puts(colored.magenta('>> brew untap %s' % repo))
    success, _ = brew.untap_repo(repo)
    if success:
        puts(colored.green('✔\n'))
        return True

    puts_err(colored.red('! failed to untap %s\n' % repo))
    return False


def update():
    puts(colored.magenta('>> brew update'))
    success, return_code = brew.update()
    if success:
        puts(colored.green('✔\n'))
    else:
        puts_err(colored.red('! Failed to update brew\n'))
        exit(return_code)


def upgrade_all():
    puts(colored.magenta('>> brew upgrade'))
    success, _ = brew.upgrade_all()
    if success:
        puts(colored.green('✔\n'))
    else:
        puts_err(colored.red('! failed to upgrade brew packages\n'))


def upgrade_cask(cask):
    puts(colored.magenta('>> brew cask upgrade %s' % cask))
    success, _ = brew.upgrade_cask(cask)
    if success:
        puts(colored.green('✔\n'))
    else:
        puts_err(colored.red('! Failed to upgrade cask: %s' % cask))
