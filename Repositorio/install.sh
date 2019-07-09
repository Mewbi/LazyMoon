#!/usr/bin/env bash

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

#------------------Criando arquivos de instalação
if [ ! -d /home/${user}/LM-relatorio ]; then
	mkdir /home/${user}/LM-relatorio || { echo -e "\nNão foi possível criar diretório para instalação" ; exit ;}
fi

if [ ! -e /home/${user}/LM-relatorio/config.txt ]; then
	touch /home/${user}/LM-relatorio/config.txt || { echo -e "\nNão foi possível criar arquivo de configuração" ; exit ;}
	read -p "Digite o nome ou função deste server (ex. Câmeras): " name
	read -p "Digite o usuário de envio dos relatórios: " username
	read -p "Digite o IP de envio dos relatórios: " ip
	read -p "Digite o diretório para envio dos relatórios: " dir
	cat > /home/${user}/LM-relatorio/config.txt << END
### Arquivo de Configuração ###
#                             #
# As variáveis podem ser modi-#
# ficadas conforme necessidade#
#                             #
# As variáveis contém informa-#
# ções para  envio, altere-as #
# com cuidado                 #
###############################

serverName="${name}"
user="${username}"
ip="${ip}"
dir="${dir}"
END
fi

echo -e "\nArquivo de configuração criado em /home/${user}/LM-relatorio/config.txt"
read -p "Pressione ENTER para prosseguir"
#------------------------------------------------

#------------------------Checagem de Dependências
# cron, scp, top, uname, uptime, df
if [ ! -n "$(type -P cron )" ]; then
	echo -e "Cron - [\033[1;31mNão Instalado\033[0m]"
else
	echo -e "Cron - [\033[1;32mInstalado\033[0m]"
fi

if [ ! -n "$(type -P scp )" ]; then
	echo -e "SCP - [\033[1;31mNão Instalado\033[0m]"
else
	echo -e "SCP - [\033[1;32mInstalado\033[0m]"
fi

if [ ! -n "$(type -P top )" ]; then
	echo -e "Top - [\033[1;31mNão Instalado\033[0m]"
else
	echo -e "Top - [\033[1;32mInstalado\033[0m]"
fi

if [ ! -n "$(type -P uname )" ]; then
	echo -e "Uname - [\033[1;31mNão Instalado\033[0m]"
else
	echo -e "Uname - [\033[1;32mInstalado\033[0m]"
fi

if [ ! -n "$(type -P uptime )" ]; then
	echo -e "Uptime - [\033[1;31mNão Instalado\033[0m]"
else
	echo -e "Uptime - [\033[1;32mInstalado\033[0m]"
fi

if [ ! -n "$(type -P df )" ]; then
	echo -e "DF - [\033[1;31mNão Instalado\033[0m]"
else
	echo -e "DF - [\033[1;32mInstalado\033[0m]"
fi

echo -e "\nCaso algum programa não esteja instalado, instale-o para total funcionamento da geração de relatórios"
read -p "Pressione ENTER para prosseguir"
#------------------------------------------------

#----------------Preparação de ativação periódica
#chmod +x relatorio.sh
#mv relatorio.sh /usr/bin/relatorio.sh
#echo "00-59/10 * * * * ${user} bash /usr/bin/relatorio.sh" >> /etc/crontab
#------------------------------------------------