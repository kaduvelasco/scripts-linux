#!/bin/bash

echo "🚀 Pós Instalação - ZorinOS 17"
echo ""

# Atualiza os repositórios e pacotes
echo "🔄 Atualizando repositórios e pacotes..."
sudo apt update && sudo apt upgrade -y

# Adiciona repositórios Universe, Multiverse e Restricted
echo "➕ Adicionando repositórios Universe, Multiverse e Restricted..."
sudo add-apt-repository -y universe
sudo add-apt-repository -y multiverse
sudo add-apt-repository -y restricted
echo "✅ Repositórios adicionados!"

# Atualiza os repositórios e pacotes
echo "🔄 Atualizando repositórios e pacotes..."
sudo apt update && sudo apt upgrade -y

# Instala pacotes úteis
echo "📥 Instalando pacotes úteis..."
sudo apt install -y ubuntu-restricted-extras curl git gparted build-essential ubuntu-drivers-common gdebi libfuse2 curl wget unrar git unzip ntfs-3g p7zip htop make bzip2 tar
echo "✅ Pacotes úteis instalados!"

# Instala codecs multimídia
echo "🎵 Instalando codecs multimídia..."
sudo apt install -y libavcodec-extra ffmpeg
echo "✅ Codecs instalados!"

# Instala drivers recomendados
echo "🔧 Instalando drivers recomendados..."
sudo ubuntu-drivers autoinstall
echo "✅ Drivers instalados!"

# Instala o gerenciador de pacotes Nala e atualiza sua lista de repositórios
echo "🚀 Instalando o gerenciador de pacotes Nala..."
sudo apt install -y nala
echo "✅ Nala instalado! Lembre-se de executar nala fetch"

# Atualiza os repositórios e pacotes
echo "🔄 Atualizando repositórios e pacotes..."
sudo apt update && sudo apt upgrade -y

# Finaliza com a última atualização
echo "🧹 Removendo pacotes desnecessários..."
sudo apt autoremove -y && sudo apt autoclean
echo "✅ Limpeza concluída!"

# Mensagem final
echo "🎉 Configuração pós-instalação do Zorin OS concluída! Reinicie o sistema se necessário."

