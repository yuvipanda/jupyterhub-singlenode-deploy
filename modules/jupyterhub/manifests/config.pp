# = define: jupyterhub::config
#
# Defines a small snippet of jupyterhub configuration
# for the jupyterhub named $hubname
#
# == Parameters
#
# [*hubname*]
#  The name of the jupyterhub::hub for which this config
#  chunk is intended. Required.
#
define jupyterhub::config(
    $hubname,
    $ensure = file,
    $priority = 50,
    $content = undef,
    $source = undef,
) {
    include jupyterhub::base

    $base_dir = $::jupyterhub::base::dir
    $config_dir = "${base_dir}/${hubname}/config.d"
    $service_name = "jupyterhub-${hubname}"

    file { "${config_dir}/${priority}-${name}.py":
        ensure  => $ensure,
        content => $content,
        source  => $source,
        owner   => 'root',
        group   => 'root',
        mode    => '0500',
        # This makes it implicitly require & depend on the
        # jupyterhub::hub[$hubname] resource.
        notify  => Service[$service_name],
    }
}
