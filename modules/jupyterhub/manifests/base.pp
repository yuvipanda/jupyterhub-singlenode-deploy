# = Class: jupyterhub::base
# Sets up base packages / files required for all jupyterhubs
#
# Has the following responsibilities:
#   1. Install a given version of python + virtualenv
#   2. Setup a base directory inside which individual jupyterhub
#      virtualenvs and config ix kept
#
# Do not use directly, is included from jupyterhub::hub defines.
#
# == Parameters
#
# [*dir*]
#  Base directory inside which all jupyterhub virtualenvs / config is setup
#
# [*version*]
#  Version of python to setup. Supported: 3.4, 3.5.
#  This class uses the system package manager (apt-get, yum, dnf, etc) to install
#  python & virtualenv.
#  FIXME: Add validation/autodetection based on distro
class jupyterhub::base(
    $dir = '/srv/jhubs',
    $version = '3.5'
) {
    file { $dir:
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0700',
    }

    # nchp packages
    package { [
        'nginx-extras',
        'lua-cjson',
    ]:
        ensure => present,
    }

    # To prevent the nginx from autostarting after install
    service { 'nginx':
        ensure   => stopped,
        provider => systemd,
    }

    # For generating CONFIGPROXY_AUTH_TOKEN
    package { 'pwgen':
        ensure => present,
    }
}
