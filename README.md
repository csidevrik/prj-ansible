ANSIBLE PLAY BOOKS
------------------------------------------------
zap Simple and fast dotfiles framework zap

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


Para administrar un nodo remoto con Ansible, necesitarás compartir la clave SSH del controlador Ansible con el nodo remoto. Aquí tienes los pasos generales para hacerlo:

1. Genera un par de claves SSH en tu controlador Ansible, si aún no lo has hecho. Puedes hacerlo utilizando el comando ssh-keygen en tu máquina local. Esto generará una clave pública y una clave privada.

2. Copia la clave pública (archivo .pub) a tu nodo remoto. Puedes hacerlo utilizando el comando ssh-copy-id. Por ejemplo:

```shell
ssh-copy-id user@nodo-remoto
```
Esto copiará tu clave pública al nodo remoto y la agregará al archivo ~/.ssh/authorized_keys en el nodo.

3. Verifica que puedes conectarte al nodo remoto sin ingresar una contraseña. Puedes probarlo ejecutando:

```shell
ssh user@nodo-remoto
```
Si todo está configurado correctamente, deberías poder conectarte sin necesidad de ingresar una contraseña.

4. Configura el archivo de inventario de Ansible para incluir la dirección IP o el nombre del nodo remoto y la conexión SSH. Por ejemplo:



```shell
[nodos-remotos]
nodo-remoto ansible_host=<dirección-IP> ansible_user=<usuario-remoto>
```
Asegúrate de reemplazar <dirección-IP> y <usuario-remoto> con los valores correspondientes para tu configuración.

Una vez que hayas realizado estos pasos, puedes ejecutar comandos de Ansible para administrar el nodo remoto utilizando la conexión SSH establecida. Por ejemplo, puedes ejecutar un playbook de Ansible en el nodo remoto utilizando el siguiente comando:

```shell
ansible-playbook -i inventario playbook.yml
```
Recuerda ajustar el nombre del archivo de inventario y el playbook (playbook.yml) según corresponda a tu configuración.

Estos son los pasos básicos para compartir la clave SSH y administrar un nodo remoto con Ansible. Recuerda seguir las mejores prácticas de seguridad y asegurarte de proteger adecuadamente las claves privadas y las conexiones SSH en tu entorno.



- [Bashly framework](https://bashly.dannyb.co/)

