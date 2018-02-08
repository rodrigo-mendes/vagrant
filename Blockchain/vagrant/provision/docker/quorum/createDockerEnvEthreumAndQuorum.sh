#!/bin/bash

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
sudo docker run --net ethnetwork --name validatornode4 --hostname validatornode4 -v dataConfigNetwork:/localNetwork -dit quorum_validator_node

echo "===================================================================================="
echo "Creating General nodes on docker"
echo "===================================================================================="
sudo docker run --net ethnetwork --name generalnode1 --hostname generalnode1 -v dataConfigNetwork:/localNetwork -dit quorum_general_node 
sudo docker run --net ethnetwork --name generalnode2 --hostname generalnode2 -v dataConfigNetwork:/localNetwork -dit quorum_general_node 
sudo docker run --net ethnetwork --name generalnode3 --hostname generalnode3 -v dataConfigNetwork:/localNetwork -dit quorum_general_node  

sudo docker cp ./networkConfiguration  generalnode1:/localNetwork
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