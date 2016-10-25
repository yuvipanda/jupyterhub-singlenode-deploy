define jupyterhub(
    $whitelist_users=true,
    $spawner='systemd',
    $spawner_settings={},
    $authenticator='dummy',
    $authenticator_settings={},
) {

    jupyterhub::hub { $name:
        whitelist_users => $whitelist_users,
    }

    $spawner_define = "jupyterhub::spawner::${spawner}"
    create_resources($spawner_define, {
        $name => $spawner_settings
    })

    $authenticator_define = "jupyterhub::authenticator::${authenticator}"
    create_resources($authenticator_define, {
        $name =>$authenticator_settings
    })
}
