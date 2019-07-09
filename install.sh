#!/usr/bin/env bash

#---------------Instalador Monitor--------------#
#
#  AUTOR
#     Felipe Fernandes
#		<felipefernandesgsc@gmail.com>
#
#  PROGRAMA
#	  install.sh
#
#  DATA DE CRIAÇÃO
#     09/07/2019
#
#  DESCRIÇÃO
#	  Realiza a instação do programa na máquina
#   monitor.
#-----------------------------------------------#

#---------------Verificando Permissão de Execução
cat << END

	Instalador

IMPORTANTE: Este instalador necessita ser executado como Root ou com permissões de super usuário (sudo) !

O instalador está sendo executado em um destes modos? [s/n]
END
read exec ; exec="${exec,,}"
if [ "$exec" != "s" ]; then
	echo -e "\nExecute novamente o programa como Root ou com utilizando sudo!"
	exit 1
fi
#------------------------------------------------

#-----Selecionando em qual usuário será instalado
while : ; do
	read -p "Digite o usuário que será realizado a instalação deste serviço: " user
	check=$(cut -d: -f 1 /etc/passwd | grep -o "$user")
	if [ ! -n "${check}" ]; then
		echo -e "\nUsuário não registrado no sistema...\n"
		continue
	else
		break
	fi
done
#------------------------------------------------

#--------Criando e movendo arquivos de instalação
#Criando diretórios

if [ ! -d /home/${user}/LazyMoon ]; then
	mkdir /home/${user}/LazyMoon || { echo -e "\nNão foi possível criar diretório para instalação" ; exit ;}
	mkdir /home/${user}/LazyMoon/Biblioteca
	mkdir /home/${user}/LazyMoon/Biblioteca/Redes
fi

#Dando permissão de execução aos programas
chmod +x LM-Login/LM-Login
chmod +x LM-Management/LM-Management
chmod +x LM-MRI/LM-MRI
chmod +x LM-SSHost/LM-SSHost
chmod +x LM-NetChat/LM-NetChat
chmod +x LM-CService/LM-CService

#Movendo logins
mv banco-logins.txt /home/${user}/LazyMoon/Biblioteca/

#Movendo programas e diretórios
mv Relatorios /home/${user}/LazyMoon
mv Repositorio /home/${user}/LazyMoon/Biblioteca
mv LM-Login /home/${user}/LazyMoon
mv LM-Management /home/${user}/LazyMoon
mv LM-MRI /home/${user}/LazyMoon
mv LM-SSHost /home/${user}/LazyMoon
mv LM-NetChat /home/${user}/LazyMoon
mv LM-CService /home/${user}/LazyMoon
mv README.md /home/${user}/LazyMoon

#cp /home/${user}/LazyMoon/LM-Login/LM-Login /usr/bin/LM-Login && \
#{ echo -e "\nCriado atalho de execução do programa chamado 'LM-Login'"; read -p "Pressione ENTER para prosseguir" ;}
#------------------------------------------------

#------------------------Checagem de Dependências
# cron, ssh, dialog, ping, nc
# checar arquivo sshd_config para ver se tem o openssh-server

if [ ! -n "$(type -P cron )" ]; then
	echo -e "\nCron - [\033[1;31mNão Instalado\033[0m]"
else
	echo -e "\nCron - [\033[1;32mInstalado\033[0m]"
fi

if [ ! -n "$(type -P ssh )" ]; then
	echo -e "SSH - [\033[1;31mNão Instalado\033[0m]"
else
	echo -e "SSH - [\033[1;32mInstalado\033[0m]"
fi

if [ ! -e /etc/ssh/sshd_config ]; then
	echo -e "OpenSSH-Server - [\033[1;31mNão Instalado\033[0m]"
else
	echo -e "OpenSSH-Server - [\033[1;32mInstalado\033[0m]"
fi

if [ ! -n "$(type -P dialog )" ]; then
	echo -e "Dialog - [\033[1;31mNão Instalado\033[0m]"
else
	echo -e "Dialog - [\033[1;32mInstalado\033[0m]"
fi

if [ ! -n "$(type -P ping )" ]; then
	echo -e "Ping - [\033[1;31mNão Instalado\033[0m]"
else
	echo -e "Ping - [\033[1;32mInstalado\033[0m]"
fi

if [ ! -n "$(type -P nc )" ]; then
	echo -e "Netcat - [\033[1;31mNão Instalado\033[0m]"
else
	echo -e "Netcat - [\033[1;32mInstalado\033[0m]"
fi

echo -e "\nCaso algum programa não esteja instalado, instale-o para total funcionamento da geração de relatórios"
read -p "Pressione ENTER para prosseguir"
#------------------------------------------------