#!/bin/bash

# Para o Servidor Local
stop_services() {
    sudo update-alternatives --set php /usr/bin/php8.0
    sudo a2dissite php70
    sudo a2dissite php74
    sudo a2dissite php80
    sudo a2dissite php81
    sudo a2dissite php82
    sudo a2dissite php83
    sudo service mariadb stop
    sudo service apache2 stop
    sudo service php7.0-fpm stop
    sudo service php7.4-fpm stop
    sudo service php8.0-fpm stop
    sudo service php8.1-fpm stop
    sudo service php8.2-fpm stop
    sudo service php8.3-fpm stop
    echo "Servidor Local: Parado"
}

# Inicia Servidor com PHP 7.0
start_services_70() {
    sudo update-alternatives --set php /usr/bin/php7.0
    sudo a2dissite php74
    sudo a2dissite php80
    sudo a2dissite php81
    sudo a2dissite php82
    sudo a2dissite php83
    sudo a2ensite php70
    sudo service mariadb start
    sudo service apache2 start
    sudo service apache2 reload
    sudo service php7.0-fpm start
    echo "Servidor Local com PHP 7.0: Iniciado"
}

# Reinicia Servidor com PHP 7.0
restart_services_70() {
    sudo update-alternatives --set php /usr/bin/php7.0
    sudo a2dissite php74
    sudo a2dissite php80
    sudo a2dissite php81
    sudo a2dissite php82
    sudo a2dissite php83
    sudo a2ensite php70
    sudo service mariadb restart
    sudo service apache2 restart
    sudo service apache2 reload
    sudo service php7.0-fpm restart
    echo "Servidor Local com PHP 7.0: Reiniciado"
}

# Inicia Servidor com PHP 7.4
start_services_74() {
    sudo update-alternatives --set php /usr/bin/php7.4
    sudo a2dissite php70
    sudo a2dissite php80
    sudo a2dissite php81
    sudo a2dissite php82
    sudo a2dissite php83
    sudo a2ensite php74
    sudo service mariadb start
    sudo service apache2 start
    sudo service apache2 reload
    sudo service php7.4-fpm start
    echo "Servidor Local com PHP 7.4: Iniciado"
}

# Reinicia Servidor com PHP 7.4
restart_services_74() {
    sudo update-alternatives --set php /usr/bin/php7.4
    sudo a2dissite php70
    sudo a2dissite php80
    sudo a2dissite php81
    sudo a2dissite php82
    sudo a2dissite php83
    sudo a2ensite php74
    sudo service mariadb restart
    sudo service apache2 restart
    sudo service apache2 reload
    sudo service php7.4-fpm restart
    echo "Servidor Local com PHP 7.4: Reiniciado"
}

# Inicia Servidor com PHP 8.0
start_services_80() {
    sudo update-alternatives --set php /usr/bin/php8.0
    sudo a2dissite php70
    sudo a2dissite php74
    sudo a2dissite php81
    sudo a2dissite php82
    sudo a2dissite php83
    sudo a2ensite php80
    sudo service mariadb start
    sudo service apache2 start
    sudo service apache2 reload
    sudo service php8.0-fpm start
    echo "Servidor Local com PHP 8.0: Iniciado"
}

# Reinicia Servidor com PHP 8.0
restart_services_80() {
    sudo update-alternatives --set php /usr/bin/php8.0
    sudo a2dissite php70
    sudo a2dissite php74
    sudo a2dissite php81
    sudo a2dissite php82
    sudo a2dissite php83
    sudo a2ensite php80
    sudo service mariadb restart
    sudo service apache2 restart
    sudo service apache2 reload
    sudo service php8.0-fpm restart
   echo "Servidor Local com PHP 8.0: Reiniciado"
}

# Inicia Servidor com PHP 8.1
start_services_81() {
    sudo update-alternatives --set php /usr/bin/php8.1
    sudo a2dissite php70
    sudo a2dissite php74
    sudo a2dissite php80
    sudo a2dissite php82
    sudo a2dissite php83
    sudo a2ensite php81
    sudo service mariadb start
    sudo service apache2 start
    sudo service apache2 reload
    sudo service php8.1-fpm start
    echo "Servidor Local com PHP 8.1: Iniciado"
}

# Reinicia Servidor com PHP 8.1
restart_services_81() {
    sudo update-alternatives --set php /usr/bin/php8.1
    sudo a2dissite php70
    sudo a2dissite php74
    sudo a2dissite php80
    sudo a2dissite php82
    sudo a2dissite php83
    sudo a2ensite php81
    sudo service mariadb restart
    sudo service apache2 restart
    sudo service php8.1-fpm restart
    echo "Servidor Local com PHP 8.1: Reiniciado"
}

# Inicia Servidor com PHP 8.2
start_services_82() {
    sudo update-alternatives --set php /usr/bin/php8.2
    sudo a2dissite php70
    sudo a2dissite php74
    sudo a2dissite php80
    sudo a2dissite php81
    sudo a2dissite php83
    sudo a2ensite php82
    sudo service mariadb start
    sudo service apache2 start
    sudo service apache2 reload
    sudo service php8.2-fpm start
    echo "Servidor Local com PHP 8.2: Iniciado"
}

# Reinicia Servidor com PHP 8.2
restart_services_82() {
    sudo update-alternatives --set php /usr/bin/php8.2
    sudo a2dissite php70
    sudo a2dissite php74
    sudo a2dissite php80
    sudo a2dissite php81
    sudo a2dissite php83
    sudo a2ensite php82
    sudo service mariadb restart
    sudo service apache2 restart
    sudo service apache2 reload
    sudo service php8.2-fpm restart
   echo "Servidor Local com PHP 8.2: Reiniciado"
}

# Inicia Servidor com PHP 8.3
start_services_83() {
    sudo update-alternatives --set php /usr/bin/php8.3
    sudo a2dissite php70
    sudo a2dissite php74
    sudo a2dissite php80
    sudo a2dissite php81
    sudo a2dissite php82
    sudo a2ensite php83
    sudo service mariadb start
    sudo service apache2 start
    sudo service apache2 reload
    sudo service php8.3-fpm start
    echo "Servidor Local com PHP 8.3: Iniciado"
}

# Reinicia Servidor com PHP 8.3
restart_services_83() {
    sudo update-alternatives --set php /usr/bin/php8.3
    sudo a2dissite php70
    sudo a2dissite php74
    sudo a2dissite php80
    sudo a2dissite php81
    sudo a2dissite php82
    sudo a2ensite php83
    sudo service mariadb restart
    sudo service apache2 restart
    sudo service apache2 reload
    sudo service php8.3-fpm restart
   echo "Servidor Local com PHP 8.3: Reiniciado"
}

# Menu de opÃ§Ãµes
echo "Selecione a ação desejada:"
echo "1. Parar / Finalizar Servidor Local"
echo "2. PHP 7.0: Iniciar Servidor Local"
echo "3. PHP 7.0: Reiniciar Servidor Local"
echo "4. PHP 7.4: Iniciar Servidor Local"
echo "5. PHP 7.4: Reiniciar Servidor Local"
echo "6. PHP 8.0: Iniciar Servidor Local"
echo "7. PHP 8.0: Reiniciar Servidor Local"
echo "8. PHP 8.1: Iniciar Servidor Local"
echo "9. PHP 8.1: Reiniciar Servidor Local"
echo "10. PHP 8.2: Iniciar Servidor Local"
echo "11. PHP 8.2: Reiniciar Servidor Local"
echo "12. PHP 8.3: Iniciar Servidor Local"
echo "13. PHP 8.3: Reiniciar Servidor Local"


read -p "Selecione: " choice

case $choice in
  1)
    stop_services
    ;;
  2)
    start_services_70
    ;;
  3)
    restart_services_70
    ;;
  4)
    start_services_74
    ;;
  5)
    restart_services_74
    ;;
  6)
    start_services_80
    ;;
  7)
    restart_services_80
    ;;
  8)
    start_services_81
    ;;
  9)
    restart_services_81
    ;;
  10)
    start_services_82
    ;;
  11)
    restart_services_82
    ;;
  12)
    start_services_83
    ;;

  13)
    restart_services_83
    ;;
  *)
    echo "Escolha inválidada. Selecione:"
    ;;
esac