# Lazy Moon
Repositório oficial das versões mais atualizadas dos projetos referentes ao projeto Lazy Moon.

## Objetivo
Desenvolver um sistema de monitoramento e gerenciamento dentro da rede LAN que possa ser acessado por redes externas (WAN).

## Como
Criando uma série de programas interligados que realizem as funções de registro, extração de dados, organização, acesso e monitoramento.

## Pré-Requisitos
Alguns programas precisam estar instalados tanto na máquina "Monitor" quantos nos servers "Clientes" para que os programas funcionem completamente. Tais requisitos são impressos no terminal quando é executado o script de instalação "install.sh".
Existem dois scripts "install.sh", o localizado dentro da pasta principal é o script que deve ser executado na máquina "Monitor", enquanto o script localizado em "Repositorio" deve ser executado nas máquinas "Clientes".

### Monitor

### Server Cliente

## Funcionamento
Primeiramente, é importante saber que os programas possuem uma arquitetura de funcionamento representada abaixo, na qual primeiro se estabalecerão as bibliotecas de banco de dados, tanto dos arquivos de login quanto das configurações realizadas e do monitoramento em si. Logo após, a organização se dá através das diferentes camadas de ação de cada programa.    
<img src='https://i.imgur.com/Tv3ZqRw.png' align='center' height='750'>

### LM-Login
- Responsável pela autenticação e redirecionamento do sistema.
