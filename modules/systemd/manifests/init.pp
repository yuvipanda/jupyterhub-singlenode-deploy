class systemd {
    # This will make puppet fail if systemd isn't installed
    package {'systemd':
        ensure => present,
    }

    exec { 'systemctl-daemon-reload':
        command     => '/bin/systemctl daemon-reload',
        refreshonly => true,
    }
}
