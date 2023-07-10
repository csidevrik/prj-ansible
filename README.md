ANSIBLE PLAY BOOKS
------------------------------------------------

On this repo, we share how to use ansible for a mini enterprise network.

## INTRODUCCION
Ansible® es una aplicación de software de automatización de TI de línea de comandos de código abierto escrita en Python. Puede configurar sistemas, implementar software y organizar flujos de trabajo avanzados para respaldar la implementación de aplicaciones, actualizaciones de sistemas y más.

## PREREQUISITES
Primero necesitamos comprender para que queremos usar ansible y dentro de la documentacion de ansible esta nos ensena algunas alternativas o caminos que podriamos escoger para lograr esta automatizacion y dentro de que categoria nos debemos enmarcar.

En general esta libre de descarga para las distintas plaltaformas pero de momento mencionaremos la diferencia de cada uno.

## Installation
La instalacion es facil en los dos sistemas operativos mencionados

### Ubuntu
```shell
sudo apt install ansible
```
### Fedora
```shell
sudo dnf install ansible
```
## DEFINICIONES
### NODO ANSIBLE CONTROLER
Este nodo ser[a] el controlador de la red, en el es el unico en el cual debe estar instalado ansible
### NODO ANSIBLE CONTROLED
Ya que este ser[a] el nodo controlado debe tener activo ssh para poder conectarse al mismo y administrarlos

### Pasos sobre el nodo controler




- [Bashly framework](https://bashly.dannyb.co/)


@startuml
Bob -[#red]> Alice : hello
Alice -[#0000FF]->Bob : ok
@enduml