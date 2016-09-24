# = Class: localaccounts
#
# Sets up local unix users belonging to a group.
#
# This should be used in conjugation with jupyterhub spawners that
# require users exist as unix users on the system to function properly.
#
# It also provides roots with passwordless sudo.
#
# It can also install conda for all of the users when creating them.
#
# FIXME: Find a way to get rid of accounts when they are no longer in use.
# == Parameters
#
# [*group*]
#  Group to add all users to. Useful when there are users managed via
#  other means on the system.
#
# [*userinstall*]
#  What to install for each user account. Options are 'conda' or undef.
#  FIXME: Add virtualenv
class localaccounts(
    $group = 'jovian',
    $userinstall = undef,
) {

    $regular_users = hiera('accounts::users', [])
    $root_users = hiera('accounts::roots', [])

    file { '/etc/sudoers.d/localaccounts_sudo':
        ensure  => present,
        mode    => '0444',
        owner   => 'root',
        group   => 'root',
        content => '%sudo ALL=(ALL) NOPASSWD:ALL',
    }

    group { $group:
        ensure => present,
    }

    user { $regular_users:
        ensure     => present,
        managehome => true,
        groups     => $group
    }

    user { $root_users:
        groups => [$group, 'sudo'],
    }

    if $userinstall == 'conda' {
        $all_users = $regular_users + $root_users
        conda::userinstall { $all_users:
            require => [
                User[$regular_users],
                User[$root_users],
            ]
        }
    }
}
