# = Define: jupyterhub::hub
#
# Sets up a jupyterhub+nchp instance.
#
# == Parameters
#
# [*title*]
#  The name of the JupyterHub installation
define jupyterhub::hub {
    require jupyterhub::base

    $base_dir = $::jupyterhub::base::dir
    $version = $::jupyterhub::base::version
    $venv_path = "${base_dir}/${name}"

    python::virtualenv { $venv_path:
        owner => 'root',
        group => 'root'
    }

    python::pip_package { 'jupyterhub':
        venv_path => $venv_path,
    }

    python::pip_package { 'nchp':
        venv_path => $venv_path,
        source    => 'git+https://github.com/yuvipanda/jupyterhub-nginx-chp.git@accesslog',
    }

    $service_name = "jupyterhub-${name}"
    systemd::unit_file { $service_name:
        content => template('jupyterhub/jupyterhub.service.erb'),
        notify  => Service[$service_name],
    }

    service { $service_name:
        ensure  => running,
        require => Systemd::Unit_file[$service_name],
    }

    $nchp_service_name = "nchp-${name}"
    systemd::unit_file { $nchp_service_name:
        content => template('jupyterhub/nchp.service.erb'),
        notify  => Service[$nchp_service_name],
    }

    service { $nchp_service_name:
        ensure  => running,
        require => Systemd::Unit_file[$nchp_service_name],
    }

    file { "${venv_path}/nchp_config.py":
        ensure  => present,
        source  => 'puppet:///modules/jupyterhub/nchp_config.py',
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        notify  => Service[$nchp_service_name],
        require => Python::Virtualenv[$venv_path]
    }

    file { "${venv_path}/bootstrap_config.py":
        ensure  => present,
        source  => 'puppet:///modules/jupyterhub/bootstrap_config.py',
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        notify  => Service[$service_name],
        require => Python::Virtualenv[$venv_path]
    }

    exec { "${name}-make-configproxy_auth_token":
        command => "/bin/echo CONFIGPROXY_AUTH_TOKEN=`/usr/bin/pwgen --secure -1 64` > ${venv_path}/configproxy_auth_token",
        creates => "${venv_path}/configproxy_auth_token",
    }

    file { "${venv_path}/config.d":
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0750',
        # Purge any config files we didn't explicitly put in there
        # DEATH TO MANUAL SSH BASED MODIFICATIONS
        recurse => true,
        purge   => true,
    }

    jupyterhub::config { "${name}-proxy":
        hubname => $name,
        content => "c.JupyterHub.proxy_cmd = '${venv_path}/bin/nchp'"
    }

    jupyterhub::config { "${name}-listen":
        hubname => $name,
        content => "c.JupyterHub.ip = '0.0.0.0'"
    }

    # Whitelist users
    $whitelisted_users = hiera('accounts::users', []) + hiera('accounts::roots', [])
    jupyterhub::config { "${name}-users-whitelist":
        hubname => $name,
        content => template('jupyterhub/users-whitelist.erb'),
    }

    # Setup roots to be admin users
    $admin_users = hiera('accounts::roots')
    jupyterhub::config { "${name}-admin-users":
        hubname => $name,
        content => template('jupyterhub/admin-users.erb'),
    }

    # Do not shut down singleuser services when we restart hub
    # This would be pretty bad, since we restart the hub often
    jupyterhub::config { "${name}-nosingleuser-kill":
        hubname => $name,
        content => "c.JupyterHub.cleanup_servers = False",
    }


}
