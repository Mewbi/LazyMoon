#!/bin/bash

#=============================CABEÇALHO======================================|
#
#  AUTOR
#     Felipe Fernandes <felipefernandesgsc@gmail.com>
#
#  PROGRAMA
#	  CS-DHCP
#
#  DATA DE CRIAÇÃO
#     06/10/2019
#
#  DESCRIÇÃO
#	  Realiza a configuração do serviço DHCP.
#
#============================================================================|

while : ; do
opcao=$(dialog \
	--stdout \
	--menu 'Selecione uma Opção' \
	0 0 0 \
	Instalar 'Isc-DHCP-Server' \
	Configurar 'Configura DHCP (Escopo)' \
	Ativar 'Ativa o serviço DHCP' \
	Desativar 'Desativa o serviço DHCP' \
	Sair 'Sair do Programa' \
)


case $opcao in
	Sair)
	exit
	;;

	Instalar)
	apt-get install isc-dhcp-server
	;;

	Configurar)
	conf="1"
	while [[ "$conf" != "0" ]] ; do
		dialog --stdout \
		--title 'Interfaces' \
		--msgbox "Anote qual interface será usada (geralmente algo parecido com 'enp0s3'): \n\n$(ip addr)" 0 0

		interface=$(dialog --stdout \
			--title 'Interface' \
			--inputbox "Digite o nome da interface:" 0 0)

		dominio=$(dialog --stdout \
			--title 'Domínio' \
			--inputbox "Digite o domínio da rede (nome do escopo):" 0 0)

		ipRede=$(dialog --stdout \
			--title 'IP da Rede' \
			--inputbox "Digite o IP da rede:" 0 0)

		mascara=$(dialog --stdout \
			--title 'Máscara da Rede' \
			--inputbox "Digite a máscara da rede:" 0 0)

		gateway=$(dialog --stdout \
			--title 'Gateway da Rede' \
			--inputbox "Digite o gateway da rede:" 0 0)

		broadcast=$(dialog --stdout \
			--title 'Broadcast' \
			--inputbox "Digite endereço de broadcast da rede:" 0 0)

		rInicial=$(dialog --stdout \
			--title 'Início do Range' \
			--inputbox "Digite o primeiro IP da faixa de atribuição de IPs:" 0 0)

		rFinal=$(dialog --stdout \
			--title 'Final do Range' \
			--inputbox "Digite o último IP da faixa de atribuição de IPs:" 0 0)

		ipDNS=$(dialog --stdout \
			--title 'IP do DNS' \
			--inputbox "Digite o IP do servidor DNS:" 0 0)

		dialog --stdout \
		--title 'Confirmação' \
		--yesno "As seguintes informações estão corretas?\n\n
	Interface = ${interface} \n
	Domínio = ${dominio} \n
	Rede = ${ipRede} \n
	Máscara = ${mascara} \n
	Gateway = ${gateway} \n
	Broadcast = ${broadcast} \n
	Início do Range = ${rInicial} \n
	Final do Range = ${rFinal} \n
	DNS = ${ipDNS}" \
	0 0
		conf="$?"
	done

	#Configurando DHCP
		echo "# Defaults for isc-dhcp-server (sourced by /etc/init.d/ isc-dhcp-server)
#Path to dhcpd‘s config file (default: /etc/dhcp/dhcpd.conf).
#DHCPDv4_CONF=/ etc/dhcp/dhcpd.conf #DHCPDv6_CONF=/ etc/dhcp/dhcpd6.conf
 
#Path to dhcpd‘s PID file (default: /etc/dhcp/dhcpd.pid).
#DHCPDv4_PID=/ etc/dhcp/dhcpd.pid
#DHCPDv6_PID=/ etc/dhcp/dhcpd6.pid
 
# Additional options to start dhcpd with.
# Don’t use options –cf or –pf here. Use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=”” 
 
# On what interfaces should the DHCP server (dhcpd) server DHCP requests?
#   Separate multiple interfaces with spaces, e.g. “eth0 eth1”. 

INTERFACESv4-\"${interface}\"
INTERFACESv6-\"\"" > /etc/default/isc-dhcp-server

		echo "ddns-update-style none;
option domain-name \"$dominio\";
option domain-name-servers $ipDNS;
default-lease-time 600;
max-lease-time 7200;
authoritative;
log-facility local7;
subnet $ipRede netmask $mascara {
range $rInicial $rFinal;
option routers $gateway;
option broadcast-address $broadcast;
}" > /etc/dhcp/dhcpd.conf

	dialog --stdout \
	--title 'Aviso' \
	--msgbox "O novo escopo não está ativado, para ativar utilize a opção \'Ativar\'" 0 0
	;;

	Ativar)
	systemctl restart isc-dhcp-server && dialog --stdout --title "Sucesso systemctl" --msgbox "Sucesso em iniciar serviço!" 5 40 \
	|| dialog --stdout --title "Erro systemctl" --msgbox "Falha em iniciar serviço!" 5 40
	;;

	Desativar)
	systemctl stop isc-dhcp-server && dialog --stdout --title "Sucesso systemctl" --msgbox "Sucesso em desativar serviço!" 5 40 \
	|| dialog --stdout --title "Erro systemctl" --msgbox "Falha em desativar serviço!" 5 40
	;;

esac


done