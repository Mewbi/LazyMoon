# SSHost <img src='https://i.imgur.com/mKqJ5TU.png' align='right' height='300'>
Sistema de acesso e controle de máquinas pelo terminal dentro e fora da rede LAN.

## Data de Criação
02/06/2019

## Funcionamento
A conexão é feita  utilizando o protocolo  SSH junto com a opção -X para que possa ser 
executado programas que  utilizam interface  gráfica, sendo passado tal interface para
o usuário que realiza a conexão. A conexão LAN necessita apenas o usuário e o IP da 
máquina de acesso, enquanto para fazer a conexão WAN necessita o IP externo da rede, 
o usuário e a porta (externa) do roteador que será feita  a conexão. Além disso é 
possível ativar e desativar o SSH no computador.

## Opções
```
-h|--help)
   Impreme esta lista de comandos.
 -m|--manual)
   Imprime o manual de funcionamento do programa.
 -l|--lan)
   Realiza a conexão via SSH na rede LAN.
 -w|--wan)
   Realiza a conexão via SSH pela rede WAN.
 -a|--ativar)
   Ativa o SSH no computador.
 -d|--desativar)
   Desativa o SSH no computador.
 -e|--enviar)
   Envia arquivos do "Repositório" para uma máquina na rede LAN.
 -s|--sair)
   Sai do programa.
```

## Changelog
https://github.com/Mewbi/tcc-senai/blob/master/LM-SSHost/changelog.txt

## Autor
Felipe Fernandes [ felipefernandesgsc@gmail.com ]

