# Este archivo `default.pp` es el manifiesto principal para configurar la máquina virtual (MV) con Puppet.
# Sirve como punto de entrada y contiene las configuraciones esenciales que Vagrant utiliza para aprovisionar la MV.
# Este manifiesto permite centralizar la configuración de Apache en un solo lugar, facilitando la personalización
# y el control sin necesidad de modificar directamente el módulo de Apache.

# Declara una variable para el directorio raíz de Apache
# (/vagrant es el directorio compartido donde se encuentra el Vagrantfile en la MV, (se crea por defecto por vagrant al lanzar la mv))

$document_root = '/vagrant'

package { ['php', 'php-mysql']:
  ensure  => installed,
  require => Package['apache2'], 
}

include apache
include mysql
include wordpress

$ipv4_address = $facts['networking']['ip']

notify { 'Showing machine Facts':
  message => "Machine with ${::memory['system']['total']} of memory and ${::processorcount} processor/s.
              Please check access to http://${ipv4_address}",  
}
