#Define el manifiesto principal del modulo de wordpress. Con este manifiesto se configura e instala wordpress en la mv.
#1. Instala, configura y arranca wordpress y administra una pagina web por defecto
#2. Configura e inicializa la bd de mysql para que wordpress pueda usarla
#3. Configura el servicio de apache para que redirija el tráfico al servicio de wordpress y sirva su contenido.

class wordpress {
  
  $db_name     = lookup('mysql::db_name')
  $db_user     = lookup('mysql::db_user')
  $db_password = lookup('mysql::db_password')

  $url           = lookup('wordpress::url')
  $wp_title         = lookup('wordpress::wp_title')
  $admin_user    = lookup('wordpress::admin_user')
  $admin_password = lookup('wordpress::admin_password')
  $admin_email   = lookup('wordpress::admin_email')
  $path          = lookup('wordpress::path')
  $allow_root    = lookup('wordpress::allow_root')

# INSTALACION Y CONFIGURACION DE WORDPRESS
  exec { 'download-wordpress': 
    command => "/usr/bin/wget -q -O /opt/wordpress.tar.gz 'https://wordpress.org/latest.tar.gz'", 
    creates => '/opt/wordpress.tar.gz',  
    path    => '/usr/bin:/bin:/usr/sbin:/sbin', 
    require => Package['apache2'], 
  }

  exec { 'extract-wordpress':
    command => '/bin/tar -xzvf /opt/wordpress.tar.gz -C /var/www/html',
    creates => '/var/www/html/wordpress', 
    require => Exec['download-wordpress'], 
    path    => '/bin:/usr/bin:/sbin:/usr/sbin', 
  }

  exec { 'generate-auth-keys':
    command => 'curl -s https://api.wordpress.org/secret-key/1.1/salt/ > /tmp/wp-keys.php',
    creates => '/tmp/wp-keys.php', 
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
  }
  
  file { '/var/www/html/wordpress/wp-config.php':
    ensure  => file,
    content => template('wordpress/wp-config.php.erb'),
    require => [Exec['generate-auth-keys'], Exec['extract-wordpress']],
  }

  exec { 'set-wordpress-permissions':
    command => '/bin/chown -R www-data:www-data /var/www/html/wordpress',
    require => Exec['extract-wordpress'], 
    path    => '/bin:/usr/bin:/sbin:/usr/sbin', 
  }

  # Instalación de WP-CLI, herramienta de CLI para WordPress para configurar y administrar wordpress desde CLI 
  exec { 'install-wp-cli':
    command => 'curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp',
    creates => '/usr/local/bin/wp', 
    path    => '/usr/bin:/bin:/usr/sbin:/sbin', 
    require => Exec['initialize-wordpress-db'], 
  }

  exec { 'wordpress-install':
    command => "wp core install --url=\"${url}\" --title=\"${wp_title}\" --admin_user=\"${admin_user}\" --admin_password=\"${admin_password}\" --admin_email=\"${admin_email}\" --path=${path} --allow-root=${allow_root}",
    path    => '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin', 
    require => [File['/var/www/html/wordpress/wp-config.php'], Exec['install-wp-cli']],
  }

  # CONFIGURAR CONTENIDO INICIAL DE WORDPRESS EN LA BD MYSQL
  
  file { '/etc/mysql/init-wordpress-content.sql':
    ensure  => present, 
    content => template('wordpress/init-wordpress-content.sql.erb'), 
    require => Exec['wordpress-install'], 
  }

  exec { 'initialize-wordpress-content':
    command => '/usr/bin/mysql < /etc/mysql/init-wordpress-content.sql', 
    unless  => "/usr/bin/mysql -e 'SELECT * FROM ${db_name}.wp_posts WHERE post_title=\"Bienvenido\";'", 
    require => File['/etc/mysql/init-wordpress-content.sql'], 
  }

# CONFIGURAR APACHE PARA SERVIR WORDPRESS
  
  file { '/etc/apache2/sites-available/wordpress.conf':
    ensure  => file,
    content => template('wordpress/wp-apache-config.conf.erb'), 
    require => Exec['set-wordpress-permissions'], 
  }
  
  exec { 'enable-wordpress-site':
    command => '/usr/sbin/a2ensite wordpress && /usr/bin/systemctl reload apache2',
    require => File['/etc/apache2/sites-available/wordpress.conf'], 
    path    => '/bin:/usr/bin:/sbin:/usr/sbin', 
  }
}
