#!/usr/bin/env bash

#=============================CABEÇALHO======================================|
#
#  AUTOR
#     Felipe Fernandes <felipefernandesgsc@gmail.com>
#
#  PROGRAMA
#	  LM-MRI
#
#  DATA DE CRIAÇÃO
#     15/02/2019
#
#  DESCRIÇÃO
#	  Realiza o monitoramento de equipamentos da rede por meio do comando ping
#
#  FUNCIONAMENTO
#	  É feito o teste (com ping) nos equipamentos registrados no arquivo de
#   registros, com base no retorno do comando será apresentado ao usuário se
#   há ou não conexão com tal dispotivo(s) testado(s).
#
#============================================================================|

#=======================================VARIAVEIS
usr="$1"
path="/home/${usr}/LazyMoon"
source ${path}/LM-MRI/config.txt 2> /dev/null || cor=""
#================================================

#==========================================TESTES
#Teste existencia pasta registro
if [ ! -d ${path}/Biblioteca/Redes ]
	then
	echo -e "Diretório de registro não encontrado... \nCriando diretório..."
	mkdir ${path}/Biblioteca/Redes || echo "Não foi possível criar o diretório"
	sleep 3
fi

#Teste se as cores estão configuradas
if [ ! -n "$cor" ]
	then
	echo -e "Cores não configuradas. Deseja habilitar? [s/n]"
	read ativarcores
	ativarcores="${ativarcores,,}"
		if [ "$ativarcores" = "s" ]
			then
			echo "cor=\"1\"" > ${path}/LM-MRI/config.txt && echo "Cores habilitadas"
			source ${path}/LM-MRI/config.txt
			else
			echo "cor=\"0\"" > ${path}/LM-MRI/config.txt && echo "Cores desabilitadas"
			source ${path}/LM-MRI/config.txt
		fi
	echo -e "\nAs configurações podem ser alteradas no arquivo '${path}/LM-MRI/config.txt'"
	sleep 3
fi

#Ativando cores
if [ "$cor" = "1" ]
	then
	verde="\033[1;32m"
	vermelho="\033[1;31m"
	ciano="\033[1;36m"
	corpadrao="\033[0m"
fi
#================================================

#=========================================FUNÇÕES
_LOGO()
{
clear
cat << END
╔╦╗╔═╗╔╗╔  ╦  ╔═╗╔╗╔	|			|	   Digite:
║║║║ ║║║║  ║  ╠═╣║║║	|	Bem-Vindo	|	-h ou --help 
╩ ╩╚═╝╝╚╝  ╩═╝╩ ╩╝╚╝	|			|   para acessar as opções
=============================================================================
END
}
_HELP()
{
less << END

	Opções

 -h|--help)
	Imprime este menu de opções.

 -r|--registrar)
 	Registra um dispositivo.
  
 -d|--deletar)
 	Deleta um dispositvo do registro.
	
 -c|--checar)
	Imprime na tela os dispositivos registrados.

 -m|--monitorar)
 	Inicia o monitoramento dos dispositivos registrados.
	
 -rr|--registrar-rede)
 	Registra uma rede.

 -cr|--checar-rede)
 	Imprime na tela as redes registradas.

 -mr|--monitorar-rede)
 	Inicia o monitoramentos da rede selecionada.

 -dr|--deletar-rede)
 	Deleta uma rede do registro de redes.

 -s|--sair)
	Sai do programa.

END
}
#================================================

#=========================================INICIAL
  _LOGO
   read tarefa

      until [ $tarefa = "--sair" ] 2> /dev/null || [ $tarefa = "-s" ] 2> /dev/null ; do
	  
	  	case $tarefa in
		
		  -h|--help)
		  _HELP ;;
		  
		  -r|--registrar) #Realiza o registro dos dispositivos
		    _LOGO
			echo -e "${ciano}Registro${corpadrao}"
		    until [ "$confirmacao" = "s" ] ; do		#Confirmar as informações
			  echo
		  	  read -p "Digite o nome do dispositivo que será registrado: " nome
			  nome=$(echo $nome | tr -t \  _) #Substitui os espaços por _
		      read -p "Digite o IP do dispositivo que será registrado: " ip		 
			  echo -e "\n${vermelho}Confirmação${corpadrao} \nO nome será ${ciano}${nome}${corpadrao} e o IP será ${ciano}${ip}${corpadrao}\n"
			  echo "As informações estão corretas? [s/n]"
			  read confirmacao	  
			done
			echo "nome:${nome}:IP:${ip}" >> ${path}/Biblioteca/Redes/registro.txt && echo -e "\nRegistro realizado com sucesso. Digite a próxima tarefa: \n"
			confirmacao=""
		  ;;

		  -c|--checar)
		  _LOGO
		  tabela=`cut -d: -f 2,4 ${path}/Biblioteca/Redes/registro.txt | tr -t : \  | column -t`
		  echo -e "${vermelho}\nDispositivos ${ciano}IPs${corpadrao} \n\n${tabela}" | column -t && echo -e "\nChecagem realizada. Digite a próxima tarefa: \n"
		  ;;
		  
		  -m|--monitorar)
		  while : #Entra em um loop que faz o teste completo infinitas vezes
		  do
		  echo -e "${ciano}Monitorando${corpadrao}" > ${path}/Biblioteca/Redes/cache.txt #Esvazia o cache. Pode ser usado um rm também
		  linhas=$(wc -l ${path}/Biblioteca/Redes/registro.txt | cut -d\  -f 1) #Retira quantas linhas tem o arquivo de registro
		  loop="1"
			until [ "$loop" -gt "$linhas" ]
			  do
			  #Retira apenas o nome do dispositivo e seu IP para fazer o teste
			  nome_dispositivo=$(cat ${path}/Biblioteca/Redes/registro.txt | grep -n ^| grep ^${loop}: | cut -d: -f 3)
			  ip_dispositivo=$(cat ${path}/Biblioteca/Redes/registro.txt | grep -n ^| grep ^${loop}: | cut -d: -f 5)
			  #Realiza o teste de conexão e coloca o resultado no cache
			  ping -c 1 -W 1 ${ip_dispositivo} 1> /dev/null 2> /dev/null && \
			  echo -e "Dispositivo:${ciano}${nome_dispositivo}${corpadrao} Status:${verde}Conectado${corpadrao}" \
			  >> ${path}/Biblioteca/Redes/cache.txt || \
			  echo -e "Dispositivo:${ciano}${nome_dispositivo}${corpadrao} Status:${vermelho}Sem-Conexão${corpadrao}" \
			  >> ${path}/Biblioteca/Redes/cache.txt
			  #Imprime na tela as informações do cache
			  _LOGO ; cat ${path}/Biblioteca/Redes/cache.txt | column -t
			  eval "loop=\$((loop + 1))"
			  done
		  echo -e "\nReiniciando Testes..."
		  sleep 5
		  done
		  ;;
		  
		  -rr|--registrar-rede) #Realiza o registro dos dispositivos
		    _LOGO
			echo -e "${ciano}Registro${corpadrao}"
		    until [ "$confirmacao" = "s" ] ; do		#Confirmar as informações
			  echo
		  	  read -p "Digite o nome da rede que será registrada: " nome_rede
			  nome_rede=$(echo $nome_rede | tr -t \  _) #Substituir espaços por _
		      read -p "Digite o IP inicial da rede: " ip_inicial
			  read -p "Digite o IP final da rede: " ip_final
			  echo -e "\n${vermelho}Confirmação${corpadrao} \nO nome será ${ciano}${nome_rede}${corpadrao} \nIP inicial: ${ciano}${ip_inicial}${corpadrao} - IP final: ${ciano}${ip_final}${corpadrao} \n"
			  echo "As informações estão corretas? [s/n]"
			  read confirmacao	  
			done
			echo "nome-rede:${nome_rede}:IP-inicial:${ip_inicial}:IP-final:${ip_final}" >> ${path}/Biblioteca/Redes/registro-rede.txt && echo -e "\nRegistro realizado com sucesso. Digite a próxima tarefa: \n"
			confirmacao=""
		  ;;
		  
		  -cr|--checar-rede)
		  _LOGO
		  tabela=`cut -d: -f 2,4,6 ${path}/Biblioteca/Redes/registro-rede.txt | tr -t : \  | column -t`
		  echo -e "${vermelho}\nRede ${ciano}IP-Inicial IP-Final${corpadrao} \n${tabela}" | column -t && echo -e "\nChecagem realizada. Digite a próxima tarefa: \n"
		  ;;

		  -mr|--monitorar-rede)
		    #Selecionando a rede que será monitorada
		    tabela=`cut -d: -f 2,4,6 ${path}/Biblioteca/Redes/registro-rede.txt | tr -t : \  | column -t | cat -n`
		    echo -e "${vermelho}\nNº Rede ${ciano}IP-Inicial IP-Final${corpadrao} \n${tabela}\n" | column -et
		    read -p "Escolha a rede que será monitorada: " rede_monitorada
			
			#Questionando a omição de falhas em conexão
			echo -e "\nDeseja omitir IPs sem conexão? [s/n]"
			read deseja_omitir
			
				#Omitindo falhas de conexão
				if [ "$deseja_omitir" = "s" ] || [ "$deseja_omitir" = "S" ]
					then
					omitir="#"
				fi
			
			  ipinicial=$(cat ${path}/Biblioteca/Redes/registro-rede.txt | grep -n ^| grep ^${rede_monitorada} | cut -d: -f 5)
			  ipfinal=$(cat ${path}/Biblioteca/Redes/registro-rede.txt | grep -n ^| grep ^${rede_monitorada} | cut -d: -f 7)
		  	  ipatual=$ipinicial

			  #separa cada parte do ip
			  part1=$(echo "$ipatual" | cut -d. -f 1)
			  part2=$(echo "$ipatual" | cut -d. -f 2)
			  part3=$(echo "$ipatual" | cut -d. -f 3)
			  part4=$(echo "$ipatual" | cut -d. -f 4)

			  #teste para verificar se as redes são diferentes
			  part1_teste=$(echo "$ipfinal" | cut -d. -f 1)
				if [ "$part1" != "$part1_teste" ]
				  then
				  echo -e "Não foi possível realizar o monitoramento. \nA rede do 'IP inicial' tem que ser a mesma do 'IP final' \nIP inicial: $ipinicial IP final: $ipfinal"
				  exit 2
			    fi
			  
			  while : #Entra em um loop que faz o teste completo infinitas vezes
		  	  do
		        echo -e "${ciano}Monitorando${corpadrao}" > ${path}/Biblioteca/Redes/cache-rede.txt #Esvazia o cache do monitoramento de rede.
				 
				 until [ "$ipatual" = "$ipfinal" ] ; do #entra no loop

  				   #atualiza o valor do ip atual
   				   ipatual=$(echo "${part1}.${part2}.${part3}.${part4}")

   					#separa cada parte do ip
  					part1=$(echo "$ipatual" | cut -d. -f 1)
   					part2=$(echo "$ipatual" | cut -d. -f 2)
   					part3=$(echo "$ipatual" | cut -d. -f 3)
   					part4=$(echo "$ipatual" | cut -d. -f 4)

   					#realiza o teste de conexão
   					ping -c 1 -W 1 ${ipatual} 1> /dev/null 2> /dev/null && \
			  		echo -e "IP:${ciano}${ipatual}${corpadrao} Status:${verde}Conectado${corpadrao}" \
			  		>> ${path}/Biblioteca/Redes/cache-rede.txt || \
			  		${omitir}echo -e "IP:${ciano}${ipatual}${corpadrao} Status:${vermelho}Sem-Conexão${corpadrao}" \
			  	    >> ${path}/Biblioteca/Redes/cache-rede.txt
			  		#Imprime na tela as informações do cache
			  		_LOGO ; cat ${path}/Biblioteca/Redes/cache-rede.txt | column -t

   					#aumenta o ip
   					eval "part4=\$((part4 + 1))"

					#aumenta o numero do outro octeto
					if [ "$part4" = 255 ]
					  then
					  part4=$(echo "1")
					  eval "part3=\$((part3 + 1))"
					fi

					if [ "$part3" = 256 ]
					  then
					  part3=$(echo "1")
					  eval "part2=\$((part2 + 1))"
					fi

				done
				echo -e "\nReiniciando Testes..."
		 		sleep 5
			  done
		  ;;
		  
		  *)
		  echo -e "\nOpção inválida. Digite -h ou --help para ver as opções válidas.\n"
		  ;;
		  
	  	esac
	  
	  read tarefa
	  done
#================================================
