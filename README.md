# TCC-SENAI
Repositório oficial das versões mais atualizadas dos projetos referentes ao TCC.

## Objetivo
Desenvolver um sistema de monitoramento dentro da rede LAN que possa ser acessado por redes externas (WAN).

## Como
Criando uma série de programas interligados que realizem as funções de registro, extração de dados, organização, acesso e monitoramento.

## Funcionamento
Primeiramente, é importante saber que os programas possuem uma arquitetura de funcionamento representada abaixo, na qual primeiro se estabalecerão as bibliotecas de banco de dados, tanto dos arquivos de login quanto das configurações realizadas e do monitoramento em si. Logo após, a organização se dá através das diferentes camadas de ação de cada programa.    
<img src='https://i.imgur.com/Tv3ZqRw.png' align='center' height='750'>

### LM-Login
- Responsável pela autenticação e redirecionamento do sistema.
