# = Class: python::base
#
# Sets up a given version of python+virtualenv via the distro's package manager.
#
# == Parameters
# [*version*]
#  Version of python to install.
#  FIXME: autodetect based on distro
class python::base(
    $version='3.5'
) {
    # FIXME: Make this work for centos / fedora
    package { "python${version}":
        ensure => present,
    }

    package { "virtualenv":
        ensure => present,
    }
}
