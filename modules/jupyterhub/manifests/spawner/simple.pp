# = define: jupyterhub::spawner::simple
#
# Sets up a simple process spawner (no user isolation) for the jupyterhub
#
# == Parameters
#
# [*hubname*]
#  The name of the jupyterhub::hub for which this spawner
#  is to be set up. Required.
#
define jupyterhub::spawner::simple(
    $hubname = $name,
) {

    include jupyterhub::base

    $base_dir = $::jupyterhub::base::dir

    python::pip_package { 'jupyterhub-simplespawner':
        ensure    => present,
        venv_path => "${base_dir}/${hubname}"
    }

    jupyterhub::config { 'simplespawner':
        hubname => $hubname,
        content => "c.JupyterHub.spawner_class = 'simplespawner.SimpleLocalProcessSpawner'",
    }

    # Setup singleuser stuff in the jupyterhub venv

    python::pip_package { [
        'jupyter',
        'notebook',
    ]:
        ensure => present,
        venv_path => "${base_dir}/${hubname}"
    }

    jupyterhub::config { 'simplespawner-from-venv':
        hubname => $hubname,
        content => "c.SimpleLocalProcessSpawner.cmd = ['${base_dir}/${hubname}/bin/jupyterhub-singleuser']"
    }

}
