#!/usr/bin/env bash

CLUSTER="hello"
REGION="us-west-2"
CLUSTER_NAME="${CLUSTER}.${REGION}.eksctl.io"

kubectl config get-clusters
echo
echo $CLUSTER_NAME
echo
kubectl config get-clusters | grep -q ${CLUSTER_NAME}
echo
eksctl get cluster --region=${REGION}
echo 
eksctl get cluster --region=${REGION} | grep -q ${CLUSTER_NAME}
echo

if kubectl config get-clusters | grep -q ${CLUSTER_NAME} || eksctl get cluster --region=${REGION} | grep -q ${CLUSTER_NAME}; then
    echo
    echo "Cluster '${CLUSTER_NAME}' already exists!"
    echo
else
    echo
    echo "Creating cluster..."
    ./bin/eksctl create cluster --config-file=hello_cluster.yml
fi
