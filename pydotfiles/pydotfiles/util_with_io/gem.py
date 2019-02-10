from clint.textui import colored, puts, puts_err

from pydotfiles.util import gem


def install_gem(rake):
    puts(colored.magenta('>> gem install %s' % rake))
    success, _ = gem.install_gem(rake)

    if success:
        puts(colored.green('✔\n'))
        return True

    puts_err(colored.red('! failed to install: %s\n' % rake))
    return False


def install_or_upgrade_all_gems(rakes):
    for rake in rakes:
        rake_parts = rake.split(' ')
        if gem.is_gem_installed(rake_parts[0]):
            continue
        install_gem(rake)
    update_all()


def update_all():
    puts(colored.magenta('>> gem update'))
    success, _ = gem.update_all()
    if success:
        puts(colored.green('✔\n'))
    else:
        puts_err(colored.red('! failed to update gems\n'))
