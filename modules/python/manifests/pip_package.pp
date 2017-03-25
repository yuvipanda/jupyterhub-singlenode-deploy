define python::pip_package(
    $ensure = present,
    $venv_path,
    $package = $name,
    $source = undef,
    $version = ''
) {

    if $source == undef {
        $install_source = $package
    } else {
        $install_source = $source
    }

    # FIXME: Make this actually be useful
    exec { "pip-install-${name}":
        command => "${venv_path}/bin/pip install -U ${install_source}",
        unless  => "${venv_path}/bin/pip freeze | grep -i -e '^${package}==${version}'",
        user    => 'root',
        group   => 'root',
    }
}
