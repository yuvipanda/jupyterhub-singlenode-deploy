# = define: jupyterhub::authenticator::dummy
#
# Sets up a dummy authenticator for a given jupyterhub
#
# == Parameters
#
# [*hubname*]
#  The name of the jupyterhub::hub for which this authenticator
#  is to be set up. Required.
#
define jupyterhub::authenticator::dummy(
    $hubname = $name,
) {

    include jupyterhub::base

    $base_dir = $::jupyterhub::base::dir

    python::pip_package { 'jupyterhub-dummyauthenticator':
        ensure => present,
        venv_path => "${base_dir}/${hubname}"
    }

    jupyterhub::config { 'dummyauthenticator':
        hubname => $hubname,
        content => "c.JupyterHub.authenticator_class = 'dummyauthenticator.DummyAuthenticator'"
    }

}
