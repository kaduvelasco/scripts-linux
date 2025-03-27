sudo apt update
sudo apt upgrade

// Pré- requisitos
sudo apt install dirmngr ca-certificates software-properties-common apt-transport-https lsb-release curl -y

curl -fSsL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /usr/share/keyrings/postgresql.gpg > /dev/null

echo deb [arch=amd64,arm64,ppc64el signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main | sudo tee /etc/apt/sources.list.d/postgresql.list

sudo apt install postgresql-client-15 postgresql-15

systemctl status postgresql
sudo systemctl stop postgresql
sudo systemctl start postgresql
sudo systemctl restart postgresql
sudo systemctl reload postgresql

==============================================================================



sudo -u postgres psql


psql -h localhost -U admin

// Cria o banco de dados
1. Conecta com usuário padrão
sudo -u postgres psql

2. Cria o banco


3. Permissão para o usuário admin


4. Verificar se o usuário possui acesso






================================================================================================================================
// CONACTAR USUÁRIO padrão
sudo -i -u postgres
OU
sudo -u postgres psql

// COMANDOS
\l => Lista bancos
\q => sair do shell

// TODO: Criar um usuário
CREATE USER admin ENCRYPTED PASSWORD '126865872';

// TODO: Criar um banco
CREATE DATABASE moodle_404e;

// REMOVER UM BANCO
DROP DATABASE moodle_404e;

// RESTAURAR BANCO
// 1. Move o diretório para um deretório onde o usuário do postgres tenha acesso
sudo cp /home/cadu/Downloads/mdl_efape-13-03-2025_20h31.custom /tmp/
cd /tmp
// 2. Restaura
sudo -u postgres pg_restore --jobs=8 -x --no-owner --dbname=moodle_404e /tmp/mdl_efape-13-03-2025_20h31.custom

// PERMISSÔES
GRANT ALL PRIVILEGES ON DATABASE moodle_404e TO admin;
GRANT CREATE ON SCHEMA public TO admin;
GRANT USAGE ON SCHEMA public TO admin;
ALTER SCHEMA public OWNER TO admin;

// TESTAR ACESSO
exit
psql -h localhost -U admin -d moodle_404e


// Ordem de execução: Cria usuário > Cria Banco > Restaura Banco > Permissões para usuário de trabalho


ALTER USER postgres WITH PASSWORD '126865872';


$2y$10$B5uepKt4M5YBQj.xPD9df.WlLCXFpY3zod.06k7SlKzDG.yB7cbRO

$6$rounds=10000$a1adcf0eaed6714517368542d9e307bdc5b053e89f3d220c0fafb0915156deeb645d6017ece1ecff07e82888a9f90319b2b1d5137f41dcc65ee42eaef5289c73








