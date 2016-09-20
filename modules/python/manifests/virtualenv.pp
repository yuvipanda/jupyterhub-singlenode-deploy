define python::virtualenv(
    $path = $name,
    $owner,
    $group,
) {

    require ::python::base

    exec { 'create_venv':
        command => "/usr/bin/virtualenv -p python3 ${path}",
        creates => "${path}/bin/python3",
    }
}
