#!/bin/bash

echo "===================================================================================="
echo "Creating Images"
echo "===================================================================================="
./dockerImageNodes.sh
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
echo "Creating nodes on docker"
echo "===================================================================================="
sudo docker run --net ethnetwork --name node1 --hostname node1 -v dataConfigNetwork:/localNetwork -dit ethereum_node  /bin/bash 
sudo docker run --net ethnetwork --name node2 --hostname node2 -v dataConfigNetwork:/localNetwork -dit ethereum_node /bin/bash 
sudo docker run --net ethnetwork --name node3 --hostname node3 -v dataConfigNetwork:/localNetwork -dit ethereum_node  /bin/bash 

sudo docker cp ./networkConfiguration  node1:/localNetwork
#sudo docker cp /vagrant/ethereum/configuration  node2:/localNetwork 
#sudo docker cp /vagrant/ethereum/configuration  node3:/localNetwork
echo "===================================================================================="
echo "Nodes on docker created"
echo "===================================================================================="

#client
echo "===================================================================================="
echo "Creating client docker"
echo "===================================================================================="
sudo docker run --name client --hostname client --net ethnetwork -dit ethereum_client /bin/bash
echo "===================================================================================="
echo "Client docker Created"
echo "===================================================================================="

#Verificar quais docker estÃ£o rodando
echo "===================================================================================="
echo "List Docker Running"
echo "===================================================================================="
sudo docker ps
echo "===================================================================================="
echo "List Docker Running"
echo "===================================================================================="
#sudo docker rm node1 node1 node1 client