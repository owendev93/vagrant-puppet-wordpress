# Este archivo `init.pp` define la clase `apache`, que especifica el estado deseado para la instalación,
# configuración y gestión del servidor Apache en la máquina virtual.
# La clase `apache` garantiza que Apache esté instalado y en ejecución. Esta configuración también elimina
# el archivo de configuración predeterminado de Apache para evitar conflictos con wordpress.
# Apache se recargue automáticamente si hay cambios en los archivos de configuración.

class apache {
  
  exec { 'apt-update':
    command => '/usr/bin/apt-get update'  
  }
  
  Exec["apt-update"] -> Package <| |>

  package { 'apache2':
    ensure => installed,  
  }
  
  file { '/etc/apache2/sites-enabled/000-default.conf':
    ensure => absent, 
    require => Package['apache2'], 
    notify  => Service['apache2'], 
  }

  exec { 'disable-default-site':
    command => '/usr/sbin/a2dissite 000-default',
    onlyif  => '/bin/ls /etc/apache2/sites-enabled/000-default.conf', 
    require => Package['apache2'], 
    notify  => Service['apache2'], 
    path    => '/usr/bin:/bin:/usr/sbin:/sbin', 
  }
  
  service { 'apache2':
    ensure => running,  
    enable => true,  
    hasstatus  => true,  
    restart => "/usr/sbin/apachectl configtest && /usr/sbin/service apache2 reload",  
  }
}


