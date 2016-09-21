# = Define: conda::install
#
# Install the current version of Conda with the given prefix.
#
# Note that this does not upgrade existing installations. If users want
# to upgrade conda, they should do so themselves.
# == Parameters
#
# [*prefix*]
#  Path in which to install conda. Must not already exist.
define conda::install(
    $prefix = $name,
) {
    require ::conda::installer

    $installer_path = $::conda::installer::path

    exec { "install-conda-${prefix}":
        command   => "${installer_path} -p ${prefix} -b",
        unless    => "/usr/bin/test -f ${prefix}/bin/python",
        timeout   => 300, # 5 minutes, worst case
        logoutput => 'on_failure',
    }
}
