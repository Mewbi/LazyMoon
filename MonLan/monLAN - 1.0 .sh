
#!/usr/bin/env bash

#=============================CABEÇALHO======================================|
#
#  AUTORES
#     Felipe Fernandes <felipefernandesgsc@gmail.com>
#     Gabriel Viana <4463gabriel@gmail.com>
#
#  PROGRAMA
#     MonLAN
#     Monitor-LAN
#
#  DATA DE CRIAÇÃO
#     15/02/2019
#
#  DESCRIÇÃO
#     Realiza o monitoramento de equipamentos da rede por meio do comando ping
#
#  FUNCIONAMENTO
#     É feito o teste (com ping) nos equipamentos registrados no arquivo de
#   registros, com base no retorno do comando será apresentado ao usuário se
#   há ou não conexão com tal dispotivo(s) testado(s).
#
#  CHANGELOG
#
#============================================================================|

#=======================================VARIAVEIS
source /$HOME/.monLAN/config 2> /dev/null || cor=""

#================================================

#==========================================TESTES
#Teste existencia pasta registro
if [ ! -d /$HOME/.monLAN ]
	then
	echo -e "Diretório de registro não encontrado... \nCriando diretório..."
	mkdir /$HOME/.monLAN || echo "Não foi possível criar o diretório"
	sleep 3
fi

#Teste se as cores estão configuradas
if [ ! -n "$cor" ]
	then
	echo -e "Cores não configuradas. Deseja habilitar? [s/n]"
	read ativarcores
		if [ "$ativarcores" = "s" ] || [ "$ativarcores" = "S" ]
			then
			echo "cor=\"1\"" > /$HOME/.monLAN/config && echo "Cores habilitadas"
			source /$HOME/.monLAN/config
			sleep 3
			else
			echo "cor=\"0\"" > /$HOME/.monLAN/config && echo "Cores desabilitadas"
			sleep 3
			source /$HOME/.monLAN/config
		fi
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

 -c|--checar)
	Imprime na tela os dispositivos registrados.

 -r|--registrar)
 	Registra um dispositivo.
  
 -d|--deletar)
 	Deleta um dispositvo do registro.

 -m|--monitorar)
 	Inicia o monitoramento dos dispositivos registrados.

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
#		  read -p "Digite quantos dispositivos serão registrados: " dispositivos
		    until [ "$confirmacao" = "s" ] ; do		#Confirmar as informações
		  	  read -p "Digite o nome do dispositivo que será registrado: " nome
		      read -p "Digite o IP do dispositivo que será registrado: " ip		 
			  echo -e "\n${vermelho}Confirmação${corpadrao} \nO nome será ${ciano}${nome}${corpadrao} e o IP será ${ciano}${ip}${corpadrao}\n"
			  echo "As informações estão corretas? [s/n]"
			  read confirmacao
			  echo "nome:${nome}:IP:${ip}" >> /$HOME/.monLAN/registro.txt && echo -e "\nRegistro realizado com sucesso. Digite a próxima tarefa: \n"
			done
			confirmacao=""
		  ;;

		  -c|--checar)
		  _LOGO
		  tabela=`cut -d: -f 2,4 /$HOME/.monLAN/registro.txt | tr -t : \  | column -t`
		  echo -e "${vermelho}\nDispositivos ${ciano}IPs${corpadrao} \n\n${tabela}" | column -t && echo -e "\nChecagem realizada. Digite a próxima tarefa: \n"
		  ;;
		  
		  -m|--monitorar)
		  while : #Entra em um loop que faz o teste completo infinitas vezes
		  do
		  echo "" > /$HOME/.monLAN/cache.txt #Esvazia o cache. Pode ser usado um rm também
		  linhas=$(wc -l /$HOME/.monLAN/registro.txt | cut -d\  -f 1) #Retira quantas linhas tem o arquivo de registro
		  loop="1"
			until [ "$loop" -gt "$linhas" ]
			  do
			  #Retira apenas o nome do dispositivo e seu IP para fazer o teste
			  nome_dispositivo=$(cat /$HOME/.monLAN/registro.txt | grep -n ^| grep ^${loop}: | cut -d: -f 3)
			  ip_dispositivo=$(cat /$HOME/.monLAN/registro.txt | grep -n ^| grep ^${loop}: | cut -d: -f 5)
			  #Realiza o teste de conexão e coloca o resultado no cache
			  ping -c 1 -W 1 ${ip_dispositivo} 1> /dev/null 2> /dev/null && \
			  echo -e "Dispositivo:${ciano}${nome_dispositivo}${corpadrao} Status:${verde}Conectado${corpadrao}" \
			  >> /$HOME/.monLAN/cache.txt || \
			  echo -e "Dispositivo:${ciano}${nome_dispositivo}${corpadrao} Status:${vermelho}Sem-Conexão${corpadrao}" \
			  >> /$HOME/.monLAN/cache.txt
			  #Imprime na tela as informações do cache
			  _LOGO ; cat /$HOME/.monLAN/cache.txt | column -t
			  eval "loop=\$((loop + 1))"
			  done
		  echo -e "\nReiniciando Testes..."
		  sleep 5
		  done
		  ;;

		  -d|--deletar)
		 	until [ "$confirmdel" = "s" ] ; do
			    tabela=$(cat -n /$HOME/.monLAN/registro.txt | sed 's/\s\+/ /g' | tr : ' ' | cut -d ' ' -f2,4,6)
			    echo -e "Listagem:\n ${vermelho}Número ${verde}Dispositivos ${ciano}IPs${corpadrao}\n${tabela}" | column -t
		 	    echo -e "\nEscolha o dispositivo a ser ${vermelho}DELETADO${corpadrao}:"
		 	      read delete
				excluido=$(cat -n /$HOME/.monLAN/registro.txt | head -n ${delete} | tail -n 1 | sed 's/\s\+/ /g' | tr : ' ' | cut -d ' ' -f 4 | tr a-z A-Z)
				echo -e "O dispositivo: ${vermelho}${excluido}${corpadrao} deve ser ${vermelho}EXCLUÍDO${corpadrao}? [s/n]"
				read confirmdel
			done
				sed -i ${delete}d /$HOME/.monLAN/registro.txt 
			    echo -e "O ${vermelho}${excluido}${corpadrao} foi DELETADO! \n" && sleep 4 && clear && _LOGO && echo "Digite a próxima tarefa:"
			confirmdel="0"
		  ;;
		    

		  -v|--vasculhar)
			echo "Qual a rede será vasculhada?"
			read ip_rede
			echo -e "\nA rede: ${vermelho}${ip_rede}${corpadrao} está sendo vasculhada! Este processo pode DEMORAR"
			octeto1=$(echo "$ip_rede" | cut -d. -f1)
			octeto2=$(echo "$ip_rede" | cut -d. -f2)
			octeto3=$(echo "$ip_rede" | cut -d. -f3)
			octeto4=$(echo "$ip_rede" | cut -d. -f4)
			eval "octeto4=\$((octeto4 + 1))"
			ipinicial=$(echo "${octeto1}.${octeto2}.${octeto3}.${octeto4}")
			eval "octeto4=\$((octeto4 + 253))"
			if [ $octeto3 = "0" ]
			 then
			 eval "octeto3=\$((octeto3 + 255))"
			fi
			if [ $octeto2 = "0" ]
			 then
			 eval "octeto2=\$((octeto2 + 255))"
			fi

			ipatual=$ipinicial
			ipfinal=$(echo "${octeto1}.${octeto2}.${octeto3}.${octeto4}")			

			#separa cada parte do ip
			part1=$(echo "$ipatual" | cut -d. -f 1)
			part2=$(echo "$ipatual" | cut -d. -f 2)
			part3=$(echo "$ipatual" | cut -d. -f 3)
			part4=$(echo "$ipatual" | cut -d. -f 4)


				until [ "$ipatual" = "$ipfinal" ] ; do #entra no loop

				   #atualiza o valor do ip atual
				   ipatual=$(echo "${part1}.${part2}.${part3}.${part4}")

				   #separa cada parte do ip
				   part1=$(echo "$ipatual" | cut -d. -f 1)
				   part2=$(echo "$ipatual" | cut -d. -f 2)
				   part3=$(echo "$ipatual" | cut -d. -f 3)
				   part4=$(echo "$ipatual" | cut -d. -f 4)

				   #mostra o ip atual que sera usado para o teste
				   ping -c 1 -w 1 ${ipatual} 1> /dev/null 2> /dev/null && {
				   echo -e "IP:${ipatual} Status:$ATIVO$" \
				   >> /$HOME/.monLAN/${ip_rede}.txt; echo -e "IP:${ciano}${ipatual}${corpadrao} Status:${verde}ATIVO${corpadrao}"; echo -e "IP:${ipatual} Status:ATIVO$" >> /$HOME/Documentos/${ip_rede}.txt
				   }

				   #aumenta o ip
				   eval "part4=\$((part4 + 1))"


					#aumenta outro numero la tlg
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
				 ipativos=$(cat -n /$HOME/Documentos/$(ip_rede}.txt | sed 's/\s\+/ /g' | cut -d ' ' -f 2 )
					echo -e "Varredura finalizada! Foi encontrado ${verde}${ipativos}${corpadrao} IPs Ativos! \n Os IPs foram salvos em um aquivo de texto na pasta Documentos! \n\n Escolha a próxima tarefa:"
	 		;;

		  *)
		  echo -e "\nOpção inválida. Digite -h ou --help para ver as opções válidas.\n"
		  ;;
		  
	  	esac
	  
	  read tarefa
	  done

		  
#================================================
