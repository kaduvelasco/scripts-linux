#!/bin/bash

# Função para buscar as versões do PHP instaladas
get_installed_php_versions() {
    php_versions=()
    for version in $(ls /usr/bin/ | grep -E '^php[0-9]+\.[0-9]+$'); do
        php_versions+=("$version")
    done
    echo "${php_versions[@]}"
}

# Função para obter a versão ativa do PHP
get_active_php_version() {
    php -v | head -n 1 | grep -oP 'PHP \K[0-9]+\.[0-9]+'
}

# Função para parar os serviços
stop_services() {
    echo "⛔ Parando os serviços Apache 2, MariaDB e PHP..."
    sudo service apache2 stop
    sudo service mariadb stop
    for version in $(get_installed_php_versions); do
        php_service_name="${version}-fpm"
        sudo service "$php_service_name" stop 2>/dev/null
    done
    echo "✅ Todos os serviços foram parados."
}

# Menu de opções dinâmico
echo "📜 Selecione a ação desejada:"
installed_versions=($(get_installed_php_versions))
if [ ${#installed_versions[@]} -eq 0 ]; then
    echo "❌ Nenhuma versão do PHP instalada."
    exit 1
fi

# Exibindo as versões instaladas dinamicamente
option_number=1
for i in "${!installed_versions[@]}"; do
    echo "$option_number. 🚀 PHP ${installed_versions[$i]}: Iniciar Servidor Local"
    ((option_number++))
done

# Opção para reiniciar o PHP ativo
active_php_version=$(get_active_php_version)
if [ -n "$active_php_version" ]; then
    echo "$option_number. 🔄 Reiniciar Servidor Local (PHP $active_php_version)"
    ((option_number++))
fi

echo "$option_number. ⛔ Parar / Finalizar Servidor Local"

# Leitura da escolha
read -p "Selecione: " choice

# Verifica se a escolha está dentro do intervalo de opções
if (( choice > 0 && choice < option_number )); then
    index=$(( (choice - 1) ))
    selected_version="${installed_versions[$index]}"  # Exemplo: php8.1
    php_service_name="${selected_version}-fpm"  # Nome correto do serviço

    stop_services  # Parar todos os serviços antes de iniciar o novo

    echo "🛠️ Definindo a versão $selected_version como padrão..."
    sudo update-alternatives --set php /usr/bin/"$selected_version"
    
    # Desabilita sites errados e habilita o correto
    echo "🔧 Configurando a versão $selected_version no Apache..."
    site_name="${selected_version}"
    if ! sudo a2ensite "$site_name" 2>/dev/null; then
        echo "⚠️ Site $site_name já está habilitado."
    fi
    existing_sites=$(ls /etc/apache2/sites-enabled/ | grep -E '^php[0-9]+$' | grep -v "$site_name")
    if [ -n "$existing_sites" ]; then
        sudo a2dissite $existing_sites
    fi

    # Inicia o PHP-FPM apenas se existir
    if sudo systemctl list-units --type=service | grep -q "$php_service_name"; then
        sudo service "$php_service_name" start
    else
        echo "⚠️ O serviço $php_service_name não foi encontrado."
    fi
    
    sudo service mariadb start
    sudo service apache2 start
    sudo service apache2 reload
    
    echo "✅ Servidor Local com $selected_version: Iniciado"
elif (( choice == option_number - 2 )); then
    # Reiniciar o PHP ativo
    if [ -n "$active_php_version" ]; then
        stop_services
        php_service_name="php${active_php_version}-fpm"
        sudo service "$php_service_name" start
        sudo service mariadb start
        sudo service apache2 start
        sudo service apache2 reload
        echo "✅ Servidor Local com $active_php_version: Reiniciado"
    else
        echo "⚠️ Nenhum PHP ativo encontrado para reiniciar."
    fi
else
    stop_services
fi
