#!/bin/bash
#Central de configuração de serviços

#---------------------CABECALHO----------------------------------------------|
#AUTOR
#	Gabriel Viana Lourenço <4463gabrielviana@gmil.com>
#
#PROGRAMA
#	Central de Configuração de Serviços
#
#DESCRICAO
#	Realiza a configuração de serviços de servidores Debian
#
#----------------------------------------------------------------------------|

#Variavel
caminho="/home/${usr}/LazyMoon/LM-CService/"

#Testa conexão com a internet
clear
ping www.google.com.br -c 1 >/dev/null;
	if [ "$?" = "0" ] ;
		then
		sleep 2
	
	else
		clear
		dialog --stdout --title "Falha na Conexão" \
		   	 	--msgbox "Verifique sua conexão! Não será possivel instalar novos serviços" 0 0
#		echo -e "Falha na conexão! \nPor favor verifique a saída com a internet para utilização desse programa \n\n\nIremos prosseguir porém não será possivel instalar novos serviços"
		sleep 4
		
	fi
	
#Menu de Seleção
while : ; do
opcao=$(dialog \
	--stdout \
	--menu 'Selecione um Serviço' \
	0 0 0 \
	WEB 'APACHE' \
	DNS 'Bind' \
	DHCP \
	VOIP 'Asterix' \
	FTP 'vsFTPd' \
	Contato 'Entrar em Contato com Suporte' \
	Sair 'Sair do Programa' \
)


#Acessando as Opções
case $opcao in

   WEB)
   bash ${caminho}CS-WEB.sh
   ;;

   DNS)
   bash ${caminho}CS-DNS.sh
   ;;

   DHCP)
   bash ${caminho}CS-DHCP.sh
   ;;

   VOIP)
   bash ${caminho}CS-VOIP.sh
   ;;

   FTP)
   bash ${caminho}CS-FTP.sh
   ;;

   Contato)
   dialog \
   --stdout --title "E-mail para contato" \
   --msgbox "4463gabrielviana@gmail.com" 5 40
   ;;

   Sair)
   exit 0
   ;;
esac

done
