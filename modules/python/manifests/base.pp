# = Class: python::base
#
# Sets up a given version of python+virtualenv via the distro's package manager.
class python::base {
    if $::os['name'] == 'Debian' and $::os['release']['major'] == '8' {
        # Debian Jessie! Python 3.4
        $version = '3.4'
    } else {
        $version = '3.5'
    }

    # FIXME: Make this work for centos / fedora
    package { "python${version}":
        ensure => present,
    }

    package { "virtualenv":
        ensure => present,
    }
}
