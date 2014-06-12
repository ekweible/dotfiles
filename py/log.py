import sys


def write(msg):
    sys.stdout.write(msg)
    sys.stdout.flush()


def info(msg):
    write('[\033[00;34m..\033[0m] %s' % msg)


def user(msg):
    write('\r[\033[0;33m?\033[0m] %s ' % msg)


def success(msg):
    write('\r\033[2K[\033[00;32mOK\033[0m] %s\n' % msg)


def error(msg):
    write('\r\033[2K[\033[00;31mERR\033[0m] %s\n' % msg)


def fail(msg):
    write('\r\033[2K[\033[0;31mFAIL\033[0m] %s\n\n' % msg)
    sys.exit(1)