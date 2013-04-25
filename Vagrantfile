# -*- mode: ruby -*-
# vi: set ft=ruby :

def local_cache(box_name)
  cache_dir = File.join(File.expand_path(Vagrant::Environment::DEFAULT_HOME),
                        'cache',
                        'apt',
                        box_name)
  partial_dir = File.join(cache_dir, 'partial')
  FileUtils.mkdir_p(partial_dir) unless File.exists? partial_dir
  cache_dir
end

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu-12.04-nfs-i386a"
  config.vm.box_url = "http://github.com/downloads/juanje/bento/ubuntu-12.04-nfs-i386.box"

  config.vm.hostname = 'sb01.stations.graphenedb.com'

  # You need to fix a hostonly IP and this network seems to be safe
  config.vm.network :private_network, ip: "33.33.33.11"
  #config.vm.network :forwarded_port, guest: 44000, host: 44000
  #config.vm.network :forwarded_port, guest: 4567, host: 44001

  # Enable SSH agent forwarding in order to use host's SSH keys
  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
  end

  # Reuse the apt cache
  cache_dir = local_cache(config.vm.box)
  config.vm.synced_folder cache_dir, "/var/cache/apt/archives/", :nfs => true

  # Here we share the host's directory '../' as a directory '/mnt/code' inside the VM
  config.vm.synced_folder "../", "/graphenedb-nfs", :nfs => true

  script = <<-SCRIPT
  if [ ! -d /mnt/code/ ]; then
    sudo mkdir /mnt/code/
    sudo bindfs -u vagrant -g vagrant -p u=rwX:g=rD:o=rD /graphenedb-nfs/ /mnt/code/
  fi
  SCRIPT
  config.vm.provision :shell, :inline => script

  # Enable the Berkshelf plugin
  config.berkshelf.enabled = true

  # Run Chef inside the VM
  config.vm.provision :chef_solo do |chef|

    chef.add_recipe "station"
  end
end
