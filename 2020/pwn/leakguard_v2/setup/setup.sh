#!/bin/bash

if [ "$(id -u)" -ne "0" ] ; then
    echo "please run as root / with sudo"
    exit
fi

set -exo pipefail

apt-get update
apt-get upgrade -y

# install docker
export DEBIAN_FRONTEND=noninteractive
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io -y

# if the challenge needs to be updated, just re-run these commands
# to build/run the docker container
# (will probably need to stop the existing container with
#   docker rm -f candles2
# and if something is funky, possibly delete the image:
#   docker rmi candles2
# )
cd src
docker build -t candles2 .
docker run -p 3451:3451 -d --name candles2 candles2