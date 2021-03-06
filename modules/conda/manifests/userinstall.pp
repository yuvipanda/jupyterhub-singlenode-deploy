# = Define: conda::install
#
# Install the current version of Conda with the given prefix.
#
# Note that this does not upgrade existing installations. If users want
# to upgrade conda, they should do so themselves.
# == Parameters
#
# [*user*]
#  User in whose homedir to install conda.
define conda::userinstall(
    $user = $name,
) {
    require ::conda::installer

    $installer_path = $::conda::installer::path
    $prefix = "/home/${user}/conda"

    exec { "install-conda-${prefix}":
        command   => "${installer_path} -p ${prefix} -b",
        unless    => "/usr/bin/test -f ${prefix}/bin/python",
        timeout   => 300, # 5 minutes, worst case
        logoutput => 'on_failure',
        user      => $user,
    }

    # Install jupyterhub using pip on the conda install too,
    # so we have access to jupyterhub-singleuser
    # FIXME: Make sure this gets upgraded in sync with the parent jupytehrub
    python::pip_package { "${user}-jupyterhub":
        venv_path => "${prefix}",
        package   => "jupyterhub",
    }

    # JupyterHub 0.7.2 seems to depend on too old a version of traitlets
    python::pip_package { "${user}-traitlets":
        venv_path => "${prefix}",
        package   => "traitlets",
        version   => '4.3.2'
    }
}
