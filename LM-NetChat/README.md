# LM-NetChat <img src='https://i.imgur.com/NNfTFYP.png' align='right' height='300'>
Sistema de comunicação por chat entre dois hosts dentro de uma rede LAN via terminal.

## Data de Criação
31/12/2018

## Funcionamento
Para que ocorra o funcionamento do chat é necessário que um indivíduo crie o chat (dizendo 
por qual porta ocorrerá a comunicação) e outro outro indíviduo acesse o chat (dizendo qual 
o IP do criador e qual a porta que foi escolhida para a comunicação).
   
O programa utiliza o Netcat para realizar a troca de informações entre os usuários, por tal 
motivo o programa chama-se NetChat, sendo um trocadilho com a maneira que ele funciona.

## Opções
```
-h|--help
    Imprime esta lista de comandos.
 -m|--manual
    Imprime o manual de funcionamento do programa.
 -r|--hostear
    Cria um chat.
 -c|--conectar
    Se conecta a um chat existente.
 -s|--sair
    Sai do programa.
```

## Changelog
https://github.com/Mewbi/tcc-senai/blob/master/LM-NetChat/changelog.txt

## Autor
Felipe Fernandes [ felipefernandesgsc@gmail.com ]


