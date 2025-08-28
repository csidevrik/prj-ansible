# Imagen base de Fedora
FROM fedora:36

# Argumento para el nombre de usuario
ARG USERNAME

# Instalar dependencias del sistema + pip + Ansible 2.9.27
RUN dnf update -y && \
    dnf install -y \
        zsh git ncdu curl htop screenfetch \
        python3 python3-pip openssh-server openssh-clients && \
    pip3 install "ansible==2.9.27" && \
    dnf clean all

# Crear usuario y agregar al grupo wheel
RUN useradd -m -s /usr/bin/zsh $USERNAME

# Establecer contraseña (usando secrets)
RUN --mount=type=secret,id=user_password \
    cat /run/secrets/user_password | chpasswd

# Agregar el usuario al grupo sudoers
RUN usermod -aG wheel $USERNAME

# Configuración de SSH
RUN ssh-keygen -A && \
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Exponer puerto SSH
EXPOSE 22

# Copiar todo el proyecto al contenedor
COPY . /home/${USERNAME}/get-arp-arubas

# Cambiar al usuario creado
USER $USERNAME
WORKDIR /home/$USERNAME

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

WORKDIR /home/$USERNAME/get-arp-arubas

# 🔁 Iniciar el servidor SSH al arrancar el contenedor
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh
CMD ["/usr/local/bin/entrypoint.sh"]
