# = Class: conda::installer
#
# Downloads a particular version of the anaconda installer & makes
# sure it downloads correctly
#
# == Parameters
# [*version*]
#  Version of coda installer to download
#
# [*sha256*]
#  Hash of the conda installer for this version, used for verification
#
# [*dest_dir*]
#  Directory to download the installer into
class conda::installer(
    $version = '4.1.1',
    $sha256 = '4f5c95feb0e7efeadd3d348dcef117d7787c799f24b0429e45017008f3534e55',
    $dest_dir = "/srv/conda-installers"
) {

    $url = "https://repo.continuum.io/archive/Anaconda3-${version}-Linux-x86_64.sh"

    $path = "${dest_dir}/${version}.sh"

    ensure_packages('wget')

    file { $dest_dir:
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0555'
    }

    exec { 'download-conda':
        command   => "/usr/bin/wget -c -O '${path}' ${url} && chmod +x '${path}'",
        unless    => "/bin/echo '${sha256}  ${path}' | sha256sum -c",
        timeout   => 360,  # 5 minute timeout, it could take a while
        require   => File[$dest_dir],
        logoutput => 'on_failure',
    }
}
