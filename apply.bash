#!/bin/bash
# Script that installs puppet if needed & provisions
# current machine. Expects to run as root.

# If we aren't root, barf
if [ $(/usr/bin/whoami) != 'root' ]; then
    echo "This script must be run as root"
    exit 1
fi

# If puppet isn't found, attempt to install it
if ! /usr/bin/which puppet > /dev/null; then
    apt-get install --yes puppet
fi

DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FACTER_puppetdir="${DIRNAME}" puppet apply --no-stringify_facts --parser=future --hiera_config="${DIRNAME}/hiera.yaml" --modulepath="${DIRNAME}/modules" "${DIRNAME}/manifests/default.pp"
