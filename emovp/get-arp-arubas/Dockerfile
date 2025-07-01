# Imagen base de Fedora
FROM fedora:36

# Argumento para el nombre de usuario
ARG USERNAME

# Instalar dependencias del sistema + pip + Ansible 2.9.27
RUN dnf update -y && \
    dnf install -y \
        zsh git ncdu curl htop screenfetch \
        python3 python3-pip openssh-clients && \
    pip3 install "ansible==2.9.27" && \
    dnf clean all

# Crear usuario y agregar al grupo wheel
RUN useradd -m -s /usr/bin/zsh $USERNAME

# Establecer contraseña (usando secrets)
RUN --mount=type=secret,id=user_password \
    cat /run/secrets/user_password | chpasswd

# Agregar el usuario al grupo sudoers
RUN usermod -aG wheel $USERNAME

# Cambiar al usuario creado
USER $USERNAME
WORKDIR /home/$USERNAME

# Instalar Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Directorio de trabajo para tu proyecto
WORKDIR /home/$USERNAME/get-arp-arubas

CMD ["/usr/bin/zsh"]
