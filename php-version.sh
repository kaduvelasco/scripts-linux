#!/bin/bash

# Função para buscar as versões do PHP instaladas
get_installed_php_versions() {
    php_versions=()
    for version in $(ls /usr/bin/ | grep -E '^php[0-9]+\.[0-9]+$'); do
        php_versions+=("$version")
    done
    echo "${php_versions[@]}"
}

# Menu de opções dinâmico
echo "📜 Selecione a ação desejada:"
installed_versions=($(get_installed_php_versions))
if [ ${#installed_versions[@]} -eq 0 ]; then
    echo "❌ Nenhuma versão do PHP instalada."
    exit 1
fi

# Exibindo as versões instaladas dinamicamente
for i in "${!installed_versions[@]}"; do
    echo "$((i+1)). 🚀 PHP ${installed_versions[$i]}: Iniciar Servidor Local"
    echo "$((i+2)). 🔄 PHP ${installed_versions[$i]}: Reiniciar Servidor Local"
done
echo "$((2 * ${#installed_versions[@]} + 1)). ⛔ Parar / Finalizar Servidor Local"

# Leitura da escolha
read -p "Selecione: " choice

# Lógica para parar/ligar/reiniciar os serviços com base na escolha
if (( choice % 2 == 1 )); then
    selected_version="${installed_versions[$((choice / 2))]}"
    sudo update-alternatives --set php /usr/bin/"$selected_version"
    sudo a2dissite $(ls /etc/apache2/sites-enabled/ | grep -E '^php[0-9]+\.[0-9]+$' | grep -v "$selected_version" | tr '\n' ' ')
    sudo a2ensite "php$selected_version"
    sudo service mariadb restart
    sudo service apache2 restart
    sudo service apache2 reload
    sudo service php$selected_version-fpm restart
    echo "✅ Servidor Local com PHP $selected_version: Reiniciado"
else
    stop_services
fi

