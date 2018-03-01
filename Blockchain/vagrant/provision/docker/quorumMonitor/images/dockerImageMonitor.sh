#!/bin/bash

#build Image from dockerfile
IMAGE_NAME="eth_net_intelligence_monitor"
TAG_NUMBER="1.0"
REPOSITORY_NAME=localhost
REPOSITORY_PORT=5000
#BUILD_DIR=$(pwd)/../client

sudo docker build -t "${IMAGE_NAME}" --file="/vagrant/provision/docker/quorumMonitor/images/DockerfileMonitor" --no-cache /vagrant/provision/docker/quorumMonitor/images/

#sudo docker tag "${IMAGE_NAME}" "${REPOSITORY_NAME}":"${REPOSITORY_PORT}"/"${IMAGE_NAME}":"${TAG_NUMBER}"
