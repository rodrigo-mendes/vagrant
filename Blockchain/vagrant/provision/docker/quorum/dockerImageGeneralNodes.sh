#!/bin/bash

#Conneting to dockerRegistry(dockerhub)
#sudo docker login --username rokamendes --password Banshee1981 

#build Image from dockerfile
IMAGE_NAME="quorum_general_node"
TAG_NUMBER="1.0"
REPOSITORY_NAME=localhost
REPOSITORY_PORT=5000
#BUILD_DIR=$(pwd)/../node

sudo docker build . -t "${IMAGE_NAME}" -f DockerfileGeneralNodes --no-cache

#sudo docker tag "${IMAGE_NAME}" "${REPOSITORY_NAME}":"${REPOSITORY_PORT}"/"${IMAGE_NAME}":"${TAG_NUMBER}"
