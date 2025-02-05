#!/bin/bash

echo "🚀 Descompactar arquivo .rar com senha"

# Solicita o caminho do arquivo com autocompletar
read -e -p "📂 Digite o caminho do arquivo .rar: " arquivo

# Verifica se o arquivo foi fornecido
if [ -z "$arquivo" ]; then
    echo "📌 Uso: $0 arquivo.rar"
    exit 1
fi

# Verifica se o arquivo existe
if [ ! -f "$arquivo" ]; then
    echo "❌ Erro: Arquivo '$arquivo' não encontrado."
    exit 1
fi

# Solicita a senha ao usuário de forma segura
read -s -p "🔑 Digite a senha para descompactar o arquivo: " senha

echo -e "\n"

# Verifica se o unrar está instalado
if ! command -v unrar &> /dev/null; then
    echo "⚠️ O unrar não está instalado. Instalando agora..."
    sudo apt update && sudo apt install -y unrar
fi

# Extrai o arquivo com a senha informada
echo "📂 Descompactando '$arquivo'..."
unrar x -p"$senha" "$arquivo"

echo "✅ Processo concluído."
