#!/bin/bash
# Proxy if for ATOS

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

#Set proxy
#ENV HTTP_PROXY=http://193.56.47.8:8080
#ENV HTTPS_PROXY=http://193.56.47.8:8080

#Set APT proxy
echo "Set proxy configuration for apt"
echo "Acquire::http::Proxy \"http://193.56.47.8:8080\";" >> /etc/apt/apt.conf

#Update and Upgrade
echo "Updating and Upgrading"
apt-get update && sudo apt-get upgrade -y

# Install packages to allow apt to use a repository over HTTPS
echo "Install Docker-CE"
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    vim \
    htop \
    multitail \
    screen \
    bash-completion

#uninstall Older versions of Docker
apt-get remove docker docker-engine docker.io

#Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#Add repository
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
apt-get update

#Install docker-ce
apt-get install docker-ce
docker --version


export http_proxy=http://193.56.47.8:8080
export https_proxy=http://193.56.47.8:8080

#Install docker-compose
echo "Install Docker-Compose"
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

apt autoremove
