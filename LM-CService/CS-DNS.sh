#!/bin/bash

#=============================CABEÇALHO======================================|
#
#  AUTOR
#     Gabriel Viana Lourenço <4463gabriel@gmail.com>
#
#  PROGRAMA
#	  CS-DNS
#
#  DATA DE CRIAÇÃO
#     12/10/2019
#
#  DESCRIÇÃO
#	  Realiza a configuração de serviços de DNS utilizando Bind9 com UX em Dialog
#
#============================================================================|

while : ; do
opcao=$(dialog \
	--stdout \
	--menu 'Selecione uma Opção' \
	0 0 0 \
	Instalar 'Bind9' \
	Configurar 'Configurar Zonas' \
	Ativar 'Ativar/Reinciar Serviço' \
	Sair 'Sair do Programa' \
)


case $opcao in
	Sair)
	exit
	;;

	Instalar)
	apt-get install bind9
	;;

	Configurar)
	domzd=$(dialog --stdout \
	--title 'Nome de Domínio' \
	--inputbox "Digite o nome de domínio. \n\nEx: dominio.com" 0 0
	)

	#Criando arquivo para Zona Direta
	echo "
	zone \"$domzd\" {
	type master;
	file \"/etc/bind/db.$domzd\";
	};
	" >> /etc/bind/named.conf.local

	ipdom=$(dialog --stdout \
	--title 'IP - Redirecionado' \
	--inputbox "Digite o IP para redirecionamento" 0 0
	)

	ipdns=$(dialog --stdout \
	--title 'IP - DNS' \
	--inputbox "Digite o IP do servidor DNS" 0 0
	)

	ipgw=$(dialog --stdout \
	--title 'IP - Gateway' \
	--inputbox "Digite o IP para Gateway" 0 0
	)

	#Configurando o domínio
	echo ";
	; BIND zone file for $domzd
	;
	\$TTL		3D
	@			IN		SOA		$domzd.				root.$domzd. (
								01					; serial
								8H					; refresh
								2H					; retry
								4W					; expire
								1D )				; minimum
	;
	@			IN		NS		ns.$domzd.
	ns				A		$ipdom
	$domzd      	A		$ipdom
	server			A		$ipdns
	router			A		$ipgw
	www				CNAME	$domzd." >> /etc/bind/db.$domzd

	#Adicionar domínio resolv.conf
	echo "
	domain $domzd
	search $domzd
	nameserver 127.0.0.1
	" >> /etc/resolv.conf

	#Verificar documentos
	named-checkconf

	#Confirmar Reversa
	reversa=$(dialog --stdout \
   	--title 'AVISO' \
   	--yesno "\nO A Zona Direta foi configurada!.
            Você quer configurar a Zona Reversa?\n\n" 0 0
   	)

   		if [ reversa == 0 ]; then

   			#Particionando os IP
   			ip-a=$(echo "$ipdom" | cut -d. -f1)
   			ip-b=$(echo "$ipdom" | cut -d. -f2)
   			ip-c=$(echo "$ipdom" | cut -d. -f3)
   			f-dom=$(echo "$ipdom" | cut -d. -f4)
   			f-gw=$(echo "$ipgw" | cut -d. -f4)
   			
   			#Arquivo named.conf
   			echo "zone \"$ip-c.$ip-b.$ip-a.in-addr.arpa\" {
			type master;
			file \"/etc/bind/db.$ip-c.$ip-b.$ip-a\";
			};
			" >> /etc/bind/named.conf.local

			echo ";
			; BIND zone file for $ip-a.$ip-b.$ip-c.xxx
			;
			\$TTL    3H
			@       IN      SOA     @                  root.$domzd (
			                        01               ; serial
			                        8H               ; refresh
			                        2H               ; retry
			                        4W               ; expire
			                        1D )             ; minimum
			;
			@               NS      ns.$domzd     ; Nameserver address
			
			$f-dom             PTR     server.$domzd
			$f-dom             PTR     ns.$domzd
			$f-gw              PTR     router.$domzd
			;" >> /etc/bind/db.$ip-c.$ip-b.$ip-b

			named-checkzone $ip-c.$ip-b.$ip-b.in-addr.arpa

		fi
	;;

	Ativar)
	systemctl restart bind9
	;;

esac

done