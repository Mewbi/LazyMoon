#!/bin/bash
#Central de configuração de serviços

#---------------------CABECALHO----------------------------------------------|
#AUTOR
#	Felipe Fernandes <felipefernandesgsc@gmail.com>
#
#COAUTOR
#	Gabriel Viana <4463gabriel@gmail.com>
#
#PROGRAMA
#	Central de Configuração de Serviços
#
#DESCRICAO
#	Realiza a configuração de serviços de servidores Debian
#
#----------------------------------------------------------------------------|

#-------------------VARIAVEIS
nomeprogram="Central de Configurações"
vermelho="\033[1;31m"
branco="\033[1;37m"
ciano="\033[1:36m"
corpadrao="\033[0m"
#----------------------------

#---------------------FUNCOES
_HELP()
{
clear
cat <<END
${nomeprogram}

Opções
	-h, --help
	 Imprime este manual de ajuda
	 
	 -c, --conection
	 Realiza a verificação de conexão com a internet
	 
	 -m, --manual
	 Imprime o manual de funcionamento do script
END
}

_CONECTION() #Função que analisa a conexão com a internet
{
clear
ping www.google.com.br -c 1 >/dev/null;
   if [ "$?" = "0" ] ;
   then
      echo -e "$branco Conexão ativa! \nRedirecionando para a configurações de serviços"
	  sleep 3
   else
      clear
      echo -e "$branco Aparentemente você não possui conexão com a internet \nO que deseja fazer? \n"   
	  echo -e "0 - Sair do script \n\n1 - Prosseguir para a configuração de serviços \n\n\n"
	  read -p "Insira a opção desejada: " opconect
	  case $opconect in
	     0)		_DESPEDIDA
		 ;;
		 
		 1)
		 echo -e "\n\nRedirecionando para a configurações de serviços"
		 sleep 3 ;;

		 *)
		 echo "Opção Inválida"
		 _DESPEDIDA
		 ;;
	  esac
	fi
}

_DESPEDIDA() #Função ativada quando o usuário decide sair do programa
{
echo -e "$branco \n\n
Obrigado por usar o Script \n
$vermelho Criado por: $branco Felipe Fernandes & Gabriel Viana $corpadrao"
sleep 3
exit
}

_MENUWEB()
{
echo -e "$vermelho \t\tMenu WEB \n
$branco \t0 - Para sair do Script \n
\t1 - Configurar um site \n
\t2 - Desabilitar um site \n
\t3 - Instalar Apache \n
\t4 - Modificar index de site \n
\t5 - Criar página para site \n
\t6 - Habilitar um site \n\n"
}

_MENUDNS()
{
echo -e "$vermelho \t\tMenu DNS \n
$branco \t0 - Para sair do Script \n
\t1 - Instalar o Bind \n
\t2 - Configurar a Zona Direta \n
\t3 - Configurar a Zona Reversa \n
\t4 - Ativar (restartar) o Servidor \n\n"
}

_MENUDHCP()
{
echo -e "$vermelho \t\tMenu DHCP \n
$branco \t0 - Para sair do Script \n
\t1 - Instalar o DHCP \n
\t2 - Configurar o DHCP (escopo) \n
\t4 - Ativar DHCP \n\n"
}

_MENUVOIP()
{
echo -e "$vermelho \t\tMenu VOIP \n
$branco \t0 - Para sair do Script \n
\t1 - Instalar o Asterix \n
\t2 - Configurar Ramais \n\n"
}

_MENUFTP()
{
echo -e "$vermelho \t\tMenu FTP \n
$branco \t0 - Para sair do Script \n
\t1 - Instalar o vsFTPd \n
\t2 - Configurar vsFTPd \n
\t3 - Criar Novo Grupo \n
\t4 - Criar Novo Usuário \n
\t5 - Adicionar Usuário a um Grupo Existente \n\n"
}

#----------------------------

#---------------------INICIAL
case $1 in
	-h|--help)		_HELP
	exit	;;
	
	-c|--conection)	_CONECTION
	;;
	
	-m|--manual)	_MANUAL
	exit	;;
esac

clear

echo -e "$branco
Bem-vindo à central de configuração de serviços para o Debian
Para o funcionamento total deste script é necessário inicia-lo no modo super usuário \n\n\n
$vermelho \t\tMenu Inicial \n
$branco \t0 - Sair do Script \n
\t1 - Configurar Servidor WEB \n
\t2 - Configurar Servidor DNS \n
\t3 - Configurar Servidor DHCP \n
\t4 - Configurar Servidor VOIP \n
\t5 - Configurar Servidor FTP \n
\t100 - Sugestão de Melhoria \n\n"

read -p "Escolha qual opção quer executar: " func

case $func in

#Sair do Script
0)
clear
_DESPEDIDA
;;

#Servidor WEB
1)

clear

echo -e "\nEste script realiza a configuração automática do servidor WEB\n
Quando é configurado um site uma página padrão é criada, para altera-la basta mudar os html dentro do diretório onde se encontra os arquivos do site \n\n"
_MENUWEB

read -p "Digite o número referente a tarefa que você quer executar " tarefa
until [ $tarefa -eq 0 ]
do

if [ $tarefa -eq 1 ]
then
echo -e "\n$branco Qual será o nome do site?
(escreva o sufixo do site .net .com)"
read site
echo

#Confirmação das configurações
clear
echo -e "$vermelho \n \t Confirmação \n\n $branco
O nome do site será: $site \n
Você esta de acordo? $vermelho [s/n] $branco"
read confirmacaoweb

while [ $confirmacaoweb != s ]
do
clear
echo -e "$branco
Qual será o nome do site?
(escreva o sufixo do site .net .com)"
site= read site
clear
echo -e "$vermelho \n \t Confirmação \n\n $branco
O nome do site será: $site \n
Você esta de acordo? $vermelho [s/n] $branco" 
read confirmacaoweb
done


#Criando local para armazenamento do site
mkdir -p /var/www/$site/public_html
chown -R $USER:$USER /var/www/$site/public_html
chmod -R 755 /var/www

#Criando página HTML
echo "<!DOCTYPE html>
<html>
<html lang="pt-br">
	<head>
	<meta charset="utf-8" />
	<title>Página Padrão</title>
	</head>
		<body>
		<h2>Seja Bem-Vindo à Página Padrão</h2>
		<hr /></br>
		<a>Esta é uma página html padrão criada após a utilização do Script de configuração de servidor WEB</a></br>
		</br>
		<a>Qualquer sugestão de melhoria será bem-vinda</a></br>
		</br>
		<hr /></br>
		</br>
		</br>
		</br>
		<a>Lazy Moon</a>
		</br>
		</br>
		<a>Criado por: Felipe Fernandes & Gabriel Viana</a>
		</body>
</html>" > /var/www/$site/public_html/index.html

#Configurando o site
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$site.conf
echo "<VirtualHost *:80>
ServerAdmin admin@$site
ServerName $site
DocumentRoot /var/www/$site/public_html
ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/$site.conf
a2ensite $site.conf
a2dissite 000-default.conf
systemctl restart apache2

elif [ $tarefa -eq 2 ]
then
echo
read -p "Escreva o nome do site que queres desabilitar: " dessite
a2dissite $dessite.conf
systemctl restart apache2

elif [ $tarefa -eq 3 ]
then
apt-get install apache2 apache2-doc

elif [ $tarefa -eq 4 ]
then
echo
read -p "Escreva qual site que queres alterar o index: " alterarindex
nano /var/www/$alterarindex/public_html/index.html

elif [ $tarefa -eq 5 ]
then
echo
read -p "Escreva qual site que queres adicionar uma página " novapagina
read -p "Não se esqueça de renomear a página após a edição" inutil1
nano /var/www/$novapagina/public_html/NovaPagina.html

elif [ $tarefa -eq 6 ]
then
echo
read -p "Escreva o nome do site que queres habilitar: " habsite
a2ensite $habsite.conf
systemctl restart apache2

fi

clear

echo -e "\n"
_MENUWEB

tarefa= read -p "Digite o número referente a tarefa que quer executar " tarefa
done

_DESPEDIDA
;;

#Servidor DNS
2)

clear

echo -e "$branco
Este script realiza a configuração automática do servidor DNS\n
A configuração do Servidor DNS é realizada em duas etapas distintas, a configuração da zona direta e zona reversa é feita separadamente
Obs. NÃO é configurado automáticamente a zona reversa no arquivo named.conf.local, a mesma deve ser configurada manualmente \n\n"
_MENUDNS

read -p "Digite o número referente a tarefa que você quer executar " tarefa
until [ $tarefa -eq 0 ]
do

if [ $tarefa -eq 1 ]
then
apt-get install bind9

elif [ $tarefa -eq 2 ]
then
echo
#configuração de zonas
read -p "Digite qual será o nome do domínio: " domzonadireta
echo "" >> /etc/bind/named.conf.local
echo "zone \"$domzonadireta\" {" >> /etc/bind/named.conf.local
echo "type master;" >> /etc/bind/named.conf.local 
echo "file \"/etc/bind/db.$domzonadireta\";" >> /etc/bind/named.conf.local 
echo "};" >> /etc/bind/named.conf.local 
echo " " >> /etc/bind/named.conf.local

#converção de nome para ip
read -p "Escreva o IP do servidor WEB: " ipweb
read -p "Escreva o IP do servidor DNS: " ipdns
read -p "Escreva o IP do gateway: " ipgw
echo ";" >> /etc/bind/db.$domzonadireta
echo "; BIND zone file for $domzonadireta" >> /etc/bind/db.$domzonadireta
echo ";" >> /etc/bind/db.$domzonadireta
echo "\$TTL		3D" >> /etc/bind/db.$domzonadireta
echo "@			IN		SOA		$domzonadireta.		root.$domzonadireta. (" >> /etc/bind/db.$domzonadireta
echo "							01					; serial" >> /etc/bind/db.$domzonadireta
echo "							8H					; refresh" >> /etc/bind/db.$domzonadireta
echo "							2H					; retry" >> /etc/bind/db.$domzonadireta
echo "							4W					; expire" >> /etc/bind/db.$domzonadireta
echo "							1D )				; minimum" >> /etc/bind/db.$domzonadireta
echo ";" >> /etc/bind/db.$domzonadireta
echo "@			IN		NS		ns.$domzonadireta." >> /etc/bind/db.$domzonadireta
echo "ns				A		$ipweb" >> /etc/bind/db.$domzonadireta
echo "$domzonadireta.	A		$ipweb" >> /etc/bind/db.$domzonadireta
echo "server			A		$ipdns" >> /etc/bind/db.$domzonadireta
echo "router			A		$ipgw" >> /etc/bind/db.$domzonadireta
echo "www				CNAME	$domzonadireta." >> /etc/bind/db.$domzonadireta

#adicionar dominio no resolv.conf
echo "" >> /etc/resolv.conf
echo "domain $domzonadireta" >> /etc/resolv.conf
echo "search $domzonadireta" >> /etc/resolv.conf
echo "nameserver 127.0.0.1" >> /etc/resolv.conf
echo "" >> /etc/resolv.conf
named-checkconf

#zona reversa
elif [ $tarefa -eq 3 ]
then
echo "Considerando que o seu IP seja dividido em AAA.BBB.CCC.DDD"
read -p "Qual seria o digito AAA do servidor DNS?" A
read -p "Qual seria o digito BBB?" b
read -p "Qual seria o digito CCC?" c
read -p "Escreva o final do IP do servidor WEB: " Fweb
read -p "Escreva o final do IP do servidor DNS: " Fdns
read -p "Escreva o final do IP do gateway: " Fgw
echo "Criando..."
echo "zone \"$c.$b.$A.in-addr.arpa\" {" >> /etc/bind/named.conf.local
echo "type master;" >> /etc/bind/named.conf.local
echo "file \"/etc/bind/db.$c.$b.$A\";" >> /etc/bind/named.conf.local
echo "};" >> /etc/bind/named.conf.local
echo "" >> /etc/bind/named.conf.local

echo ";" >> /etc/bind/db.$c.$b.$A
echo "; BIND zone file for $A.$b.$c.xxx" >> /etc/bind/db.$c.$b.$A
echo ";" >> /etc/bind/db.$c.$b.$A
echo "\$TTL    3H" >> /etc/bind/db.$c.$b.$A
echo "@       IN      SOA     @                  root.$domzonadireta (" >> /etc/bind/db.$c.$b.$A
echo "                        01               ; serial" >> /etc/bind/db.$c.$b.$A
echo "                        8H               ; refresh" >> /etc/bind/db.$c.$b.$A
echo "                        2H               ; retry" >> /etc/bind/db.$c.$b.$A
echo "                        4W               ; expire" >> /etc/bind/db.$c.$b.$A
echo "                        1D )             ; minimum" >> /etc/bind/db.$c.$b.$A
echo ";" >> /etc/bind/db.$c.$b.$A
echo "@               NS      ns.$domzonadireta     ; Nameserver address" >> /etc/bind/db.$c.$b.$A
echo "" >> /etc/bind/db.$c.$b.$A
echo "$Fweb             PTR     server.$domzonadireta" >> /etc/bind/db.$c.$b.$A
echo "$Fweb             PTR     ns.$domzonadireta" >> /etc/bind/db.$c.$b.$A
echo "$Fgw               PTR     router.$domzonadireta" >> /etc/bind/db.$c.$b.$A
echo ";" >> /etc/bind/db.$c.$b.$A
echo "Verificando se existe erros no arquivo..."
sleep 1
named-checkzone $c.$b.$A.in-addr.arpa


elif [ $tarefa -eq 4 ]
then
systemctl restart bind9

fi

clear

echo -e "\n"
_MENUDNS

tarefa= read -p "Digite o número referente a tarefa que quer executar " tarefa
done

_DESPEDIDA
;;

#Servidor DHCP
3)
clear
echo -e "$branco
Este script realiza a configuração automática do servidor DHCP
Após feito a configuração do escopo é recomendado recomendado reiniciar o servidor para ativar as configurações \n"
_MENUDHCP

read -p "Digite o número referente a tarefa que você quer executar " tarefa
until [ $tarefa -eq 0 ]
do

if [ $tarefa -eq 1 ]
then 
apt-get install isc-dhcp-server

elif [ $tarefa -eq 2 ]
then

#DHCP
clear
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

INTERFACESv4-\"enp0s3\"
INTERFACESv6-\"\"" > /etc/default/isc-dhcp-server

#dhcp.conf
echo "Qual é o domínio da rede (nome do escopo)?"
read Dominio
echo "Qual o IP do server DNS?"
read ipDNS
echo "Qual o IP da rede?"
read ipREDE
echo "Qual a máscara da rede?"
read Mask
echo "Qual o primeiro IP do range?"
read R0
echo "Qual o último IP do range?"
read RF
echo "Qual o gateway da rede?"
read GW
echo "Qual o endereço de BroadCast?"
read broad

#Confirmação do DHCP
clear
echo -e "$vermelho \n \t Confirmação \n\n $branco
O nome do escopo (Domínio) deste DHCP é: $Dominio \n
O IP da rede é: $ipREDE \n
A máscara da rede é: $Mask \n
O gateway da rede é: $GW \n
O IP do servidor DNS é: $ipDNS \n
O range de atribuição de IP é: $R0 - $RF \n
O endereço de BroadCast é: $broad \n
Você esta de acordo com todas as informações acima? $vermelho [s/n] $branco"
read confirmacaodhcp

while [ $confirmacaodhcp != s ]
do
clear
echo "Qual é o domínio da rede (nome do escopo)?"
Dominio= read Dominio
echo "Qual o IP do server DNS?"
ipDNS= read ipDNS
echo "Qual o IP da rede?"
ipREDE= read ipREDE
echo "Qual a máscara da rede?"
Mask= read Mask
echo "Qual o primeiro IP do range?"
R0= read R0
echo "Qual o último IP do range?"
RF= read RF
echo "Qual o gateway da rede?"
GW= read GW
echo "Qual o endereço de BroadCast?"
broad= read broad
clear
echo -e "$vermelho \n \t Confirmação \n\n $branco
O nome do escopo (Domínio) deste DHCP é: $Dominio \n
O IP da rede é: $ipREDE \n
A máscara da rede é: $Mask \n
O gateway da rede é: $GW \n
O IP do servidor DNS é: $ipDNS \n
O range de atribuição de IP é: $RO - $RF \n
O endereço de BroadCast é: $broad \n
Você esta de acordo com todas as informações acima? $vermelho [s/n] $branco"
read confirmacaodhcp
done

#Configurando DHCP
echo "ddns-update-style none;
option domain-name \"$Dominio\";
option domain-name-servers $ipDNS;
default-lease-time 600;
max-lease-time 7200;
authoritative;
log-facility local7;
subnet $ipREDE netmask $Mask {
range $R0 $RF;
option routers $GW;
option broadcast-address $broad;
}" > /etc/dhcp/dhcpd.conf
 
elif [ $tarefa -eq 3 ]
then
systemctl restart isc-dhcp-server
 
fi

clear

echo -e "\n"
_MENUDHCP

tarefa= read -p "Digite o número referente a tarefa que quer executar " tarefa
done

_DESPEDIDA
;;

#Email para sugestão de melhoria
100)
clear
echo
echo "Agradecemos por nos enviar um email de sugestão de melhoria"
echo "Queremos saber a sua opinião"
echo
echo "É necessário ter instalado na máquina o programa 'Send Email' para poder enviar o email"
echo
echo "No momento só temos suporte de envio de email por Outlook. Desculpe o transtorno"
echo
echo
echo
echo "0 - Sair"
echo
echo "1 - Instalar 'Send Email'"
echo
echo "2 - Outlook"
echo

read -p "Digite a opção escolhida: " email

until [ $email -eq 0 ]
do

if [ $email -eq 1 ]
then
apt-get install sendemail

elif [ $email -eq 2 ]
then
read -p "Qual o seu email? " emailoutlook
read -p "Qual a senha deste email? " senhaoutlook
read -p "Qual o assunto do email? " assuntooutlook
read -p "Qual a mensagem do email? " textoutlook
sendemail -f $emailoutlook -t felipefernandesgsc@gmail.com -u "$assuntooutlook" -m "$textoutlook" -s smtp-mail.outlook.com:587 -xu $emailoutlook -xp $senhaoutlook

fi
clear
echo
echo "0 - Sair"
echo
echo "1 - Instalar 'Send Email'"
echo
echo "2 - Outlook"
echo
email= read -p "Digite a opção escolhida: " email
done

clear
echo
echo "Muito obrigado por enviar sua sugestão"
sleep 3
exit
;;

#Servidor VOIP
4)
clear
echo -e "\n"
_MENUVOIP

read -p "Digite o número referente a tarefa que você quer executar " tarefa
until [ $tarefa -eq 0 ]
do

if [ $tarefa -eq 1 ]
then 
clear

fi

clear
echo -e "\n"
_MENUVOIP

tarefa= read -p "Digite o número referente a tarefa que quer executar " tarefa
done

clear
_DESPEDIDA
;;

#Servidor FTP
5)
clear
cd /etc
echo -e "\n"
_MENUFTP

read -p "Digite o número referente a tarefa que você quer executar " tarefa
until [ $tarefa -eq 0 ]
do

if [ $tarefa -eq 1 ]
then
echo "Quer atualizar o sistema antes de fazer a instalação de todo serviço FTP? [s/n]"
	read att
	case $att in
		s)
		apt-get update
		apt-get upgrade
		apt-get install vsftpd
		apt-get install ftp
		cp –a /etc/vsftpd.conf /etc/ vsftpd.conf.backup
		;;
		
		n)
		apt-get install vsftpd
		apt-get install ftp
		cp –a /etc/vsftpd.conf /etc/ vsftpd.conf.backup
		;;
		
		*)
		apt-get install vsftpd
		apt-get install ftp
		cp –a /etc/vsftpd.conf /etc/ vsftpd.conf.backup
		;;
	esac
clear
fi

if [ $tarefa -eq 2 ]
then
clear
echo -e "Qual será a mensagem de inicialização do serviço?"
read msgin
echo -e "Usuário 'anonymous' estará disponível? [YES/NO]"
read anonymous
echo -e "Qual será o diretório padrão ao iniciar o serviço FTP? (recomenda-se /home/ftp)"
read dirftp

#Confirmação do FTP
clear
echo -e "$vermelho \n \t Confirmação \n\n $branco
A mensagem de inicialização será: $msgin \n
O usuário anonymous estará disponível?: $anonymous \n
O diretório padrão ao iniciar o serviço será: $dirftp \n
Você esta de acordo com todas as informações acima? $vermelho [s/n] $branco"
read confirmacaoftp

while [ $confirmacaoftp != s ]
do
clear
echo -e "Qual será a mensagem de inicialização do serviço?"
msgin= read msgin
echo -e "Usuário 'anonymous' estará disponível? [YES/NO]"
anonymous= read anonymous
echo -e "Qual será o diretório padrão ao iniciar o serviço FTP? (recomenda-se /home/ftp)"
dirftp= read dirftp
clear
echo -e "$vermelho \n \t Confirmação \n\n $branco
A mensagem de inicialização será: $msgin \n
O usuário anonymous estará disponível?: $anonymous \n
O diretório padrão ao iniciar o serviço será: $dirftp \n
Você está de acordo com todas as informações acima? $vermelho [s/n] $branco"
read confirmacaoftp
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
ftpd_banner=$msgin
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO
anon_root=$dirftp" > vsftpd.conf

mkdir $dirftp
chmod 555 $dirftp
chown ftp.ftp $dirftp

#Iniciando FTP
systemctl restart vsftpd
fi

if [ $tarefa -eq 3 ]
then
clear
echo "Qual será o nome do grupo?"
read nomegp
echo "Qual será o número do grupo?"
read numgp

#Confirmação Grupo
clear
echo -e "$vermelho \n \t Confirmação \n\n $branco
O nome do grupo será: $nomegp \n
O número do grupo será: $numgp \n
Você está de acordo com todas as informações acima? $vermelho [s/n] $branco"
read confirmacaogp

while [ $confirmacaogp != s ]
do
clear
echo "Qual será o nome do grupo?"
nomegp= read nomegp
echo "Qual será o número do grupo?"
numgp= read numgp
clear
echo -e "$vermelho \n \t Confirmação \n\n $branco
O nome do grupo será: $nomegp \n
O número do grupo será: $numgp \n
Você está de acordo com todas as informações acima? $vermelho [s/n] $branco"
read confirmacaogp
done

#Criando Grupo
groupadd $nomegp -g $numgp
fi

if [ $tarefa -eq 4 ]
then
clear
echo "Qual será o login do usuário?"
read lgusu
echo "Qual será o nome do usuário?"
read nomeusu

#Confirmação Usuário
clear
echo -e "$vermelho \n \t Confirmação \n\n $branco
O login do usuário será: $lgusu \n
O nome do usuário será: $nomeusu \n
Você está de acordo com todas as informações acima? $vermelho [s/n] $branco"
read confirmacaousu

while [ $confirmacaousu != s ]
do
clear
echo "Qual será o login do usuário?"
lgusu= read lgusu
echo "Qual será o nome do usuário?"
nomeusu= read nomeusu
clear
echo -e "$vermelho \n \t Confirmação \n\n $branco
O login do usuário será: $lgusu \n
O nome do usuário será: $nomeusu \n
Você está de acordo com todas as informações acima? $vermelho [s/n] $branco"
read confirmacaousu
done

#Criando Usuário
adduser -c "$nomeusu" $lgusu
fi

if [ $tarefa -eq 5 ]
then
clear
echo "Qual será o login do usuário (existente)?"
read logexist
echo "Qual será o grupo (existente)?"
read gpexist

#Confirmação Inserção de usuário a grupo
clear
echo -e "$vermelho \n \t Confirmação \n\n $branco
O login escolhido foi: $logexist \n
O grupo escolhido foi: $gpexist \n
Você está de acordo com todas as informações acima? $vermelho [s/n] $branco"
read confirmacaoinsercao

while [ $confirmacaoinsercao != s ]
do
clear
echo "Qual será o login do usuário (existente)?"
logexist= read logexist
echo "Qual será o grupo (existente)?"
gpexist= read gpexist
clear
echo -e "$vermelho \n \t Confirmação \n\n $branco
O login escolhido foi: $logexist \n
O grupo escolhido foi: $gpexist \n
Você está de acordo com todas as informações acima? $vermelho [s/n] $branco"
read confirmacaoinsercao
done

#Fazendo inserção
gpasswd -a $logexist $gpexist
fi

clear
echo -e "\n"
_MENUFTP

tarefa= read -p "Digite o número referente a tarefa que quer executar " tarefa
done
_DESPEDIDA
;;

*)
echo "Função escolhida inválida"
exit
;;

esac
#----------------------------
