#!/bin/bash

echo "🚀 Instalação - PHP 7.4"
echo ""

# Verifica se o parâmetro --apt ou -a foi passado
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

# Atualiza pacotes e instala o PHP 7.4 e as extensões necessárias
echo "🔄 Instalando o PHP 7.4 e PHP-FPM..."
install_packages php7.4 php7.4-fpm

# Instala as extensões necessárias
echo "🔌 Instalando extensões do PHP 7.4..."
install_packages libapache2-mod-php7.4 libapache2-mod-fcgid php7.4-fpm php7.4-common php7.4-cli php7.4-json php7.4-opcache php7.4-readline php7.4-zip php7.4-gd php7.4-mysql php7.4-mbstring php7.4-xml php7.4-xmlrpc php7.4-xsl php7.4-curl php7.4-tidy php7.4-soap php7.4-sqlite3 php7.4-odbc php7.4-intl php7.4-imap php7.4-bz2

# Ativa a configuração do PHP 7.4
echo "⚙️ Ativando a versão do PHP 7.4..."
sudo a2enconf php7.4-fpm

# Reinicia o Apache 2
echo "🔄 Reiniciando o Apache..."
sudo service apache2 restart
sudo service apache2 reload

# Cria o arquivo de configuração php74.conf
echo "📄 Criando arquivo de configuração php74.conf..."
cat <<EOL | sudo tee /etc/apache2/sites-available/php74.conf
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
        SetHandler "proxy:unix:/run/php/php7.4-fpm.sock|fcgi://localhost/"
    </FilesMatch>

    ErrorLog ${APACHE_LOG_DIR}/error-php74.log
    CustomLog ${APACHE_LOG_DIR}/access-php74.log combined
</VirtualHost>
EOL

# Desabilita a configuração padrão
echo "❌ Desabilitando a configuração padrão..."
sudo a2dissite 000-default.conf

# Habilita a nova configuração do PHP 7.4
echo "✅ Habilitando a configuração do PHP 7.4..."
sudo a2ensite php74

# Reinicia o Apache para aplicar as mudanças
echo "🔄 Reiniciando o Apache novamente..."
sudo service apache2 restart
sudo service apache2 reload

# Verifica a configuração do Apache
echo "🔍 Verificando a configuração do Apache..."
sudo apachectl configtest

# Ajusta o arquivo de configuração www.conf
echo "⚙️ Ajustando configurações do PHP-FPM..."
sudo sed -i 's/;security.limit_extensions = .php/security.limit_extensions = .php/' /etc/php/7.4/fpm/pool.d/www.conf

# Configurações do php.ini
# Obtém o diretório onde o script está localizado
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copia o php74.ini local para o diretório correto
echo "📄 Copiando php74.ini local..."
sudo cp "$SCRIPT_DIR/php-ini/php74.ini" /etc/php/7.4/fpm/php.ini

# Reinicia o PHP-FPM
echo "🔄 Reiniciando PHP-FPM..."
sudo service php7.4-fpm restart

# Concluído
echo "🎉 Instalação do PHP 7.4 concluída!"
