#!/bin/bash

# Verificar se o parâmetro --apt ou -a foi passado
FORCE_APT=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        --apt|-a) FORCE_APT=true ;;
        *) ;;
    esac
    shift
done

# Definir o gerenciador de pacotes
if $FORCE_APT; then
    PACKAGE_MANAGER="apt"
elif command -v nala &> /dev/null; then
    PACKAGE_MANAGER="nala"
else
    PACKAGE_MANAGER="apt"
fi

echo "🚀 Iniciando a instalação do PHP e configuração do Apache..."

# Atualizar pacotes e instalar pré-requisitos
echo "🔧 Instalando pré-requisitos..."
sudo $PACKAGE_MANAGER install software-properties-common -y
if [ $? -ne 0 ]; then
    echo "❌ Ocorreu um erro ao instalar os pré-requisitos. Abortando a execução."
    exit 1
fi

# Adicionar repositório PHP
echo "📦 Adicionando repositório PHP..."
sudo add-apt-repository ppa:ondrej/php -y
if [ $? -ne 0 ]; then
    echo "❌ Ocorreu um erro ao adicionar o repositório PHP. Abortando a execução."
    exit 1
fi

# Atualizar pacotes
echo "🔄 Atualizando pacotes..."
sudo $PACKAGE_MANAGER update -y
sudo $PACKAGE_MANAGER upgrade -y
if [ $? -ne 0 ]; then
    echo "❌ Ocorreu um erro ao atualizar os pacotes. Abortando a execução."
    exit 1
fi

# Ativar módulos Apache necessários
echo "🔧 Ativando módulos Apache..."
sudo a2enmod actions fcgid alias proxy_fcgi setenvif
if [ $? -ne 0 ]; then
    echo "❌ Ocorreu um erro ao ativar os módulos Apache. Abortando a execução."
    exit 1
fi

# Reiniciar o Apache
echo "🔁 Reiniciando Apache..."
sudo service apache2 restart
if [ $? -ne 0 ]; then
    echo "❌ Ocorreu um erro ao reiniciar o Apache. Abortando a execução."
    exit 1
fi
sudo service apache2 reload
if [ $? -ne 0 ]; then
    echo "❌ Ocorreu um erro ao recarregar o Apache. Abortando a execução."
    exit 1
fi

# Criar as pastas necessárias
echo "📁 Criando pastas necessárias..."
sudo mkdir -p /var/www/data
sudo mkdir -p /var/www/html
if [ $? -ne 0 ]; then
    echo "❌ Ocorreu um erro ao criar as pastas. Abortando a execução."
    exit 1
fi

# Criar arquivos PHP para testar
echo "📝 Criando arquivos PHP de teste..."
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php > /dev/null
echo "<?php echo 'whoami'; ?>" | sudo tee /var/www/html/whoami.php > /dev/null
if [ $? -ne 0 ]; then
    echo "❌ Ocorreu um erro ao criar os arquivos PHP de teste. Abortando a execução."
    exit 1
fi

# Ajustar permissões
echo "🔒 Ajustando permissões para as pastas..."
sudo chown -R $USER:$USER /var/www/
sudo chmod -R 755 /var/www/
if [ $? -ne 0 ]; then
    echo "❌ Ocorreu um erro ao ajustar as permissões. Abortando a execução."
    exit 1
fi

# Ativar módulo Rewrite
echo "🔧 Ativando módulo Rewrite..."
sudo a2enmod rewrite
if [ $? -ne 0 ]; then
    echo "❌ Ocorreu um erro ao ativar o módulo Rewrite. Abortando a execução."
    exit 1
fi

# Reiniciar Apache novamente
echo "🔁 Reiniciando Apache após ativar o módulo Rewrite..."
sudo service apache2 restart
if [ $? -ne 0 ]; then
    echo "❌ Ocorreu um erro ao reiniciar o Apache. Abortando a execução."
    exit 1
fi

# Testar a configuração do Apache
echo "🔍 Testando a configuração do Apache..."
sudo apachectl configtest
if [ $? -ne 0 ]; then
    echo "❌ A configuração do Apache está com erros. Abortando a execução."
    exit 1
fi

# Verificar o status do Apache
echo "🛠️ Verificando o status do Apache..."
sudo systemctl status apache2 | grep "active (running)" > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Apache está ativo e funcionando."
else
    echo "❌ Apache não está funcionando corretamente."
    exit 1
fi

echo "✅ Configuração concluída! Lembre-se de instalar ao menos uma versão do PHP."
