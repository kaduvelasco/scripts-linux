#!/bin/bash

echo "🚀 Instalação - MariaDB"
echo ""

# Função para gerar uma senha forte (caso o usuário não queira criar uma manualmente)
generate_password() {
    < /dev/urandom tr -dc 'A-Za-z0-9_@#$%^&+=!' | head -c 16
}

# Solicitar senha para o usuário 'admin'
echo "🔐 Por favor, insira a senha para o usuário 'admin':"
read -s ADMIN_PASSWORD

# Verificar se o usuário forneceu a senha
if [ -z "$ADMIN_PASSWORD" ]; then
    echo "🔑 A senha do usuário 'admin' não foi fornecida. Gerando uma senha aleatória..."
    ADMIN_PASSWORD=$(generate_password)
    echo "Senha gerada para o usuário 'admin': $ADMIN_PASSWORD"
else
    echo "✅ Senha do usuário 'admin' definida com sucesso."
fi

# Perguntar se deseja adicionar o repositório MariaDB
echo "📦 Adicionar o repositório oficial do MariaDB ou continuar com os repositórios da distro? [A - Adicionar / C - Continuar]"
read ADD_REPO

if [[ "$ADD_REPO" == "A" || "$ADD_REPO" == "a" ]]; then
    echo "📦 Adicionando repositórios MariaDB..."
    sudo wget -qO - https://mariadb.org/mariadb_release_signing_key.asc | sudo apt-key add -
    sudo add-apt-repository 'deb [arch=amd64] https://mariadb.mirror.globo.com/repo/10.5/ubuntu bionic main'
else
    echo "❌ Repositório MariaDB não adicionado. Continuando com os repositórios padrão."
fi

# Instalar dependências necessárias
echo "⚙️ Instalando dependências..."
sudo nala install wget software-properties-common dirmngr ca-certificates apt-transport-https -y

# Atualizar pacotes
echo "🔄 Atualizando pacotes..."
sudo nala update && sudo nala upgrade -y

# Instalar MariaDB
echo "📥 Instalando MariaDB..."
sudo nala install mariadb-server -y

# Iniciar o serviço MariaDB
echo "🚀 Iniciando o serviço MariaDB..."
sudo service mariadb start

# Criando o usuário admin com a senha fornecida ou gerada
echo "👤 Criando usuário 'admin' no MariaDB..."
sudo mariadb -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY '$ADMIN_PASSWORD';"
sudo mariadb -e "GRANT ALL ON *.* TO 'admin'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# Exibir as credenciais criadas
echo "🎉 Credenciais criadas:"
echo "Usuário 'admin' com senha: $ADMIN_PASSWORD"
echo ""

# Testar acesso com o usuário 'admin' - sem interação
echo "🔍 Testando acesso com o usuário 'admin'..."
echo "SHOW DATABASES;" | sudo mariadb -u admin -p"$ADMIN_PASSWORD"

# Verificar versão do MariaDB
echo "📅 Verificando versão do MariaDB..."
sudo mariadb --version

echo "✅ Script concluído!"
