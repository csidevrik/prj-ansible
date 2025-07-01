Documentación para Automatización de Switches Aruba con Ansible

Requisitos Previos

1. Paquetes necesarios

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



