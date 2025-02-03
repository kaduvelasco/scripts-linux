#!/bin/bash

# Verificar se o parâmetro --apt ou -a foi passado
FORCE_APT=false
for arg in "$@"; do
    if [ "$arg" == "--apt" ] || [ "$arg" == "-a" ]; then
        FORCE_APT=true
    fi
done

# Verificar se o Nala está instalado, a menos que --apt ou -a seja usado
if [ "$FORCE_APT" == "true" ]; then
    PKG_MANAGER="apt"
    echo "⚠️ Forçando o uso do APT conforme parâmetro --apt ou -a."
elif command -v nala &> /dev/null; then
    PKG_MANAGER="nala"
    echo "🟢 Nala encontrado! Utilizando Nala para as atualizações."
else
    PKG_MANAGER="apt"
    echo "⚠️ Nala não encontrado. Utilizando APT para as atualizações."
fi

# Exibir uma mensagem de início
echo "🚀 Iniciando atualização do SO e Flatpak..."
echo ""

# Atualizar lista de pacotes
echo "🔄 Atualizando lista de pacotes..."
sudo $PKG_MANAGER update -y

# Atualizar pacotes instalados
echo "📦 Atualizando pacotes..."
sudo $PKG_MANAGER upgrade -y

# Atualizar pacotes que possuem novas versões no sistema
echo "🆙 Atualizando pacotes do sistema..."
sudo $PKG_MANAGER full-upgrade -y

# Remover pacotes órfãos
echo "🗑️ Removendo pacotes órfãos..."
sudo $PKG_MANAGER autoremove -y

# Remover pacotes antigos desnecessários
echo "🧹 Limpando pacotes antigos..."
sudo $PKG_MANAGER autoclean -y

# Atualizar pacotes Flatpak
if command -v flatpak &> /dev/null; then
    echo "🟢 Atualizando pacotes Flatpak..."
    flatpak update -y
else
    echo "⚠️ Flatpak não está instalado. Ignorando esta etapa."
fi

# Exibir mensagem de conclusão
echo "✅ Atualização concluída com sucesso!"
