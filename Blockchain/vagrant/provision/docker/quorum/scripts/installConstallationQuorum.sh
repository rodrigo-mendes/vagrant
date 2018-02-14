#!/bin/bash

set -e

#INSTALACION CONSTELLATION 0.2.0
wget -q https://github.com/jpmorganchase/constellation/releases/download/v0.2.0/constellation-0.2.0-ubuntu1604.tar.xz 
unxz constellation-0.2.0-ubuntu1604.tar.xz 
tar -xf constellation-0.2.0-ubuntu1604.tar
 cp constellation-0.2.0-ubuntu1604/constellation-node /usr/local/bin &&  chmod 0755 /usr/local/bin/constellation-node
 rm -rf constellation-0.2.0-ubuntu1604.tar.xz constellation-0.2.0-ubuntu1604.tar constellation-0.2.0-ubuntu1604

#INSTALACION DE QUORUM
git clone https://github.com/jpmorganchase/quorum.git

cd quorum && git checkout a6f117d13818d3e685181533404297ff61dbbd42 && make all &&  cp build/bin/geth /usr/local/bin && cp build/bin/bootnode /usr/local/bin

cd ..
rm -rf constellation-0.2.0-ubuntu1604.tar.xz constellation-0.2.0-ubuntu1604.tar constellation-0.2.0-ubuntu1604 quorum

# install Porosity
#echo "Installing POROSITY"
#wget -q https://github.com/jpmorganchase/quorum/releases/download/v1.2.0/porosity
#mv porosity /usr/local/bin
#chmod 0755 /usr/local/bin/porosity

set +e