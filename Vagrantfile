# Configuración de Vagrant para la máquina virtual/entorno de infraestructura base virtual/IaC

Vagrant.configure("2") do |config|  

  config.vm.box = "bento/ubuntu-22.04"  

  config.vm.network "forwarded_port", guest: 80, host: 8080
  
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"  
  end

  
  # Instalación de Puppet + solución al problema GPG
  config.vm.provision "shell", inline: <<-SHELL
    echo "[INFO] Descargando paquete de Puppet..."
    wget https://apt.puppetlabs.com/puppet6-release-bionic.deb

    echo "[INFO] Instalando paquete .deb..."
    dpkg -i puppet6-release-bionic.deb || true

    echo "[INFO] Añadiendo clave pública de Puppet..."
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4528B6CD9E61EF26

    echo "[INFO] Actualizando lista de paquetes..."
    apt-get update

    echo "[INFO] Instalando puppet-agent..."
    apt-get install -y puppet-agent
  SHELL

  # Configura Puppet como herramienta de aprovisionamiento en la MV.
  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"        
    puppet.manifests_path = "manifests"   
    puppet.manifest_file = "default.pp"   
    puppet.hiera_config_path = "hiera.yaml" 
  end

end
