#!/bin/bash

rm -f /localNetwork/work/static-nodes.lock
rm -f /localNetwork/work/static-nodes.created
rm -f /localNetwork/work/static-nodes.json

mkdir /localNetwork/work
mkdir /localNetwork/work/lock
mkdir /localNetwork/work/enode

mkdir /blockchainData

mkdir /blockchainData/data
mkdir /blockchainData/data/logs

mkdir /blockchainData/qdata
mkdir /blockchainData/qdata/logs

$WORKDIRETH=/blockchainData/data
$WORKDIRQUORUM=/blockchainData/qdata

cp /localNetwork/networkConfiguration/genesis.json /blockchainData/genesis.json

cp /localNetwork/networkConfiguration/template.conf /blockchainData/$(hostname -i).conf

touch /localNetwork/work/lock/$(hostname -i).lock

geth --datadir=$WORKDIRETH init /blockchainData/genesis.json & wait $!

geth --verbosity 1 --networkid 99 --datadir=$WORKDIRETH console --exec admin.nodeInfo.enode > /localNetwork/work/enode/$(hostname -i) & wait $!
sed -i "s/\[::]/$(hostname -i)/g" /localNetwork/work/enode/$(hostname -i)
sed -i "s/\:30303/:30303?discport=0/g" /localNetwork/work/enode/$(hostname -i) & wait $!

rm -f /localNetwork/work/lock/$(hostname -i).lock

while [ $(ls /localNetwork/work/lock 2> /dev/null | wc -l) != "0" ] 
do 
	sleep 2
done

if [ -e /localNetwork/work/static-nodes.lock ]
then
	while [ -e /localNetwork/work/static-nodes.lock ]
	do
		sleep 2
	done
else
	if [ ! -e /localNetwork/work/static-nodes.created ]
    then	
		touch /localNetwork/work/static-nodes.lock
		touch /localNetwork/work/static-nodes.json

		echo '[' >> /localNetwork/work/static-nodes.json
		for f in /localNetwork/work/enode/* 
		do
		  echo $(cat $f) >> /localNetwork/work/static-nodes.json & wait $!
		  rm -f "$f" & wait $!
		  if [ ! $(ls /localNetwork/work/enode 2> /dev/null | wc -l) -eq "0" ]
		  then
			 echo "," >> /localNetwork/work/static-nodes.json & wait $!		 
		  fi
		done
		
		echo ']' >> /localNetwork/work/static-nodes.json & wait $!
		rm -f /localNetwork/work/static-nodes.lock & wait $!		
		touch /localNetwork/work/static-nodes.created & wait $!
	fi
fi

cp /localNetwork/work/static-nodes.json $WORKDIRETH/static-nodes.json
#All nodes are permissoned
cp /localNetwork/work/static-nodes.json $WORKDIRETH/permissioned-nodes.json
wait

#Create name based on IP for a keyStore 
constellation-node --workdir=$WORKDIRQUORUM --generatekeys=$(hostname -i) & wait $!

sed -i 's/token/'"$(hostname -i)"'/g' /blockchainData/$(hostname -i).conf & wait $!
nohup constellation-node /blockchainData/$(hostname -i).conf 2>> $WORKDIRQUORUM/logs/constellation-$(hostname -i).log &

#background
#PRIVATE_CONFIG=$(hostname -i).conf nohup geth --verbosity 2 --datadir=$WORKDIRETH --networkid 99 --port 30303 --rpc -rpcport 8545 --etherbase "0x0000000000000000000000000000000000000000" console --rpcaddr "0.0.0.0" --rpccorsdomain "*" --permissioned 2>> $WORKDIRETH/logs/1.log

PRIVATE_CONFIG=/blockchainData/$(hostname -i).conf geth --verbosity 2 --datadir=$WORKDIRETH --networkid 99 --port 30303 --rpc -rpcport 8545 --etherbase "0x0000000000000000000000000000000000000000" console --rpcaddr "0.0.0.0" --rpccorsdomain "*" --permissioned