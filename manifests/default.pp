node default {
    create_resources(jupyterhub, hiera('jupyterhubs'))

    class { 'localaccounts':
        userinstall => 'conda',
    }
}
