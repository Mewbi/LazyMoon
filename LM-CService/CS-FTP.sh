#!/bin/bash

#=============================CABEÇALHO======================================|
#
#  AUTOR
#     Felipe Fernandes <felipefernandesgsc@gmail.com>
#
#  PROGRAMA
#	  CS-FTP
#
#  DATA DE CRIAÇÃO
#     06/10/2019
#
#  DESCRIÇÃO
#	  Realiza a configuração do serviço FTP.
#
#============================================================================|

while : ; do
opcao=$(dialog \
	--stdout \
	--menu 'Selecione uma Opção' \
	0 0 0 \
	Instalar 'vsFTPd' \
	Configurar 'Configura FTP' \
	Ativar 'Ativa o serviço FTP' \
	Desativar 'Desativa o serviço FTP' \
	Grupo 'Cria um novo grupo' \
	Usuario 'Cria um novo usuário' \
	Adicionar 'Adiciona usuário a um grupo existente' \
	Sair 'Sair do Programa' \
)


case $opcao in
	Sair)
	exit
	;;

	Instalar)
	apt-get install vsftpd ftp
	cp -a /etc/vsftpd.conf /etc/vsftpd.conf.backup
	;;

	Configurar)
	conf="1"
	while [[ "$conf" != "0" ]] ; do
		msg=$(dialog --stdout \
			--title 'Mensagem' \
			--inputbox "Digite a mensagem que será apresentada ao iniciar o serviço FTP:" 0 0
		)
		dialog --stdout \
			--title 'Usuário Anônimo' \
			--yesno 'Usuário anônimo estará disponível?' 0 0
		
		if [[ "$?" == "0" ]]; then
			anonymous="YES"
		else
			anonymous="NO"
		fi
		dir=$(dialog --stdout \
			--title 'Diretório' \
			--inputbox 'Digite o diretório padrão ao iniciar o serviço FTP:
						\n\nRecomenda-se /home/ftp' 0 0
		)
		#Confirmação
		dialog --stdout \
			--title 'Confirmação' \
			--yesno "As seguintes informações estão corretas?\n
					\n	Mensagem = ${msg} \n	Anônimo = ${anonymous} \n	Diretório = ${dir}\n" \
					0 0
		conf="$?"
	done
	#Configurando FTP
	echo "listen=NO
listen_ipv6=YES
#listen_address=
anonymous_enable=$anonymous
local_enable=YES
#write_enable=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
#xferlog_file=/var/log/vsftpd.log
#idle_session_timeout=600
#data_connection_timeout=120
ftpd_banner=$msg
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO
anon_root=$dir" > /etc/vsftpd.conf

	mkdir $dir
	chmod 555 $dir
	chown ftp.ftp $dir

	#Iniciando FTP
	systemctl restart vsftpd && dialog --stdout --title "Sucesso systemctl" --msgbox "Sucesso em reiniciar serviço!" 5 40 \
	|| dialog --stdout --title "Erro systemctl" --msgbox "Falha em reiniciar serviço!" 5 40
	;;

	Ativar)
	systemctl restart vsftpd && dialog --stdout --title "Sucesso systemctl" --msgbox "Sucesso em iniciar serviço!" 5 40 \
	|| dialog --stdout --title "Erro systemctl" --msgbox "Falha em iniciar serviço!" 5 40
	;;

	Desativar)
	systemctl stop vsftpd && dialog --stdout --title "Sucesso systemctl" --msgbox "Sucesso em desativar serviço!" 5 40 \
	|| dialog --stdout --title "Erro systemctl" --msgbox "Falha em desativar serviço!" 5 40
	;;

	Grupo)
	echo
	;;

	Usuario)
	echo
	;;

	Adicionar)
	echo
	;;

esac


done