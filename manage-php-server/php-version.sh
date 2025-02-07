#!/bin/bash

# Função para obter as versões de PHP instaladas
get_installed_php_versions() {
    php_versions=()
    for version in $(ls /usr/bin/ | grep -E '^php[0-9]+\.[0-9]+$'); do
        php_versions+=("${version#php}")
    done
    echo "${php_versions[@]}"
}

# Para o Servidor Local
stop_services() {
    # Define o PHP 8.0 como padrão
    echo "🛑 Definindo a versão 8.0 como padrão no sistema..."
    sudo update-alternatives --set php /usr/bin/php8.0

    # Desabilitar todos os sites PHP
    echo "🔒 Desabilitando as configurações de site..."
    sudo a2dissite $(get_installed_php_versions | tr ' ' '\n' | sed 's/\./_/g' | sed 's/_//g' | sed 's/^/php/' )
    
    # Parar o serviço do MariaDB e Apache
    echo "🚫 Parando o serviço MariaDB..."
    sudo service mariadb stop

    echo "🛑 Parando o serviço Apache 2..."
    sudo service apache2 stop

    # Parar os serviços PHP instalados dinamicamente (sem remover o ponto)
    for version in $(get_installed_php_versions); do
        echo "🛑 Parando o serviço php${version}-fpm..."
        sudo service "php${version}-fpm" stop
    done

    echo "✅ Servidor Local: Parado"
}

# Funções para iniciar ou reiniciar servidores com PHP especificado
start_services() {
    version=$1
    version_no_dot=$(echo "$version" | sed 's/\./_/g' | sed 's/_//g')
    sudo update-alternatives --set php /usr/bin/php$version
    sudo a2dissite $(get_installed_php_versions | tr ' ' '\n' | sed 's/\./_/g' | sed 's/_//g' | sed 's/^/php/' | grep -v "^php$version_no_dot")
    sudo a2ensite php$version_no_dot
    sudo service mariadb start
    sudo service apache2 start
    sudo service apache2 reload
    sudo service php${version}-fpm start
    echo "🚀 Servidor Local com PHP $version: Iniciado"
}

restart_services() {
    version=$1
    version_no_dot=$(echo "$version" | sed 's/\./_/g' | sed 's/_//g')
    sudo update-alternatives --set php /usr/bin/php$version
    sudo a2dissite $(get_installed_php_versions | tr ' ' '\n' | sed 's/\./_/g' | sed 's/_//g' | sed 's/^/php/' | grep -v "^php$version_no_dot")
    sudo a2ensite php$version_no_dot
    sudo service mariadb restart
    sudo service apache2 restart
    sudo service apache2 reload
    sudo service php${version}-fpm restart
    echo "🔄 Servidor Local com PHP $version: Reiniciado"
}

# Menu de opções
echo "💻 O que você deseja fazer?"
echo "1. Iniciar Servidor Local"
echo "2. Reiniciar Servidor Local"
echo "3. Parar Servidor Local"
read -p "Selecione uma opção: " action

if [ "$action" == "3" ]; then
    stop_services
else
    # Obter versões de PHP instaladas
    installed_php_versions=($(get_installed_php_versions))

    # Construir menu com base nas versões instaladas
    echo "🔍 Selecione a versão do PHP desejada:"
    for i in "${!installed_php_versions[@]}"; do
        echo "$((i+1)). PHP ${installed_php_versions[$i]}"
    done

    read -p "Selecione a versão do PHP: " php_choice

    if [ "$php_choice" -ge 1 ] && [ "$php_choice" -le "${#installed_php_versions[@]}" ]; then
        php_version="${installed_php_versions[$((php_choice-1))]}"
        
        if [ "$action" == "1" ]; then
            echo "🚀 Iniciando o Servidor PHP Local..."

            start_services $php_version
        elif [ "$action" == "2" ]; then
            echo "🔄 Reiniciando o Servidor PHP Local..."
            restart_services $php_version
        fi
    else
        echo "❌ Opção inválida."
    fi
fi
