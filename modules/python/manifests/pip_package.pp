define python::pip_package(
    $ensure = present,
    $venv_path,
    $package = $name
) {

    # FIXME: Make this actually be useful
    exec { "pip-install-${name}":
        command => "${venv_path}/bin/pip install ${package}",
        unless  => "${venv_path}/bin/pip freeze | grep -i -e '^${package}=='",
        user    => 'root',
        group   => 'root',
    }
}
