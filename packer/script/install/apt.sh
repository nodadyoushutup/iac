#!/bin/bash -eu

echo "==> Updating apt cache"
sudo apt-get update -qq

echo "==> Upgrading apt packages"
sudo apt-get upgrade -y -qq

echo "==> Installing apt packages"
sudo apt-get install -y -qq \
    age \
    curl \
    dnsutils \
    git \
    htop \
    ifupdown \
    iptables \
    jq \
    lsof \
    mysql-client-core-8.0 \
    make \
    nano \
    net-tools \
    nfs-common \
    nmap \
    postgresql-client \
    python3 \
    python3-pip \
    qemu-guest-agent \
    qemu-system \
    screen \
    strace \
    tcpdump \
    tmux \
    traceroute \
    unzip \
    vim \
    wget \
    whois \
    xorriso \
    zip