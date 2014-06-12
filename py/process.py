# system imports
import subprocess
import sys

# internal imports
import log


class Process(object):

    def __init__(self, command, cwd=None, error_msg='', exit_on_fail=False, silent=False):
        self.command = command
        if cwd:
            self.command = 'cd %s && %s' % (cwd, self.command)
        self.error_msg = error_msg
        self.exit_on_fail=exit_on_fail
        self.silent = silent
        self.proc = None
        self.stdout, self.stderr = '', ''

    def run(self):
        self.proc = subprocess.Popen([self.command], shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        self.stdout, self.stderr = self.proc.communicate()

        if self.failed():
            error_msg = self.error_msg
            if self.stdout:
                error_msg = '%s\n\n%s' % (error_msg, self.stdout)
            if self.stderr:
                error_msg = '%s\n\n%s' % (error_msg, self.stderr)

            if self.silent:
                if self.exit_on_fail:
                    sys.exit(1)
                else:
                    return self

            else:
                if self.exit_on_fail:
                    log.fail(error_msg)
                else:
                    log.error(error_msg)

        return self

    def succeeded(self):
        if not self.proc:
            raise Exception('Process has not run yet, cannot check status.')
        return self.proc.returncode == 0

    def failed(self):
        return not self.succeeded()