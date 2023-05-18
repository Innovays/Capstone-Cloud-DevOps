#!/usr/bin/env bash
source .env

# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
# Create dockerpath
dockerpath=$DOCKER_USERNAME/$DOCKER_REPOSITORY

# Step 2:
# Authenticate & tag
echo "Docker ID and Image: $dockerpath"
# Loading the .env file for the credentials
docker login --username $DOCKER_USERNAME &&\
# Tag the image
docker tag $DOCKER_TAG:latest $dockerpath:latest  &&\

# Step 3:
# Push image to a docker repository
docker push $dockerpath:latest &&\

# Step 2
# Run the Docker Hub container with kubernetes
kubectl create deployment $DOCKER_TAG --image=$dockerpath:latest --port='5000' &&\

# Step 3:
# List kubernetes pods
sleep 5 &&\
kubectl get pods >>./output_txt_files/kubernetes_out.txt  &&\

# Step 4:
# Get pod name and forward the container port to a host
podname=$(kubectl get pods -o name | awk -F'/' '{print $2}')
# Wait until deployment is running
kubectl rollout status deployment/$DOCKER_TAG >>./output_txt_files/kubernetes_out.txt &&\
# Forward the container port to a host
nohup kubectl port-forward --address 0.0.0.0 $podname 8080:80 >> ./output_txt_files/kubernetes_out.txt 2>&1 &
