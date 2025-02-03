#!/bin/bash

echo "🚀 Instalação - Apache"
echo ""

# Verificar se a opção --apt ou -a foi passada
USE_APT=false
for arg in "$@"; do
    if [[ "$arg" == "--apt" || "$arg" == "-a" ]]; then
        USE_APT=true
        break
    fi
done

# Função para usar o apt ou nala
install_package() {
    if $USE_APT; then
        sudo apt "$@"
    elif command -v nala &> /dev/null; then
        sudo nala "$@"
    else
        sudo apt "$@"
    fi
}

# Adiciona repositório do Apache
echo "📦 Adicionando repositório do Apache"
sudo add-apt-repository -y ppa:ondrej/apache2

# Atualiza os pacotes
echo "🔄 Atualizando pacotes..."
install_package update
install_package upgrade

# Instala os pré-requisitos
echo "🔧 Instalando pré-requisitos..."
install_package install -y curl wget gnupg2 ca-certificates lsb-release apt-transport-https

# Instala o Apache 2 com fcgi
echo "🌐 Instalando Apache 2 com mod_fcgi..."
install_package install -y apache2 libapache2-mod-fcgid

# Configura Apache
echo "⚙️ Configurando Apache..."
sudo bash -c 'echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf'

# Verifica se o script está sendo executado no WSL
if grep -qEi "(Microsoft|WSL)" /proc/version &>/dev/null; then
    echo "🐧 Executando as configurações necessárias para o WSL"
    # Caso WSL, adicionar as configurações para o Apache
    echo -e "\nAcceptFilter http none\nAcceptFilter https none" | sudo tee -a /etc/apache2/apache2.conf > /dev/null
fi

# Reinicia o Apache
echo "🔁 Reiniciando Apache..."
sudo service apache2 restart

echo "🎉 Configuração concluída!"
