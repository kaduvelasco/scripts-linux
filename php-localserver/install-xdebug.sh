#!/bin/bash

echo "🚀 Instalação - xDebug"
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
    echo "🔄 Usando APT para instalar pacotes..."
    sudo apt install -y "$@"
  else
    # Usa o Nala se estiver instalado
    echo "🔄 Usando Nala para instalar pacotes..."
    sudo nala install -y "$@"
  fi
}

# Perguntar a versão do PHP
echo "⚙️ Escolha a versão do PHP para instalar o xDebug:"
echo "1 - PHP 8.0"
echo "2 - PHP 8.1"
echo "3 - PHP 8.2"
echo "4 - PHP 8.3"
read -p "Digite o número correspondente: " choice

case $choice in
    1) PHP_VERSION="8.0" ;;
    2) PHP_VERSION="8.1" ;;
    3) PHP_VERSION="8.2" ;;
    4) PHP_VERSION="8.3" ;;
    *) echo "❌ Opção inválida."; exit 1 ;;
esac

# Verificar se o PHP está instalado
echo "🔍 Verificando se o PHP está instalado..."
if ! command -v php$PHP_VERSION &> /dev/null; then
    echo "⚠️ PHP $PHP_VERSION não está instalado. Instale antes de continuar."
    exit 1
fi

# Instalar xDebug
echo "📦 Instalando o xDebug..."
install_packages php$PHP_VERSION-xdebug

# Reiniciar servidor local corretamente
echo "🔄 Reiniciando o servidor..."
if systemctl is-active --quiet apache2; then
    sudo systemctl restart apache2
elif systemctl is-active --quiet php$PHP_VERSION-fpm; then
    sudo systemctl restart php$PHP_VERSION-fpm
elif systemctl is-active --quiet nginx; then
    sudo systemctl restart nginx && sudo systemctl restart php$PHP_VERSION-fpm
else
    echo "❌ Nenhum servidor detectado para reiniciar. Verifique manualmente."
fi

# Verificar se o xDebug está ativo
echo "🔎 Verificando a instalação do xDebug..."
if php -m | grep -q 'xdebug'; then
    echo "🎉 xDebug instalado com sucesso!"
else
    echo "❌ Erro: xDebug não foi ativado corretamente."
    exit 1
fi

# Determinar o arquivo php.ini correto
echo "📂 Determinando o php.ini correto..."
PHP_INI_PATH=$(php --ini | grep "Loaded Configuration File" | awk '{print $NF}')

# ✍️ Adicionar configurações ao php.ini
echo "📝 Adicionando configurações do xDebug ao $PHP_INI_PATH..."
echo "[xdebug]" | sudo tee -a $PHP_INI_PATH
sudo tee -a $PHP_INI_PATH <<EOL
zend_extension=xdebug.so
xdebug.mode=debug
xdebug.client_host=127.0.0.1
xdebug.client_port=9003
xdebug.log=/var/log/xdebug.log
xdebug.max_nesting_level=512
xdebug.start_with_request=yes
xdebug.display_errors=1
xdebug.log_level=0
xdebug.discover_client_host=1
EOL

# Reiniciar servidor local novamente para aplicar as configurações
echo "🔄 Reiniciando o servidor..."
if systemctl is-active --quiet apache2; then
    sudo systemctl restart apache2
elif systemctl is-active --quiet php$PHP_VERSION-fpm; then
    sudo systemctl restart php$PHP_VERSION-fpm
elif systemctl is-active --quiet nginx; then
    sudo systemctl restart nginx && sudo systemctl restart php$PHP_VERSION-fpm
fi

echo "🎯 xDebug instalado e configurado com sucesso!"
