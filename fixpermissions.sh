#!/bin/bash

# Verifica se o script está sendo executado como root
if [[ $EUID -ne 0 ]]; then
    echo -e "\e[31m🚨 Este script precisa ser executado como root.\e[0m"
    exit 1
fi

# Função para aplicar propriedade e permissões em uma pasta
apply_changes() {
    local folder=$1

    # Verificar se a pasta existe antes de aplicar as mudanças
    if [ -d "$folder" ]; then
        echo -e "\e[33m🔄 Ajustando propriedade da pasta $folder para $USER...\e[0m"
        sudo chown -R $USER:$USER "$folder"
        echo -e "\e[32m✅ Propriedade ajustada com sucesso!\e[0m"

        echo -e "\e[33m🔄 Aplicando permissões 775 na pasta $folder...\e[0m"
        sudo chmod -R 775 "$folder"
        echo -e "\e[32m✅ Permissões aplicadas com sucesso!\e[0m"
    else
        echo -e "\e[31m❌ A pasta $folder não existe.\e[0m"
    fi
}

# Lista de diretórios principais
directories=(
    "/var/www/data"
    "/var/www/html"
)

# Menu de opções para o usuário selecionar a pasta
echo -e "\e[34m📂 Selecione a pasta para ajustar propriedade e permissões:\e[0m"
echo ""

# Iterar sobre os diretórios e listar como opções numeradas
for ((i=0; i<${#directories[@]}; i++)); do
    echo -e "\e[36m$((i+1)). ${directories[i]}\e[0m"
done

# Ler a escolha do usuário
read -p "Digite o número correspondente à pasta desejada: " choice

# Validar a escolha do usuário (garantindo que seja um número válido)
if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#directories[@]}" ]; then
    selected_directory="${directories[choice-1]}"
    apply_changes "$selected_directory"
else
    echo -e "\e[31m⚠️ Escolha inválida. Por favor, digite um número válido.\e[0m"
fi
