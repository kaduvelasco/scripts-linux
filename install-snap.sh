#!/bin/bash

# Início do processo de instalação
clear
echo -e "🛠️ Iniciando a instalação do Snap no Zorin OS 17..."

# Atualizando o sistema
echo -e "🔄 Atualizando pacotes do sistema..."
sudo apt update && sudo apt upgrade -y

# Instalando o snapd
echo -e "⚙️ Instalando o Snapd..."
sudo apt install snapd -y

# Habilitando o serviço snapd
echo -e "✅ Habilitando o serviço snapd..."
sudo systemctl enable --now snapd.socket

# Verificando se o Snap foi instalado corretamente
echo -e "🔍 Verificando a instalação do Snap..."
snap version

# Instruções finais
echo -e "🚀 Snap instalado com sucesso! Você pode agora usar o Snap para instalar aplicativos."

echo -e "ℹ️ Para instalar um aplicativo com Snap, use o comando: sudo snap install <nome-do-aplicativo>"

echo -e "📝 Por exemplo, para instalar o VLC, use: sudo snap install vlc"

echo -e "🎉 Processo concluído! Aproveite as suas novas opções de aplicativos!"

