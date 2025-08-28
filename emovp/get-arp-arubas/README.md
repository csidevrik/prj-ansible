Documentación para Automatización de Switches Aruba con Ansible
===============================================================



Requisitos Previos
------------------

# 1. Entorno de trabajo para el contenedor
Previamente para trabajar este proyecto, debemos tener un entorno de laboratorio establecido, que cumplan las condiciones mas adecuadas para lograr
ver resultados en este proyecto.

## 1.1 Maquina fisica o virtual que tenga instalado docker engine
Para esto puedes consultar el sitio de docker documentacion y ver como instalar docker ya sea en la maquina fisica o virtual segun tu eleccion.
Trataremos de sintetizar segun lo que hayas escogido.

Instalacion de docker 

https://docs.docker.com/engine/install/fedora/

### 1.1.1 Maquina Fisica
En una maquina fisica depende si eliges linux o windows, para este proyecto hemos preferido linux y ha sido fedora lo mas actualizado posible.

#### 1.1.1.1 Configuración de Macvlan en Docker con Fedora
Requisitos Previos del Sistema
1. Verificación del Kernel
bash
# Verificar que el kernel soporte macvlan
lsmod | grep macvlan
modinfo macvlan

# Si no está cargado, cargarlo manualmente
sudo modprobe macvlan
2. Información de Red Necesaria
Antes de continuar, necesitas conocer:

bash
# Obtener información de tu interfaz de red principal
ip addr show
ip route show default

# Ejemplo de salida que necesitas:
# - Interfaz: enp3s0 (o similar)
# - Red local: 192.168.1.0/24
# - Gateway: 192.168.1.1
3. Verificación de Docker
bash
# Verificar versión de Docker
docker --version
systemctl status docker

# Si no está instalado
sudo dnf install docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
Configuración del Sistema Fedora
1. Configuración de Firewall
bash
# Opción 1: Permitir tráfico docker en firewalld
sudo firewall-cmd --permanent --zone=trusted --add-interface=docker0
sudo firewall-cmd --permanent --zone=trusted --add-masquerade

# Opción 2: Crear zona específica para macvlan
sudo firewall-cmd --permanent --new-zone=macvlan
sudo firewall-cmd --permanent --zone=macvlan --set-target=ACCEPT
sudo firewall-cmd --permanent --zone=macvlan --add-interface=mv-eth0
sudo firewall-cmd --reload
2. Configuración de NetworkManager
bash
# Evitar que NetworkManager interfiera con macvlan
sudo cat > /etc/NetworkManager/conf.d/docker-macvlan.conf << EOF
[keyfile]
unmanaged-devices=interface-name:mv-*,interface-name:docker*
EOF

sudo systemctl restart NetworkManager
3. Configuración del Kernel (Persistente)
bash
# Cargar módulo macvlan automáticamente
echo "macvlan" | sudo tee -a /etc/modules-load.d/macvlan.conf

# Configurar parámetros de red
sudo cat > /etc/sysctl.d/99-docker-macvlan.conf << EOF
net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
EOF

sudo sysctl --system
Creación de la Red Macvlan
1. Crear Red Macvlan Básica
bash
# Reemplaza los valores según tu red
PARENT_INTERFACE="enp3s0"  # Tu interfaz principal
SUBNET="192.168.1.0/24"    # Tu subred
GATEWAY="192.168.1.1"      # Tu gateway
IP_RANGE="192.168.1.100/28" # Rango para contenedores (100-115)

docker network create -d macvlan \
  --subnet=$SUBNET \
  --gateway=$GATEWAY \
  --ip-range=$IP_RANGE \
  -o parent=$PARENT_INTERFACE \
  macvlan-net
2. Verificar la Red Creada
bash
docker network ls
docker network inspect macvlan-net
Solución al Problema de Conectividad Host-Contenedor
1. Crear Interfaz Macvlan en el Host
bash
# Crear script para interfaz macvlan persistente
sudo cat > /etc/NetworkManager/dispatcher.d/50-macvlan << 'EOF'
#!/bin/bash
INTERFACE="enp3s0"  # Cambia por tu interfaz
MACVLAN_IP="192.168.1.99/24"  # IP para el host en la red macvlan

if [ "$1" = "$INTERFACE" ] && [ "$2" = "up" ]; then
    ip link add mv-host link $INTERFACE type macvlan mode bridge
    ip addr add $MACVLAN_IP dev mv-host
    ip link set mv-host up
    ip route add 192.168.1.100/28 dev mv-host
fi
EOF

sudo chmod +x /etc/NetworkManager/dispatcher.d/50-macvlan
2. Configuración Manual Temporal
bash
# Para testing inmediato (se pierde al reiniciar)
sudo ip link add mv-host link enp3s0 type macvlan mode bridge
sudo ip addr add 192.168.1.99/24 dev mv-host
sudo ip link set mv-host up
sudo ip route add 192.168.1.100/28 dev mv-host
Uso Práctico
1. Ejecutar Contenedor con IP Específica
bash
# Contenedor con IP fija
docker run -d \
  --name web-server \
  --network macvlan-net \
  --ip 192.168.1.100 \
  nginx:latest

# Contenedor con IP automática del rango
docker run -d \
  --name app-server \
  --network macvlan-net \
  httpd:latest
2. Verificar Conectividad
bash
# Desde el host (después de configurar mv-host)
ping 192.168.1.100

# Desde otros dispositivos de la red
ping 192.168.1.100

# Ver IPs asignadas
docker inspect web-server | grep IPAddress
3. Docker Compose con Macvlan
yaml
version: '3.8'
services:
  web:
    image: nginx:latest
    networks:
      macvlan-net:
        ipv4_address: 192.168.1.101
    ports:
      - "80:80"

networks:
  macvlan-net:
    external: true
Troubleshooting
1. Problemas Comunes
bash
# Error: network not found
docker network ls

# Error: address already in use
ip addr show | grep 192.168.1.100

# Error: permission denied
sudo usermod -aG docker $USER
newgrp docker

# Verificar logs de firewall
sudo journalctl -u firewalld -f
2. Comandos de Diagnóstico
bash
# Ver interfaces de red
ip link show type macvlan

# Ver rutas
ip route show

# Ver reglas de firewall
sudo firewall-cmd --list-all-zones

# Logs de Docker
sudo journalctl -u docker -f

# Verificar módulos del kernel
lsmod | grep -E "(macvlan|bridge)"
3. Limpiar Configuración
bash
# Eliminar red macvlan
docker network rm macvlan-net

# Eliminar interfaz macvlan del host
sudo ip link delete mv-host

# Reiniciar Docker
sudo systemctl restart docker
Script de Automatización
setup-macvlan.sh
bash
#!/bin/bash
set -e

# Configuración
INTERFACE=${1:-$(ip route | grep default | awk '{print $5}' | head -1)}
SUBNET=${2:-"192.168.1.0/24"}
GATEWAY=${3:-$(ip route | grep default | awk '{print $3}' | head -1)}
IP_RANGE=${4:-"192.168.1.100/28"}

echo "Configurando Macvlan en Fedora..."
echo "Interfaz: $INTERFACE"
echo "Subred: $SUBNET"
echo "Gateway: $GATEWAY"
echo "Rango IP: $IP_RANGE"

# Cargar módulo macvlan
sudo modprobe macvlan
echo "macvlan" | sudo tee -a /etc/modules-load.d/macvlan.conf

# Crear red Docker
docker network create -d macvlan \
  --subnet=$SUBNET \
  --gateway=$GATEWAY \
  --ip-range=$IP_RANGE \
  -o parent=$INTERFACE \
  macvlan-net

echo "Red macvlan-net creada exitosamente!"
docker network ls | grep macvlan
Uso del Script
bash
chmod +x setup-macvlan.sh
./setup-macvlan.sh enp3s0 192.168.1.0/24 192.168.1.1 192.168.1.100/28
Consideraciones de Seguridad
Aislamiento: Los contenedores macvlan pueden comunicarse directamente con la red, evitando iptables del host
Firewall: Configura reglas específicas para los contenedores si es necesario
Monitoreo: Supervisa el tráfico de red de los contenedores
Updates: Mantén Docker y el kernel actualizados
Notas Importantes
Los contenedores con macvlan no pueden comunicarse con el host por defecto (requiere mv-host)
El rango de IPs debe estar dentro de tu subred local
Algunos routers/switches pueden tener limitaciones con múltiples MACs en un puerto
Considera usar VLAN tags si tu infraestructura lo soporta
Referencias
Docker Macvlan Networks
Fedora Networking Guide
Linux Networking








//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Instala Ansible y las dependencias:
```bash
sudo dnf install ansible git -y  # En Fedora
```

2. Crear entorno de trabajo
```bash
mkdir -p ~/ansible-aruba/{inventory,playbooks,vault}
cd ~/ansible-aruba
```

3. Instalar colecciones necesarias
```bash
ansible-galaxy collection install arubanetworks.aos_switch
```

Inventario de Hosts (YAML)

**Archivo: inventory/hosts.yml**

```note
all:
  children:
    aruba_switches:
      hosts:
        SW_31_CAPULISPAMBA:
          ansible_host: 10.31.99.1
          ansible_user: "{{ vault_credentials.switch1.username }}"
          ansible_password: "{{ vault_credentials.switch1.password }}"
          ansible_connection: ssh
          ansible_ssh_common_args: '-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa'
```

🔒 Variables sensibles se guardan en vault/vault_credentials.yml

Vault de credenciales

**Archivo: vault/vault_credentials.yml**
```note
vault_credentials:
  switch1:
    username: admemov
    password: supersecreta123
```

Para encriptarlo:
```bash
ansible-vault encrypt vault/vault_credentials.yml
```

Playbook de prueba con cli_command

**Archivo: playbooks/get_version.yml**
```bash
---
- name: Obtener versión del sistema Aruba
  hosts: aruba_switches
  gather_facts: no
  vars_files:
    - ../vault/vault_credentials.yml
  tasks:
    - name: Ejecutar comando show version
      cli_command:
        command: "show version"
      register: version_output

    - name: Mostrar salida
      debug:
        var: version_output.stdout_lines
```
Ejecución:
```bash
ansible-playbook -i inventory/hosts.yml playbooks/get_version.yml --ask-vault-pass
```

Verificación de Conectividad

Si tienes problemas, prueba:

ansible 10.31.99.1 -m raw -a "show version" -u admemov --ask-pass -i inventory/hosts.yml

Notas importantes

No uses arubaoss_command si no tienes la API REST habilitada en los switches.

Si ves errores de paramiko, forzar ansible_connection: ssh en lugar de network_cli.

Si necesitas SHA2, prueba:

ansible_ssh_common_args: '-o PubkeyAcceptedAlgorithms=+rsa-sha2-512 -o HostKeyAlgorithms=+rsa-sha2-512'

Listo. Desde aquí puedes construir playbooks más complejos.



