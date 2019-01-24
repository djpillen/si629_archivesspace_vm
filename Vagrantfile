# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/xenial64"

  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 8081, host: 8081
  config.vm.network "forwarded_port", guest: 8082, host: 8082
  config.vm.network "forwarded_port", guest: 8089, host: 8089
  config.vm.network "forwarded_port", guest: 8090, host: 8090

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
  end

  config.vm.provision "shell", path:"bootstrap.sh"
  config.vm.provision "shell", path:"setup_mysql.sh"
  config.vm.provision "shell", path:"setup_archivesspace.sh"

end
