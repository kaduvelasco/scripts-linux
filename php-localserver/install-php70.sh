#!/bin/bash

echo "🚀 Instalação - PHP 7.0"
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

# Atualiza pacotes e instala o PHP 7.0 e as extensões necessárias
echo "🔄 Instalando o PHP 7.0 e PHP-FPM..."
install_packages php7.0 php7.0-fpm

# Instala as extensões necessárias
echo "🔌 Instalando extensões do PHP 7.0..."
install_packages libapache2-mod-php7.0 libapache2-mod-fcgid php7.0-fpm php7.0-common php7.0-cli php7.0-json php7.0-opcache php7.0-readline php7.0-zip php7.0-gd php7.0-mysql php7.0-mbstring php7.0-xml php7.0-xmlrpc php7.0-xsl php7.0-curl php7.0-tidy php7.0-soap php7.0-sqlite3 php7.0-odbc php7.0-intl php7.0-imap php7.0-bz2

# Ativa a configuração do PHP 7.0
echo "⚙️ Ativando a versão do PHP 7.0..."
sudo a2enconf php7.0-fpm

# Reinicia o Apache 2
echo "🔄 Reiniciando o Apache..."
sudo service apache2 restart
sudo service apache2 reload

# Cria o arquivo de configuração php70.conf
echo "📄 Criando arquivo de configuração php70.conf..."
cat <<EOL | sudo tee /etc/apache2/sites-available/php70.conf
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
        SetHandler "proxy:unix:/run/php/php7.0-fpm.sock|fcgi://localhost/"
    </FilesMatch>

    ErrorLog ${APACHE_LOG_DIR}/error-php70.log
    CustomLog ${APACHE_LOG_DIR}/access-php70.log combined
</VirtualHost>
EOL

# Desabilita a configuração padrão
echo "❌ Desabilitando a configuração padrão..."
sudo a2dissite 000-default.conf

# Habilita a nova configuração do PHP 7.0
echo "✅ Habilitando a configuração do PHP 7.0..."
sudo a2ensite php70

# Reinicia o Apache para aplicar as mudanças
echo "🔄 Reiniciando o Apache novamente..."
sudo service apache2 restart
sudo service apache2 reload

# Verifica a configuração do Apache
echo "🔍 Verificando a configuração do Apache..."
sudo apachectl configtest

# Ajusta o arquivo de configuração www.conf
echo "⚙️ Ajustando configurações do PHP-FPM..."
sudo sed -i 's/;security.limit_extensions = .php/security.limit_extensions = .php/' /etc/php/7.0/fpm/pool.d/www.conf

# Baixa o arquivo php70.ini do repositório GitHub e substitui o existente
echo "⬇️ Baixando e substituindo o php.ini..."
curl -o /etc/php/7.0/fpm/php.ini https://github.com/kaduvelasco/scripts-linux/raw/main/php-ini/php70.ini

# Reinicia o PHP-FPM
echo "🔄 Reiniciando PHP-FPM..."
sudo service php7.0-fpm restart

# Concluído
echo "🎉 Instalação do PHP 7.0 concluída!"
