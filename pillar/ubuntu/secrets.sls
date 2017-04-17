{% import_yaml 'ubuntu/config.sls' as config %}
twitch_oauth_token: abcdefghijklmnopqrstuvwxyz
hosts:
  8.8.8.8: box
  192.168.1.10: pi
netrc:
  lancode.de:
    login: user
    password: pass
mounts:
  {{ config['home'] }}/.mnt/lancode.de:
    type: 'ftp'
    server: 'lancode.de'
    remote_dir: '/'
  {{ config['home'] }}/.mnt/pi:
    type: 'ssh'
    server: 'pi'
    user: 'pi'
    remote_dir: '/home/pi'
ssh_config:
  pi:
    HostName: 'pi'
    User: 'pi'
    ForwardAgent: 'no'
    ForwardX11: 'no'
    Protocol: 2
    ServerAliveInterval: 10
    ExitOnForwardFailure: 'yes'
ssh_keys:
  id_rsa:
    public: |
            ssh-rsa ABC
    secret: |
            -----BEGIN RSA PRIVATE KEY-----
            ABC
            -----END RSA PRIVATE KEY-----
dput_config:
  patched:
    fqdn: ppa.launchpad.net
    method: ftp
    incoming: ~user/patched/ubuntu/
    login: anonymous
    allow_unsigned_uploads: 0
sitecopy_config:
  lancode:
    server: lancode.de
    port: 21
    username: root
    local: {{ config['home'] }}/www/lancode.de
    remote: /
gnupg_config:
  1234ABCD:
    public: |
            -----BEGIN PGP PUBLIC KEY BLOCK-----
            ABC
            -----END PGP PRIVATE KEY BLOCK-----
git_config:
    user:
        email: test@mail.de
        name: Max Mustermann