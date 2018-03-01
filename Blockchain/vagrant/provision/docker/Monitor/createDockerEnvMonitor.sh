#!/bin/bash

echo "===================================================================================="
echo "Removing docker instances"
echo "===================================================================================="
sudo docker rm -f monitor
sudo docker rm -f monitorDashboard
echo "===================================================================================="
echo "Removed docker instance"
echo "===================================================================================="

echo "===================================================================================="
echo "Removing Images"
echo "===================================================================================="
sudo docker rmi -f eth_net_intelligence_monitor
sudo docker rmi -f eth_netstat_dashboard
echo "===================================================================================="
echo "Removed Images"
echo "===================================================================================="

echo "===================================================================================="
echo "Creating Images"
echo "===================================================================================="
./dockerImageMonitor.sh
./dockerImageMonitorDashboard.sh
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

#nodes
echo "===================================================================================="
echo "Creating Monitor nodes on docker"
echo "===================================================================================="
sudo docker run --name monitorDashboard --hostname monitorDashboard -p 23000:3000 -p 23001:3001 --net ethnetwork -dit eth_netstat_dashboard 

sudo docker run --name monitor --hostname monitor -p 13000:3000 -p 13001:3001 --net ethnetwork -dit eth_net_intelligence_monitor /bin/bash
sudo docker exec monitor /bin/bash ethNetIntelligenceApiRun.sh
sudo docker exec monitor /bin/bash -c "pm2 show 0"

echo "===================================================================================="
echo "Monitor on docker created"
echo "===================================================================================="

#Verificar quais docker estao rodando
echo "===================================================================================="
echo "List Docker Running"
echo "===================================================================================="
sudo docker ps
echo "===================================================================================="
echo "List Docker Running"
echo "===================================================================================="