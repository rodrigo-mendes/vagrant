#!/bin/bash

set -e

#INSTALACION GETH
add-apt-repository -y ppa:ethereum/ethereum &&  add-apt-repository -y ppa:ethereum/ethereum-dev &&  apt-get update &&  apt-get install -y geth

set +e