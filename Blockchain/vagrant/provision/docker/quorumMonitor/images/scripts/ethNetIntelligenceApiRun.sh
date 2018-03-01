#!/bin/bash

# Example
#./ethNetIntelligenceApiRun.sh root node-app '52.178.180.77' 22001 30303 '52.178.180.77' 'localhost' 3000 password

directoryRoot=$1
monitorAppName=$2
rpcHost=$3
rpcPort=$4
listeningPort=$5
instanceName=$6
websocketServer=$7
websocketPort=$8
websocketSecret=$9

cd ~/bin
cp processes.json processes.json.old
cp /configMonitorTemplate.json processes.json

sed -i "s/\[directoryRoot]/$directoryRoot/g" processes.json
sed -i "s/\[monitorAppName]/$monitorAppName/g" processes.json
sed -i "s/\[rpcHost]/$rpcHost/g" processes.json
sed -i "s/\[rpcPort]/$rpcPort/g" processes.json
sed -i "s/\[listeningPort]/$listeningPort/g" processes.json
sed -i "s/\[instanceName]/$instanceName/g" processes.json
sed -i "s/\[websocketServer]/$websocketServer/g" processes.json
sed -i "s/\[websocketPort]/$websocketPort/g" processes.json
sed -i "s/\[websocketSecret]/$websocketSecret/g" processes.json

cd ~/bin
pm2 start processes.json