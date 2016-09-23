# = define: jupyterhub::authenticator::github
#
# Sets up a github authenticator for a given jupyterhub
#
# == Parameters
#
# [*hubname*]
#  The name of the jupyterhub::hub for which this authenticator
#  is to be set up. Required.
#
# [*callback_url*]
#  The OAuth callback URL setup for the github OAuth application
#
# [*client_id*]
#  The client id provided by the github OAuth application
#
# [*client_secret*]
#  The client secret provided by the github OAuth application
define jupyterhub::authenticator::github(
    $callback_url,
    $client_id,
    $client_secret,
    $hubname = $name,
) {

    include jupyterhub::base

    $base_dir = $::jupyterhub::base::dir

    python::pip_package { 'oauthenticator':
        ensure    => present,
        venv_path => "${base_dir}/${hubname}"
    }

    jupyterhub::config { 'githubauthenticator':
        hubname => $hubname,
        content => template('jupyterhub/authenticator/github_config.erb'),
    }
}
