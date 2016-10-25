node default {
    create_resources(jupyterhub, hiera('jupyterhubs'))

}
