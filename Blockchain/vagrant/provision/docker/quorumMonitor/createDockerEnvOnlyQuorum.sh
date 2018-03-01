#!/bin/bash

echo "===================================================================================="
echo "Removing docker instances"
echo "===================================================================================="
sudo docker rm -f generalnode1
sudo docker rm -f generalnode2
sudo docker rm -f generalnode3
sudo docker rm -f clientquorum

sudo docker rm -f monitor1
sudo docker rm -f monitor2
sudo docker rm -f monitor3
sudo docker rm -f monitorDashboard
echo "===================================================================================="
echo "Removed docker instance"
echo "===================================================================================="

echo "===================================================================================="
echo "Removing Images"
echo "===================================================================================="
sudo docker rmi -f quorum_general_node
sudo docker rmi -f ethereum_client
sudo docker rmi -f eth_net_intelligence_monitor
sudo docker rmi -f eth_netstat_dashboard
echo "===================================================================================="
echo "Removed Images"
echo "===================================================================================="

echo "===================================================================================="
echo "Creating Images"
echo "===================================================================================="
./images/dockerImageGeneralNodes.sh
./images/dockerImageClient.sh
./images/dockerImageMonitor.sh
./images/dockerImageMonitorDashboard.sh
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
echo "Creating Monitor nodes on docker"
echo "===================================================================================="
sudo docker run --name monitorDashboard --hostname monitorDashboard --ip 172.18.1.10 -p 63000:3000 -p 63001:3001 --net ethnetwork -dit eth_netstat_dashboard 

sudo docker run --name monitor1 --hostname monitor1 --ip 172.18.1.11 -p 13000:3000 -p 13001:3001 --net ethnetwork -dit eth_net_intelligence_monitor /bin/bash
sudo docker exec monitor1 /bin/bash ethNetIntelligenceApiRun.sh root node-app-172.18.2.11 '172.18.2.11' 8545 30303 '172.18.2.11' '172.18.1.10' 3000 password
sudo docker exec monitor1 /bin/bash -c "pm2 show 0"

sudo docker run --name monitor2 --hostname monitor2 --ip 172.18.1.12 -p 23000:3000 -p 23001:3001 --net ethnetwork -dit eth_net_intelligence_monitor /bin/bash
sudo docker exec monitor2 /bin/bash ethNetIntelligenceApiRun.sh root node-app-172.18.2.12 '172.18.2.12' 8545 30303 '172.18.2.12' '172.18.1.10' 3000 password
sudo docker exec monitor2 /bin/bash -c "pm2 show 0"

sudo docker run --name monitor3 --hostname monitor3 --ip 172.18.1.13 -p 33000:3000 -p 33001:3001 --net ethnetwork -dit eth_net_intelligence_monitor /bin/bash
sudo docker exec monitor3 /bin/bash ethNetIntelligenceApiRun.sh root node-app-172.18.2.13 '172.18.2.13' 8545 30303 '172.18.2.13' '172.18.1.10' 3000 password
sudo docker exec monitor3 /bin/bash -c "pm2 show 0"

echo "===================================================================================="
echo "Monitor on docker created"
echo "===================================================================================="

echo "===================================================================================="
echo "Creating General nodes on docker"
echo "===================================================================================="
sudo docker run --net ethnetwork --name generalnode1 --hostname generalnode1 --ip 172.18.2.11 -v dataConfigNetwork:/localNetwork -dit quorum_general_node 
sudo docker run --net ethnetwork --name generalnode2 --hostname generalnode2 --ip 172.18.2.12 -v dataConfigNetwork:/localNetwork -dit quorum_general_node 
sudo docker run --net ethnetwork --name generalnode3 --hostname generalnode3 --ip 172.18.2.13 -v dataConfigNetwork:/localNetwork -dit quorum_general_node  

sudo docker cp ./images/networkConfiguration  generalnode1:/localNetwork
echo "===================================================================================="
echo "Nodes on docker created"
echo "===================================================================================="

#client
echo "===================================================================================="
echo "Creating client docker"
echo "===================================================================================="
sudo docker run --name clientquorum --hostname clientquorum --ip 172.18.4.10 --net ethnetwork -dit ethereum_client /bin/bash
echo "===================================================================================="
echo "Client docker Created"
echo "===================================================================================="

#Verificar quais docker estao rodando
echo "===================================================================================="
echo "List Docker Running"
echo "===================================================================================="
sudo docker ps
echo "===================================================================================="
echo "List Docker Running"
echo "===================================================================================="