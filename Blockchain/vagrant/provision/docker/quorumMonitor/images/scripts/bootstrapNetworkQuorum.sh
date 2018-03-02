#!/bin/bash

rm -f /localNetwork/work/static-nodes.lock
rm -f /localNetwork/work/static-nodes.created
rm -f /localNetwork/work/static-nodes.json

mkdir /localNetwork/work
mkdir /localNetwork/work/{lock,enode}

mkdir /blockchainData
mkdir /blockchainData/data
mkdir /blockchainData/data/logs
mkdir /blockchainData/data/constellation
mkdir /blockchainData/data/constellation/{data,logs}
mkdir /blockchainData/data/constellation/data/keystore

cp /localNetwork/networkConfiguration/genesis.json /blockchainData/genesis.json

touch /localNetwork/work/lock/$(hostname -i).lock

geth account new --password passwordfile.pass --datadir=/blockchainData/data/

geth --datadir=/blockchainData/data init /blockchainData/genesis.json & wait $!

geth --verbosity 1 --networkid 99 --datadir=/blockchainData/data console --exec admin.nodeInfo.enode > /localNetwork/work/enode/$(hostname -i) & wait $!
sed -i "s/\[::]/$(hostname -i)/g" /localNetwork/work/enode/$(hostname -i)
sed -i "s/30303/30303\?discport=0\&raftport=50400/g" /localNetwork/work/enode/$(hostname -i) & wait $!

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

cp /localNetwork/work/static-nodes.json /blockchainData/data/static-nodes.json

#All nodes are permissoned
cp /localNetwork/work/static-nodes.json /blockchainData/data/permissioned-nodes.json
#sed -i "s/\:30303?discport=0/:30303/g" /blockchainData/data/permissioned-nodes.json & wait $!

cp /localNetwork/networkConfiguration/template.conf /blockchainData/data/constellation/$(hostname -i).conf
sed -i 's/token/'"$(hostname -i)"'/g' /blockchainData/data/constellation/$(hostname -i).conf
#Create name based on IP for a keyStore 
cd /blockchainData/data/constellation/data/keystore
echo -e "" >> /blockchainData/data/constellation/data/passwords.txt
#constellation-node --generatekeys=$(hostname -i) --passwords=/blockchainData/data/constellation/data/passwords.txt 
expect -f /generateQuorumKeyStores.exp $(hostname -i)
cd /

sleep 5
nohup constellation-node /blockchainData/data/constellation/$(hostname -i).conf 2>> /blockchainData/data/constellation/logs/constellation-$(hostname -i).log & 
sleep 30

if [[ ! -f "permissioned-nodes.json" ]]; then
    # Esto es necesario por un bug de Quorum https://github.com/jpmorganchase/quorum/issues/225
    ln -s /blockchainData/data/permissioned-nodes.json permissioned-nodes.json
fi

PRIVATE_CONFIG=/blockchainData/data/constellation/$(hostname -i).conf geth --verbosity 3 --mine --minerthreads=1 --identity $(hostname -i) --datadir=/blockchainData/data/ --networkid 99 --permissioned --emitcheckpoints --port 30303 --rpc --rpcapi "admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum" --rpcport 8545 --etherbase 0 --unlock 0 console --rpcaddr "0.0.0.0" --rpccorsdomain "*" --password passwordfile.pass --raft