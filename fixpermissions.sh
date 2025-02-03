#!/bin/bash

# Função para aplicar permissões em uma pasta
apply_changes() {
    local folder=$1

    # Verificar se a pasta existe antes de aplicar as permissões
    if [ -d "$folder" ]; then
        # Executar os comandos para alterar a propriedade e permissões
        chmod -R 777 "$folder"
        echo -e "\e[32m✅ Permissões aplicadas em $folder\e[0m"
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
echo -e "\e[34m📂 Selecione a pasta para aplicar as permissões:\e[0m"
echo ""

# Iterar sobre os diretórios e listar como opções numeradas
for ((i=0; i<${#directories[@]}; i++)); do
    echo -e "\e[36m$((i+1)). ${directories[i]}\e[0m"
done

# Ler a escolha do usuário
read -p "Digite o número correspondente à pasta desejada: " choice

# Validar a escolha do usuário e aplicar as alterações
if [ "$choice" -ge 1 ] && [ "$choice" -le "${#directories[@]}" ]; then
    selected_directory="${directories[choice-1]}"
    apply_changes "$selected_directory"
else
    echo -e "\e[31m⚠️ Escolha inválida. Por favor, digite um número válido.\e[0m"
fi
