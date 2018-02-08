#!/bin/bash

$WORKDIR=/blockchainData/qdata
#Create name based on IP for a keyStore 
constellation-node --workdir=$WORKDIR --generatekeys=$(hostname -i) & wait $!

nohup constellation-node $(hostname -i).conf 2>> $WORKDIR/logs/constellation-$(hostname -i).log &


PRIVATE_CONFIG=$(hostname -i).conf nohup geth --datadir $WORKDIR $GLOBAL_ARGS --permissioned --rpcport 22000 --port 21000 --unlock 0 2>>qdata/logs/1.log &
PRIVATE_CONFIG=$(hostname -i).conf nohup geth --verbosity 2 --datadir=/blockchainData/data --networkid 99 --port 30303 --rpc -rpcport 8545 --etherbase "0x0000000000000000000000000000000000000000" console --rpcaddr "0.0.0.0" --rpccorsdomain "*" --permissioned 2>> $WORKDIR/logs/1.log &