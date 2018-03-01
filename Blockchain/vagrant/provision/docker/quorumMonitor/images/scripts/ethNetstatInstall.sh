#!/bin/bash

apt-get update -y
apt-get upgrade -y
apt-get install -y build-essential git nodejs npm cloud-utils

ln -s /usr/bin/nodejs /usr/bin/node

git clone https://github.com/cubedro/eth-netstats
cd eth-netstats
npm install
npm install -g grunt-cli
grunt