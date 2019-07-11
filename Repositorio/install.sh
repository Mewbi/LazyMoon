#!/usr/bin/env bash

#---------------Instalador Cliente--------------#
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
#   cliente.
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
	read -p "Digite o usuário que será realizado a instalação deste serviço: " usr
	check=$(cut -d: -f 1 /etc/passwd | grep -o "$usr")
	if [ ! -n "${check}" ]; then
		echo -e "\nUsuário não registrado no sistema...\n"
		continue
	else
		break
	fi
done
#------------------------------------------------

#------------------Criando arquivos de instalação
if [ ! -d /home/${usr}/LM-relatorio ]; then
	mkdir /home/${usr}/LM-relatorio || { echo -e "\nNão foi possível criar diretório para instalação" ; exit ;}
fi

if [ ! -e /home/${usr}/LM-relatorio/config.txt ]; then
	touch /home/${usr}/LM-relatorio/config.txt || { echo -e "\nNão foi possível criar arquivo de configuração" ; exit ;}
	read -p "Digite o nome ou função deste server (ex. Câmeras): " name
	read -p "Digite o usuário de envio dos relatórios: " username
	read -p "Digite o IP de envio dos relatórios: " ip
	read -p "Digite o diretório para envio dos relatórios (Recomenda-se: /home/${username}/Lazymoon/Relatorios/${name}): " dir
	cat > /home/${usr}/LM-relatorio/config.txt << END
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

echo -e "\nArquivo de configuração criado em /home/${usr}/LM-relatorio/config.txt"
read -p "Pressione ENTER para prosseguir"
#------------------------------------------------

#------------------------Checagem de Dependências
# cron, scp, top, uname, uptime, df
if [ ! -n "$(type -P cron )" ]; then
	echo -e "\nCron - [\033[1;31mNão Instalado\033[0m]"
else
	echo -e "\nCron - [\033[1;32mInstalado\033[0m]"
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

#-------------Configuração de Envio de Relatórios
if [ -n "$(type -P ssh)"]; then

	echo -e "\n\tConfiguração de Envio de Relatórios
É necessário gerar uma chave de autenticação, para os envios ocorrerem automaticamente.
Será gerado uma chave RSA e será feito algumas perguntas de configuração.
\nDigite '/home/${usr}/.ssh/id_rsa
Para senha e confirmação de senha apenas aperte ENTER\n"

	ssh-keygen -t rsa

	echo -e "\nEnviando chave para ${username}, será necessário digitar a senha deste usuário\n"
	cat /home/{usr}/.ssh/id_rsa.pub | ssh ${username}@${ip} "cat - >> /home/${username}/.ssh/authorized_keys"

	echo -e "\nCriando diretório para armazenamento de relatórios na máquina que receberá os relatórios (será necessário digitar a senha de ${username} novamente)."
	ssh {username}@{ip} "mkdir ${dir}"

	cat << END

	Configuração Finais para envio de Relatórios

É necessário editar (como root) o arquivo:
		/etc/ssh/ssh_config

Basta procurar as seguintes linhas e descomenta-las:
END

	echo -e "\033[1;37;40m
IdentityFile ~/.ssh/identity
IdentityFile ~/.ssh/id_rsa
IdentityFile ~/.ssh/id_dsa 
\033[0m

Feito isso o programa estará apto para enviar relatórios automaticamente."
fi
#------------------------------------------------

#----------------Preparação de ativação periódica
chmod +x relatorio.sh
mv relatorio.sh /usr/bin/relatorio.sh
echo "00-59/10 * * * * ${usr} bash /usr/bin/relatorio.sh" >> /etc/crontab
#------------------------------------------------