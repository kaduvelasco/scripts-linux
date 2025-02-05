#!/bin/bash

echo "🚀 Instalação - PHPStorm"
echo "📂 O arquivo de instalação (phpstorm.tar.gz) deve estar na mesma pasta que este script"

# Garante que o script só será executado se o arquivo existir
if [ ! -f "phpstorm.tar.gz" ]; then
    echo "❌ Erro: O arquivo phpstorm.tar.gz não foi encontrado! Certifique-se de que ele está na mesma pasta que este script."
    exit 1
fi

# Desinstalando versões antigas
echo "🗑️ Removendo versões antigas do PHPStorm..."
sudo rm -Rf /opt/phpstorm*
sudo rm -Rf /usr/bin/phpstorm
sudo rm -Rf /usr/share/applications/phpstorm.desktop

# Instalando...
echo "📦 Instalando PHPStorm..."
sudo tar vzxf phpstorm.tar.gz -C /opt/
sudo mv /opt/PhpStorm*/ /opt/phpstorm
sudo ln -sf /opt/phpstorm/bin/phpstorm.sh /usr/bin/phpstorm

# Criando atalho no menu
echo "🖥️ Criando atalho no menu..."
echo -e '[Desktop Entry]\nVersion=1.0\nName=PHPStorm\nExec=/opt/phpstorm/bin/phpstorm\nIcon=/opt/phpstorm/bin/phpstorm.png\nType=Application\nCategories=Development;IDE;' | sudo tee /usr/share/applications/phpstorm.desktop > /dev/null

echo "✅ Instalação concluída! Você pode iniciar o PHPStorm executando 'phpstorm' no terminal ou acessando no menu."
