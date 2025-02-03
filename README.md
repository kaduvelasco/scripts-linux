# scripts-linux
Scripts para automatização de tarefas no linux

## Scripts gerais
Os scripts desta categoria utilizam, por padrão, o Nala (interface para o gerenciamento do APT) se ele estiver inbstalado. Caso contrário o APT padrão é usado.

Todos os script aceitam o parâmetro `--apt` ou `-a` para forçar o uso do APT.

### update_system.sh
Realiza a atualização dos pacotes do SO e dos Flatpaks.

`sudo ./update_system.sh`

`sudo ./update_system.sh --apt`

`sudo ./update_system.sh -a`

## Servidor PHP
Oferece uma série de scripts para automatizar algumas tarefas voltadas ao uso de um servidor local PHP.

Nenhum desses scripts possibilita o uso de parâmetros

### fixpermissions.sh
Corrige as permissões nas pastas do servidor

`sudo ./fixpermissions.sh`

### php-version.sh
Altera a versão do PHP padrão do sistema.

Todos os scripts PHP serão executados com a versão escolhida.

`sudo ./php-version.sh`

## Servidor PHP - Automatização da instalação
Os scripts desta categoria utilizam, por padrão, o Nala (interface para o gerenciamento do APT) se ele estiver inbstalado. Caso contrário o APT padrão é usado.

Todos os script aceitam o parâmetro `--apt` ou `-a` para forçar o uso do APT.

A ordem de execução que eu constumo utilizar é:

### Instalação do MariaDB
`sudo ./php-localserver/install-mariadb.sh`

### Instalação do Apache 2
`sudo ./php-localserver/install-apache.sh`

### Instalação do PHP - Pré-requisitos
`sudo ./php-localserver/install-php.sh`