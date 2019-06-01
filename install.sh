#!/bin/bash

#Organiza os programas no diretório ideal para o funcionamento

mkdir $HOME/LazyMoon \
|| { echo -e "\nNão Foi possível criar o diretório raiz do programa em $HOME \nVerifique as permissões e inicie o instalador novamente \nAbortando..." ; exit ;}
mkdir $HOME/LazyMoon/Biblioteca
mkdir $HOME/LazyMoon/Biblioteca/Redes
mv banco-logins.txt $HOME/LazyMoon/Biblioteca/

chmod +x LM-Login/LM-Login
chmod +x LM-Management/LM-Management
chmod +x LM-MRI/LM-MRI
chmod +x LM-SSHost/LM-SSHost
chmod +x LM-NetChat/LM-NetChat
chmod +x LM-CService/LM-CService

mv LM-Login $HOME/LazyMoon
mv LM-Management $HOME/LazyMoon
mv LM-MRI $HOME/LazyMoon
mv LM-SSHost $HOME/LazyMoon
mv LM-NetChat $HOME/LazyMoon
mv LM-CService $HOME/LazyMoon
mv README.md $HOME/LazyMoon

#cp $HOME/LazyMoon/LM-Login/LM-Login /usr/bin/LM-Login || echo "Erro na criação de atalho do 'LM-Login' no terminal"

