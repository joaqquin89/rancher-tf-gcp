#!/bin/bash


echo "Value of Param1 is $1";

#
# Installing Docker first 
#
apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo service docker start
sudo mkdir -p /opt/rancher
sudo docker run hello-world
#
# Create self-signed certificate
#
sudo mkdir -p $PWD/certs
sudo docker run -v $PWD/certs:/certs \
           -e CA_SUBJECT="My own root CA" \
           -e CA_EXPIRE="1825" \
           -e SSL_EXPIRE="365" \
           -e SSL_SUBJECT="$1" \
           -e SSL_DNS="$1" \
           -e SILENT="true" \
			superseb/omgwtfssl
openssl verify -CAfile certs/ca.pem certs/cert.pem
#
# Start rancher server
#
sudo docker run -d --restart=unless-stopped -v /opt/rancher:/var/lib/rancher -v $PWD/certs/cert.pem:/etc/rancher/ssl/cert.pem \
                -v $PWD/certs/key.pem:/etc/rancher/ssl/key.pem \
                -v $PWD/certs/ca.pem:/etc/rancher/ssl/cacerts.pem \
			    -p 443:443 -p 80:80 -p 6443:6443 --name rancherserver rancher/rancher:v2.3.5

sudo docker logs rancherserver