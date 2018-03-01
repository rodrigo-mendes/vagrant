#!/bin/bash

set -e

apt-get update && apt-get install -y

#INSTALACION DE LIBRERIAS
apt-get install -y software-properties-common unzip wget git make gcc libsodium-dev build-essential libdb-dev zlib1g-dev libtinfo-dev sysvbanner wrk psmisc apt-utils expect

set +e