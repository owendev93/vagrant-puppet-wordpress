# Definimos el manifiesto principal del modulo de mysql. Con este manifiesto se configura e instala mysql en la mv.
# Se asegura de que el servicio de MySQL esté en ejecución y se configura la base de datos para iniciarizarla despues con wordpress

class mysql {

  $db_name     = lookup('mysql::db_name')
  $db_user     = lookup('mysql::db_user')
  $db_password = lookup('mysql::db_password')

  package { 'mysql-server':
    ensure => installed, 
  }

  service { 'mysql':
    ensure => running, 
    enable => true, 
  }

  file { '/etc/mysql/init-wordpress.sql':
    ensure  => present, 
    content => template('mysql/init-wordpress.sql.erb'), 
    require => Package['mysql-server'], 
  }

  exec { 'initialize-wordpress-db': 
    command => '/usr/bin/mysql < /etc/mysql/init-wordpress.sql', 
    unless  => "/usr/bin/mysql -e 'USE ${db_name};'", 
    require => File['/etc/mysql/init-wordpress.sql'], 
  }
}

