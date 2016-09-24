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
define jupyterhub::spawner::systemd(
    $hubname = $name,
    $userinstall = 'conda',
    $mem_limit = undef,
) {

    include jupyterhub::base

    $base_dir = $::jupyterhub::base::dir

    python::pip_package { 'jupyterhub-systemdspawner':
        ensure    => present,
        venv_path => "${base_dir}/${hubname}",
        package   => 'git+https://github.com/jupyterhub/systemdspawner.git@master'
    }

    jupyterhub::config { 'systemdspawner':
        hubname => $hubname,
        content => "c.JupyterHub.spawner_class = 'systemdspawner.SystemdSpawner'",
    }

    jupyterhub::config { "${hubname}-unit-name":
        hubname => $hubname,
        content => "c.SystemdSpawner.unit_name_template = 'jupyter-${hubname}-{USERID}-singleuser'",
    }

    if $userinstall == 'conda' {
        jupyterhub::config { 'conda-user-install':
            hubname => $hubname,
            content => "c.SystemdSpawner.cmd = ['/home/{USERNAME}/conda/bin/jupyterhub-singleuser']",
        }

        jupyterhub::config { 'conda-path':
            hubname => $hubname,
            content => "c.SystemdSpawner.extra_paths = ['/home/{USERNAME}/conda/bin']"
        }
    }

    if $mem_limit {
        jupyterhub::config { 'memory-limit':
            hubname => $hubname,
            content => "c.SystemdSpawner.mem_limit = '${mem_limit}'"
        }

    }
}
