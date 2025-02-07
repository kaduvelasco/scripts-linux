#!/bin/bash

echo "🚀 Instalação - PHP 8.1"
echo ""

# Verificar se o script foi chamado com o parâmetro --apt ou -a para forçar o uso do APT
USE_APT=false
for arg in "$@"; do
    if [[ "$arg" == "--apt" || "$arg" == "-a" ]]; then
        USE_APT=true
        break
    fi
done

# Função para instalar pacotes
install_packages() {
  if $USE_APT || ! command -v nala &> /dev/null; then
    # Usa o APT se o parâmetro for passado ou o Nala não estiver instalado
    sudo apt install -y "$@"
  else
    # Usa o Nala se estiver instalado
    sudo nala install -y "$@"
  fi
}

# Atualiza pacotes e instala o PHP 8.1 e as extensões necessárias
echo "🔄 Instalando o PHP 8.1 e PHP-FPM..."
install_packages php8.1 php8.1-fpm

# Instala as extensões necessárias
echo "🔌 Instalando extensões do PHP 8.1..."
install_packages libapache2-mod-php8.1 libapache2-mod-fcgid php8.1-fpm php8.1-common php8.1-cli php8.1-opcache php8.1-readline php8.1-zip php8.1-gd php8.1-mysql php8.1-mbstring php8.1-xml php8.1-xmlrpc php8.1-xsl php8.1-curl php8.1-tidy php8.1-soap php8.1-sqlite3 php8.1-odbc php8.1-intl php8.1-imap php8.1-bz2

# Ativa a configuração do PHP 8.1
echo "⚙️ Ativando a versão do PHP 8.1..."
sudo a2enconf php8.1-fpm

# Reinicia o Apache 2
echo "🔄 Reiniciando o Apache..."
sudo service apache2 restart
sudo service apache2 reload

# Cria o arquivo de configuração php81.conf
echo "📄 Criando arquivo de configuração php81.conf..."
cat <<EOL | sudo tee /etc/apache2/sites-available/php81.conf
<VirtualHost *:80>
    ServerAdmin admin@localhost
    ServerName localhost
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    </Directory>

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/php8.1-fpm.sock|fcgi://localhost/"
    </FilesMatch>

    ErrorLog ${APACHE_LOG_DIR}/error-php81.log
    CustomLog ${APACHE_LOG_DIR}/access-php81.log combined
</VirtualHost>
EOL

# Desabilita a configuração padrão
echo "❌ Desabilitando a configuração padrão..."
sudo a2dissite 000-default.conf

# Habilita a nova configuração do PHP 8.1
echo "✅ Habilitando a configuração do PHP 8.1..."
sudo a2ensite php81

# Reinicia o Apache para aplicar as mudanças
echo "🔄 Reiniciando o Apache novamente..."
sudo service apache2 restart
sudo service apache2 reload

# Verifica a configuração do Apache
echo "🔍 Verificando a configuração do Apache..."
sudo apachectl configtest

# Ajusta o arquivo de configuração www.conf
echo "⚙️ Ajustando configurações do PHP-FPM..."
sudo sed -i 's/;security.limit_extensions = .php/security.limit_extensions = .php/' /etc/php/8.1/fpm/pool.d/www.conf

# Configurações do php.ini
# Obtém o diretório onde o script está localizado
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copia o php81.ini local para o diretório correto
echo "📄 Copiando php81.ini local..."
sudo cp "$SCRIPT_DIR/php-ini/php81.ini" /etc/php/8.1/fpm/php.ini

# Reinicia o PHP-FPM
echo "🔄 Reiniciando PHP-FPM..."
sudo service php8.1-fpm restart

# Concluído
echo "🎉 Instalação do PHP 8.1 concluída!"
