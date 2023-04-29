# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

ENV["VAGRANT_DEFAULT_PROVIDER"] = "libvirt"

Vagrant.configure("2") do |config|
config.vm.define "collection", primary: true do |srv|
    srv.vm.box = "roboxes/ubuntu2004"
    # srv.vm.network :private_network, ip: "192.168.60.42"
    srv.ssh.insert_key = false
    srv.vm.provider :libvirt do |libvirt|
        libvirt.cpus = "4"
        libvirt.memory = "6144"
        libvirt.driver = "qemu"
        libvirt.qemu_use_session = false
    end
    srv.vm.synced_folder "./", "/home/vagrant/ansible_collections/thorian93/main/", type: "rsync"
    $script = <<-SCRIPT
    apt-get update
    apt-get install -y python3.9 python3-pip ca-certificates curl gnupg lsb-release
    python3.9 -m pip install -r /home/vagrant/ansible_collections/thorian93/main/requirements.txt
    sudo -u vagrant ansible-galaxy collection install -f -r /home/vagrant/ansible_collections/thorian93/main/.yml
    mkdir -p /home/vagrant/ansible_collections/thorian93/main
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    usermod -aG docker vagrant
    SCRIPT
    srv.vm.provision "shell", inline: $script
    # srv.vm.synced_folder "./", "/home/vagrant/ansible_collections/thorian93/main/", type: "9p", disabled: false, accessmode: "mapped", owner: "1000"
    end
end