#!/usr/bin/env bash
source .env
## Complete the following steps to get Docker running locally

# Step 1:
# Build image and add a descriptive tag
docker build --tag=$DOCKER_TAG:latest . &&\

# Step 2: 
# List docker images
docker image ls &&\

# Step 3: 
# Run flask app
docker run -p 80:80 $DOCKER_TAG
