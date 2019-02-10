import subprocess


cached_gem_list = None


def install_gem(rake):
    p = subprocess.Popen(['gem', 'install', rake])
    return_code = p.wait()
    return return_code == 0, return_code


def is_gem_installed(rake):
    global cached_gem_list
    if cached_gem_list is None:
        gem_list_proc = subprocess.Popen(['gem', 'list'], stdout=subprocess.PIPE)
        gem_list_proc.text_mode = True
        stdout, _ = gem_list_proc.communicate()
        cached_gem_list = str(stdout)

    return rake in cached_gem_list


def update_all():
    p = subprocess.Popen(['gem', 'update'])
    return_code = p.wait()
    return return_code == 0, return_code
