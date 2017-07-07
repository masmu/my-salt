import psutil
import subprocess
import os

class Subprocess(subprocess.Popen):
    def __init__(self, cmd, uid=None, gid=None, cwd=None, env=None,
                 *args, **kwargs):
        self.uid = uid
        self.gid = gid
        self.cwd = cwd
        self.env = env

        super(Subprocess, self).__init__(
            cmd,
            preexec_fn=self.demote(uid, gid), cwd=cwd, env=env,
            bufsize=1, universal_newlines=True, *args, **kwargs)

    def demote(self, uid, gid):
        def fn_uid_gid():
            os.setgid(gid)
            os.setuid(uid)

        def fn_uid():
            os.setuid(uid)

        def fn_gid():
            os.setgid(gid)

        def fn_nop():
            pass

        if uid and gid:
            return fn_uid_gid
        elif uid:
            return fn_uid
        elif gid:
            return fn_gid
        return fn_nop

def _get_pid_env(pid):
    env = {}
    location = '/proc/{pid}/environ'.format(pid=pid)
    try:
        with open(location) as f:
            content = f.read()
        for line in content.split('\0'):
            try:
                key, value = line.split('=', 1)
                env[key] = value
            except ValueError:
                pass
        return env
    except IOError:
        return None

SHELL_PROCESSES = {
    None: {
        'uid': None,
        'gid': None,
        'env': None,
    },
}

for proc in psutil.process_iter():
    if proc.name() in ('gnome-shell', 'i3'):
        uid = proc.uids()[0]
        SHELL_PROCESSES[uid] = {
            'uid': uid,
            'gid': proc.gids()[0],
            'env': _get_pid_env(proc.pid),
        }

def run_as_user(cmd, uid=None, stdin=None):
    shell = SHELL_PROCESSES[uid]
    proc = Subprocess(
        cmd,
        uid=shell['uid'], gid=shell['gid'], env=shell['env'],
        stdout=subprocess.PIPE, stdin=subprocess.PIPE,
        stderr=subprocess.PIPE)
    if stdin:
        data, err = proc.communicate(input=stdin)
    else:
        data, err = proc.communicate()
    proc.wait()
    return proc, data.strip()
