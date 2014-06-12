import json
import subprocess


def run():
    apps = json.load(open('conf/applications.json'))
    urls = [app['url'] for app in apps]
    commands = ['open %s' % url for url in urls]

    proc = subprocess.Popen([';'.join(commands)], shell=True, stdin=subprocess.PIPE)
    proc.communicate()


if __name__ == '__main__':
    run()