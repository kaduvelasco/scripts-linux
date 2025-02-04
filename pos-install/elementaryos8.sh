#!/bin/bash

echo "🚀 Pós Instalação - ElementaryOS 8"
echo ""

# Atualiza os repositórios e pacotes
echo "🔄 Atualizando repositórios e pacotes..."
sudo apt update && sudo apt upgrade -y

echo "✅ Pacotes atualizados!"

# Instala pacotes essenciais
echo "📦 Instalando pacotes essenciais..."
sudo apt install -y software-properties-common software-properties-gtk
echo "✅ Pacotes essenciais instalados!"

# Adiciona repositórios adicionais
echo "➕ Adicionando repositórios universe, multiverse e restricted..."
sudo add-apt-repository -y universe
sudo add-apt-repository -y multiverse
sudo add-apt-repository -y restricted
echo "✅ Repositórios adicionados!"

# Atualiza os repositórios e pacotes
echo "🔄 Atualizando repositórios e pacotes..."
sudo apt update && sudo apt upgrade -y

# Instala pacotes úteis
echo "📥 Instalando pacotes úteis..."
sudo apt install -y ubuntu-restricted-extras curl git gparted build-essential ubuntu-drivers-common gdebi
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
sudo nala fetch
echo "✅ Nala instalado e atualizado!"

# Atualiza os repositórios e pacotes
echo "🔄 Atualizando repositórios e pacotes..."
sudo apt update && sudo apt upgrade -y

# Finaliza com a última atualização
echo "🧹 Removendo pacotes desnecessários..."
sudo apt autoremove -y && sudo apt autoclean
echo "✅ Limpeza concluída!"

# Mensagem final
echo "🎉 Configuração pós-instalação concluída! Reinicie o sistema se necessário."
