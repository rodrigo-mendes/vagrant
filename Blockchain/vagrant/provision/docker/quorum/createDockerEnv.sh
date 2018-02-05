#!/bin/bash


#Proxy everis Network
echo "===================================================================================="
echo "Docker behind Proxy everis Network Configuring ..."
echo "===================================================================================="
export HTTP_PROXY=http://rmendess:Banshee1981@10.0.8.102:8080
export HTTPS_PROXY=http://rmendess:Banshee1981@10.0.8.102:8080
export FTP_PROXY=http://rmendess:Banshee1981@10.0.8.102:8080
export http_proxy=http://rmendess:Banshee1981@10.0.8.102:8080
export https_proxy=http://rmendess:Banshee1981@10.0.8.102:8080
export ftp_proxy=http://rmendess:Banshee1981@10.0.8.102:8080
export no_proxy="127.0.0.1, 172.16.78.{0..255}, 10.{0..255}.{0..255}.{0..255}"
export NO_PROXY="127.0.0.1, 172.16.78.{0..255}, 10.{0..255}.{0..255}.{0..255}"

cat <<EOF | sudo tee -a /etc/sysconfig/docker
HTTP_PROXY=http://rmendess:Banshee1981@10.0.8.102:8080
HTTPS_PROXY=http://rmendess:Banshee1981@10.0.8.102:8080
FTP_PROXY=http://rmendess:Banshee1981@10.0.8.102:8080
http_proxy=http://rmendess:Banshee1981@10.0.8.102:8080
https_proxy=http://rmendess:Banshee1981@10.0.8.102:8080
ftp_proxy=http://rmendess:Banshee1981@10.0.8.102:8080
no_proxy="127.0.0.1, 172.16.78.{0..255}, 10.{0..255}.{0..255}.{0..255}"
NO_PROXY="127.0.0.1, 172.16.78.{0..255}, 10.{0..255}.{0..255}.{0..255}"
EOF
 
sudo sed -i '/\[Service\]/a EnvironmentFile=/etc/sysconfig/docker' /usr/lib/systemd/system/docker.service
sudo systemctl daemon-reload
sudo service docker restart

echo "===================================================================================="
echo "Docker behind Proxy everis Network Configured"
echo "===================================================================================="

echo "===================================================================================="
echo "Removing docker instances"
echo "===================================================================================="
sudo docker rm -f validatornode1
sudo docker rm -f validatornode2
sudo docker rm -f validatornode3
sudo docker rm -f generalnode1
sudo docker rm -f generalnode2
sudo docker rm -f generalnode3
sudo docker rm -f clientquorum
echo "===================================================================================="
echo "Removed docker instance"
echo "===================================================================================="

echo "===================================================================================="
echo "Removing Images"
echo "===================================================================================="
sudo docker rmi -f quorum_validator_node
sudo docker rmi -f quorum_general_node
sudo docker rmi -f ethereum_client
echo "===================================================================================="
echo "Removed Images"
echo "===================================================================================="

echo "===================================================================================="
echo "Creating Images"
echo "===================================================================================="
./dockerImageGeneralNodes.sh
./dockerImageValidatorNodes.sh
./dockerImageClient.sh
echo "===================================================================================="
echo "Images created"
echo "===================================================================================="

#Network
echo "===================================================================================="
echo "Creating Network"
echo "===================================================================================="
sudo docker network create --subnet 172.18.0.0/16 ethnetwork
sudo docker network ls
echo "===================================================================================="
echo "Network created"
echo "===================================================================================="

#Volume
echo "===================================================================================="
echo "Creating Volume"
echo "===================================================================================="
sudo docker volume create --name dataConfigNetwork
sudo docker volume ls
echo "===================================================================================="
echo "Volume created"
echo "===================================================================================="
# -v dataConfigNetwork:/localNetwork 

#nodes
echo "===================================================================================="
echo "Creating Validator nodes on docker"
echo "===================================================================================="
sudo docker run --net ethnetwork --name validatornode1 --hostname validatornode1 -v dataConfigNetwork:/localNetwork -dit quorum_validator_node 
sudo docker run --net ethnetwork --name validatornode2 --hostname validatornode2 -v dataConfigNetwork:/localNetwork -dit quorum_validator_node 
sudo docker run --net ethnetwork --name validatornode3 --hostname validatornode3 -v dataConfigNetwork:/localNetwork -dit quorum_validator_node

echo "===================================================================================="
echo "Creating General nodes on docker"
echo "===================================================================================="
sudo docker run --net ethnetwork --name generalnode1 --hostname generalnode1 -v dataConfigNetwork:/localNetwork -dit quorum_general_node 
sudo docker run --net ethnetwork --name generalnode2 --hostname generalnode2 -v dataConfigNetwork:/localNetwork -dit quorum_general_node 
sudo docker run --net ethnetwork --name generalnode3 --hostname generalnode3 -v dataConfigNetwork:/localNetwork -dit quorum_general_node  

sudo docker cp ./networkConfiguration  generalnode1:/localNetwork
#sudo docker cp /vagrant/ethereum/configuration  node2:/localNetwork 
#sudo docker cp /vagrant/ethereum/configuration  node3:/localNetwork
echo "===================================================================================="
echo "Nodes on docker created"
echo "===================================================================================="

#client
echo "===================================================================================="
echo "Creating client docker"
echo "===================================================================================="
sudo docker run --name clientquorum --hostname clientquorum --net ethnetwork -dit ethereum_client /bin/bash
echo "===================================================================================="
echo "Client docker Created"
echo "===================================================================================="

#Verificar quais docker estÃƒÂ£o rodando
echo "===================================================================================="
echo "List Docker Running"
echo "===================================================================================="
sudo docker ps
echo "===================================================================================="
echo "List Docker Running"
echo "===================================================================================="
#sudo docker rm node1 node1 node1 client