#!/bin/bash
set -e

# Generar llaves si no existen
ssh-keygen -A

# Iniciar el servidor SSH
/usr/sbin/sshd

# Entrar en ZSH (si quieres dejar terminal activa)
/usr/bin/zsh
