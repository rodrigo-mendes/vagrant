#!/bin/bash

#build Image from dockerfile
IMAGE_NAME="eth_netstat_dashboard"
TAG_NUMBER="1.0"
REPOSITORY_NAME=localhost
REPOSITORY_PORT=5000
#BUILD_DIR=$(pwd)/../client

sudo docker build . -t "${IMAGE_NAME}" -f DockerfileMonitorDashboard --no-cache

#sudo docker tag "${IMAGE_NAME}" "${REPOSITORY_NAME}":"${REPOSITORY_PORT}"/"${IMAGE_NAME}":"${TAG_NUMBER}"
