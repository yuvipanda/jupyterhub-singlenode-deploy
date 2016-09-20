# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.provision "shell", inline: "apt-get install --yes puppet"

  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"
  end

  config.vm.network "forwarded_port", guest: 8000, host: 8000

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "1024"
  end
end
