#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`
source .env

# Step 1:
# Create dockerpath
dockerpath=$DOCKER_USERNAME/$DOCKER_REPOSITORY 

# Step 2:  
# Authenticate & tag
echo "Docker ID and Image: $dockerpath"

# Loading the .env file for the credentials
docker login --username $DOCKER_USERNAME &&\
docker tag $DOCKER_TAG:latest $dockerpath:latest &&\

# Step 3:
# Push image to a docker repository
docker push $dockerpath:latest 
