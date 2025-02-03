#!/bin/bash

# Exibir uma mensagem de início
echo "🚀 Iniciando atualização do sistema Ubuntu 24.04 e Flatpak..."

# Atualizar lista de pacotes
echo "🔄 Atualizando lista de pacotes..."
sudo apt update -y

# Atualizar pacotes instalados
echo "📦 Atualizando pacotes..."
sudo apt upgrade -y

# Atualizar pacotes que possuem novas versões no sistema
echo "🆙 Atualizando pacotes do sistema..."
sudo apt full-upgrade -y

# Remover pacotes órfãos
echo "🗑️ Removendo pacotes órfãos..."
sudo apt autoremove -y

# Remover pacotes antigos desnecessários
echo "🧹 Limpando pacotes antigos..."
sudo apt autoclean -y

# Atualizar pacotes Flatpak
if command -v flatpak &> /dev/null; then
    echo "🟢 Atualizando pacotes Flatpak..."
    flatpak update -y
else
    echo "⚠️ Flatpak não está instalado. Ignorando esta etapa."
fi

# Exibir mensagem de conclusão
echo "✅ Atualização concluída com sucesso!"

