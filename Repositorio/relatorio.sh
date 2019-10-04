#!/usr/bin/env bash

#---------------------------------------Libraries
source $HOME/LM-relatorio/config.txt
path="${user}@${ip}:${dir}"
#------------------------------------------------

#-----------------Hardware & Software Information
distro=$(uname -a | cut -d\  -f 2)
kernelName=$(uname -s)
hardwareArchiteture=$(uname -m)
cpu=$(cat /proc/cpuinfo | grep "model name" | tail -n 1 | cut -d: -f 2)
memTotal=$(cat /proc/meminfo | grep "MemTotal" | tr ' ' '\n' | grep [0-9]) #KBytes
memTotalMb=$(echo "scale=2;(${memTotal}/1024)" | bc)
#------------------------------------------------

#----------------------------------Hardware Usage
uptime=$(uptime | cut -d, -f -1)
hds=$(df -H | grep "sd") #GBytes
memAvailable=$(cat /proc/meminfo | grep "MemAvailable" | tr ' ' '\n' | grep [0-9]) #KBytes
memAvailableMb=$(echo "scale=2;(${memAvailable}/1024)" | bc)
cpuUsage=$(top -b -n2 -d 1 | awk "/^top/{i++}i==2" | grep -Ei "cpu\(s\)\s*:" | cut -d\   -f 2) #Percentage
#------------------------------------------------

#--------------------------------Creating Reports
date=$(date "+%d-%m-%Y-[%Hh%Mm]")
name="relatorio-${serverName}-${date}"
cat >> ${name}.txt << END

	Server: ${serverName}

----------Informações de Hardware e Software----------
Distribuição: ${distro}
Nome do Kernel: ${kernelName}
Arquitetura do Hardware: ${hardwareArchiteture}
Modelo do Processador: ${cpu}
Memória RAM: ${memTotalMb}MB

-------------------Uso de Hardware--------------------
Ligado as: ${uptime/up/Tempo Ligado} h
Uso da CPU: ${cpuUsage}%
Memória RAM livre para uso: ${memAvailableMb}MB

	 Sist. Arq.      Tam. Usado Disp. Uso% Montado em
HDs: ${hds}
END

cat >> ${name}.html << END
<!DOCTYPE html>
<html lang="pt-br">
<head>
	<meta charset="UTF-8">
	<title>${serverName}</title>
</head>
<body>
	<h1>Server: ${serverName}</h1><hr> 
	<h2>Informações de Hardware e Software</h2>
	<p><b>Distribuição: </b>${distro}</p>
	<p><b>Nome do Kernel: </b>${kernelName}</p>
	<p><b>Arquitetura do Hardware: </b>${hardwareArchiteture}</p>
	<p><b>Modelo do Processador: </b>${cpu}</p>
	<p><b>Memória RAM: </b>${memTotalMb} MB</p>
	<hr>
	<h2>Uso de Hardware</h2>
	<p><b>Ligado as: </b>${uptime/up/Tempo Ligado} h</p>
	<p><b>Uso da CPU: </b>${cpuUsage}%</p>
	<p><b>Memória RAM livre para uso: </b>${memAvailableMb} MB</p>
	<p>Sist. Arq. Tam. Usado Disp. Uso% Montado em</p>
	<p><b>HDs: </b>${hds}</p>
</body>
</html>
END
#------------------------------------------------

#---------------------------------Sending Reports
scp ${name}.txt ${path}
scp ${name}.html ${path}

mv ${name}.txt LM-relatorio
mv ${name}.html LM-relatorio
#------------------------------------------------