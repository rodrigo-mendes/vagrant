#!/bin/bash

set -e

#INSTALACION ETHEREUM
add-apt-repository -y ppa:ethereum/ethereum &&  add-apt-repository -y ppa:ethereum/ethereum-dev &&  apt-get update &&  apt-get install -y solc

set +e