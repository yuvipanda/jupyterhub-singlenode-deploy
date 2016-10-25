# = define: jupyterhub::authenticator::firstuse
#
# Sets up a firstuse authenticator for a given jupyterhub.
# This allows users to set their password on their first login.
#
# == Parameters
#
# [*hubname*]
#  The name of the jupyterhub::hub for which this authenticator
#  is to be set up. Required.
#
define jupyterhub::authenticator::firstuse(
    $hubname = $name,
) {

    include jupyterhub::base

    $base_dir = $::jupyterhub::base::dir

    python::pip_package { 'jupyterhub-firstuseauthenticator':
        ensure => present,
        venv_path => "${base_dir}/${hubname}"
    }

    jupyterhub::config { 'firstuseauthenticator':
        hubname => $hubname,
        content => template('jupyterhub/authenticator/firstuse_config.erb'),
    }
}
