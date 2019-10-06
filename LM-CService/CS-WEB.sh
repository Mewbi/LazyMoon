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
opcao=$(dialog \
	--stdout \
	--menu 'Selecione uma Opção' \
	0 0 0 \
	Instalar 'Apache2, Apache2-doc' \
	Configurar 'Cria um novo site' \
	Habilitar 'Habilita um site' \
	Desabilitar 'Desativa um site' \
	Editar 'Edita arquivo de um site' \
	Sair 'Sair do Programa' \
)


case $opcao in
	Sair)
	exit
	;;

	Instalar)
	apt-get install apache2 apache2-doc
	;;

	Configurar)
	site=$(dialog --stdout \
	--title 'Nome do Site' \
	--inputbox "Digite o nome do diretório que será armazenado o site. \n\nEx: site.com" 0 0
	)

	#Criando local para armazenamento do site
	mkdir -p /var/www/$site/public_html
	chown -R $USER:$USER /var/www/$site/public_html
	chmod -R 755 /var/www

	#Criando página HTML
	echo "" > /var/www/$site/public_html/index.html

	#Configurando o site
	cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$site.conf
	echo "<VirtualHost *:80>
	ServerAdmin admin@$site
	ServerName $site
	DocumentRoot /var/www/$site/public_html
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
	</VirtualHost>" > /etc/apache2/sites-available/$site.conf

	#Ativação do site
	a2ensite $site.conf && dialog --stdout --title "Sucesso a2ensite" --msgbox "Sucesso na ativação do site!" 5 40 \
	|| dialog --stdout --title "Erro a2ensite" --msgbox "Erro na ativação do site!" 5 40
	a2dissite 000-default.conf 2> /dev/null
	systemctl restart apache2 && dialog --stdout --title "Sucesso systemctl" --msgbox "Sucesso em reiniciar serviço!" 5 40 \
	|| dialog --stdout --title "Erro systemctl" --msgbox "Falha em reiniciar serviço!" 5 40 
	;;

	Habilitar)
	lista=$(printf '%s\n' /var/www/* | cut -d/ -f 4)
	dir=$(dialog --begin 15 10 \
		--stdout --title 'Sites existentes' \
		--infobox "${lista}" 0 0 \
		--and-widget \
   		--title 'Seleção de Diretório'                         \
   		--inputbox "Digite o nome de um dos diretórios ao lado para ativar o site:"  \
   		0 0
	)
	a2ensite ${dir}.conf && dialog --stdout --title "Sucesso a2ensite" --msgbox "Sucesso na ativação do site!" 5 40 \
	|| dialog --stdout --title "Erro a2ensite" --msgbox "Erro na ativação do site!" 5 40
	systemctl restart apache2 && dialog --stdout --title "Sucesso systemctl" --msgbox "Sucesso em reiniciar serviço!" 5 40 \
	|| dialog --stdout --title "Erro systemctl" --msgbox "Falha em reiniciar serviço!" 5 40 
	;;

	Desabilitar)
	lista=$(printf '%s\n' /var/www/* | cut -d/ -f 4)
	dir=$(dialog --begin 15 10 \
		--stdout --title 'Sites existentes' \
		--infobox "${lista}" 0 0 \
		--and-widget \
   		--title 'Seleção de Diretório'                         \
   		--inputbox "Digite o nome de um dos diretórios ao lado para desativar o site:"  \
   		0 0
	)
	a2dissite ${dir}.conf && dialog --stdout --title "Sucesso a2dissite" --msgbox "Sucesso na desativação do site!" 5 40 \
	|| dialog --stdout --title "Erro a2dissite" --msgbox "Erro na desativação do site!" 5 40
	systemctl restart apache2 && dialog --stdout --title "Sucesso systemctl" --msgbox "Sucesso em reiniciar serviço!" 5 40 \
	|| dialog --stdout --title "Erro systemctl" --msgbox "Falha em reiniciar serviço!" 5 40 


	a2dissite ${dir}.conf || echo -e "\nFalha na desativação!"
	systemctl restart apache2 || echo -e "\nFalha em reiniciar serviço"
	;;

	Editar)
	lista=$(printf '%s\n' /var/www/* | cut -d/ -f 4)
	editar=$(dialog --begin 15 10 \
		--stdout --title 'Sites existentes' \
		--infobox "${lista}" 0 0 \
		--and-widget \
   		--title 'Seleção de Diretório'                         \
   		--inputbox "Digite o nome de um dos diretórios ao lado para editar um arquivo:"  \
   		0 0
	)
	lista=$(printf '%s\n' /var/www/${editar}/public_html/* | cut -d/ -f 6)
	arquivo=$(dialog --begin 15 10 \
	--stdout --title 'Arquivos existentes' \
	--infobox "${lista}" 0 0 \
	--and-widget \
   	--title 'Seleção de Arquivo'                         \
   	--inputbox "Digite o nome de um dos arquivos lado para editar, ou digite um novo nome para criar um arquivo:"  \
   	10 50
	)
	nano /var/www/${editar}/public_html/${arquivo}
	;;

esac


done