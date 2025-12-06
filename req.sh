#!/bin/bash

set -e

# Update system
apt update -y
apt upgrade -y

# Install basic packages
apt install -y --no-install-recommends \
    acl \
    curl \
    systemd \
    openssh-server \
    nginx \
    git \
    apt-transport-https \
    ca-certificates \
    gnupg \
    ufw

# Docker GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker apt repo
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  > /etc/apt/sources.list.d/docker.list

apt update -y

# Install docker
apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Add the real sudo user to docker group
if [ ! -z "$SUDO_USER" ]; then
    usermod -aG docker "$SUDO_USER"
    echo "Added $SUDO_USER to docker group."
fi

echo "All requirements installed successfully!"
