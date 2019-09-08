#!/bin/bash

#---------------------CABECALHO----------------------------------------------|
#
#  AUTOR
#     Felipe Fernandes <felipefernandesgsc@gmail.com>
#	   Gabriel Viana Lourenço <4463gabrielviana@gmil.com>
#
#  PROGRAMA
#	   CService
#
#  DATA DE CRIAÇÃO
#     08/09/2019
#
#  DESCRICAO
#	   Central de acesso aos programas de configuração de serviços
#
#----------------------------------------------------------------------------|

#Variavel
usr="$1"
path="/home/${usr}/LazyMoon/LM-CService/"

#Menu de Seleção
while : ; do
opcao=$(dialog \
	--stdout \
	--menu 'Selecione um Serviço' \
	0 0 0 \
	WEB 'APACHE' \
	DNS 'Bind' \
	DHCP 'ISC DHCP Server' \
	VOIP 'Asterix' \
	FTP 'vsFTPd' \
	Contato 'Entrar em Contato com Suporte' \
	Sair 'Sair do Programa' \
)


#Acessando as Opções
case $opcao in

   WEB)
   bash ${path}CS-WEB.sh
   ;;

   DNS)
   bash ${path}CS-DNS.sh
   ;;

   DHCP)
   bash ${path}CS-DHCP.sh
   ;;

   FTP)
   bash ${path}CS-FTP.sh
   ;;

   Contato)
   dialog \
   --stdout --title "E-mail para contato" \
   --msgbox "\nFelipe Fernandes \n felipefernandesgsc@gmail.com \n\n\
Gabriel Viana \n  4463gabrielviana@gmail.com" 11 40
   ;;

   Sair)
   exit 0
   ;;
esac

done
