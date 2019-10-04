#!/bin/bash

#=============================CABEÇALHO======================================|
#
#  AUTOR
#     Felipe Fernandes <felipefernandesgsc@gmail.com>
#
#  PROGRAMA
#	  CS-WEB
#
#  DATA DE CRIAÇÃO
#     08/09/2019
#
#  DESCRIÇÃO
#	  Realiza a configuração do serviço WEB.
#
#============================================================================|

while : ; do
cat << END

		Web - Apache

1 - Instalar Apache
2 - Configurar um site
3 - Habilitar um site
4 - Desabilitar um site
5 - Modificar arquivo de um site

0 - Sair do Programa

END
read -p "Escolha qual opção quer executar: " opcao

case $opcao in
	0)
	exit
	;;

	1)
	apt-get install apache2 apache2-doc
	;;

	2)
	;;

	3)
	echo -e "\nDigite o nome de um dos seguintes diretórios para ativar o site\n\n"
	printf '%s\n' /var/www/* | cut -d/ -f 4
	echo
	read -p "Diretório: " dir
	a2ensite ${dir}.conf || echo -e "\nFalha na ativação!"
	systemctl restart apache2 || echo -e "\nFalha em reiniciar serviço"
	;;

	4)
	echo -e "\nDigite o nome de um dos seguintes diretórios para desativar o site\n\n"
	printf '%s\n' /var/www/* | cut -d/ -f 4
	echo
	read -p "Diretório: " dir
	a2dissite ${dir}.conf || echo -e "\nFalha na desativação!"
	systemctl restart apache2 || echo -e "\nFalha em reiniciar serviço"
	;;

	5)
	;;

	*)
	;;
esac


done