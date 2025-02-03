#!/bin/bash

# Função para verificar se o comando foi bem-sucedido
check_command() {
    if [ $? -ne 0 ]; then
        echo "❌ Ocorreu um erro. Abortando a execução."
        exit 1
    fi
}

echo "🚀 Iniciando a instalação do PHP e configuração do Apache..."

# Atualizar pacotes e instalar pré-requisitos
echo "🔧 Instalando pré-requisitos..."
sudo nala install software-properties-common -y
check_command

# Adicionar repositório PHP
echo "📦 Adicionando repositório PHP..."
sudo add-apt-repository ppa:ondrej/php -y
check_command

# Atualizar pacotes
echo "🔄 Atualizando pacotes..."
sudo apt update -y
check_command
sudo apt upgrade -y
check_command

# Ativar módulos Apache necessários
echo "🔧 Ativando módulos Apache..."
sudo a2enmod actions fcgid alias proxy_fcgi setenvif
check_command

# Reiniciar o Apache
echo "🔁 Reiniciando Apache..."
sudo service apache2 restart
check_command
sudo service apache2 reload
check_command

# Criar as pastas necessárias
echo "📁 Criando pastas necessárias..."
sudo mkdir -p /var/www/data
sudo mkdir -p /var/www/html
check_command

# Criar arquivos PHP para testar
echo "📝 Criando arquivos PHP de teste..."
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php > /dev/null
echo "<?php echo 'whoami'; ?>" | sudo tee /var/www/html/whoami.php > /dev/null

# Ajustar permissões
echo "🔒 Ajustando permissões para as pastas..."
sudo chown -R $USER:$USER /var/www/
sudo chmod -R 755 /var/www/
check_command

# Ativar módulo Rewrite
echo "🔧 Ativando módulo Rewrite..."
sudo a2enmod rewrite
check_command

# Reiniciar Apache novamente
echo "🔁 Reiniciando Apache após ativar o módulo Rewrite..."
sudo service apache2 restart
check_command

# Testar a configuração do Apache
echo "🔍 Testando a configuração do Apache..."
sudo apachectl configtest
check_command

# Verificar o status do Apache
echo "🛠️ Verificando o status do Apache..."
sudo systemctl status apache2 | grep "active (running)" > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Apache está ativo e funcionando."
else
    echo "❌ Apache não está funcionando corretamente."
fi

echo "✅ Configuração concluída! Lembre-se de instalar ao menos uma versão do PHP."
