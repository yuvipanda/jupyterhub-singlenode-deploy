define python::pip_package(
    $ensure = present,
    $venv_path,
    $package = $name
) {

    exec { "pip_install-${name}":
        command => "${venv_path}/bin/pip install ${package}",
        unless  => "${venv_path}/bin/pip freeze | grep -i -e '^${name}=='",
        user    => 'root',
        group   => 'root',
        require => Python::Virtualenv[$venv_path],
    }
}
