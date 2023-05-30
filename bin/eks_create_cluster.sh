#!/usr/bin/env bash

CLUSTER="hello"
REGION="us-west-2"
CLUSTER_NAME="${CLUSTER}.${REGION}.eksctl.io"

echo "Retrieving clusters..."
CLUSTERS=$(kubectl config get-clusters)

echo "Current clusters:"
echo "$CLUSTERS"
echo "Checking for $CLUSTER_NAME..."

EKSCLT_CLUSTER=$(eksctl get cluster --region=${REGION} | grep ${CLUSTER_NAME})

if kubectl config get-clusters | grep -q ${CLUSTER_NAME} || $EKSCLT_CLUSTER; then
    echo
    echo "Cluster '${CLUSTER_NAME}' already exists!"
    echo
    if $EKSCLT_CLUSTER; then
        echo
        echo "Update kubeconfig..."
        aws eks --region ${REGION} update-kubeconfig --name hello
        kubectl config view
    fi
else
    echo
    echo "Creating cluster..."
    ./bin/eksctl create cluster --config-file=hello_cluster.yml
    # Add the newly created EKS cluster to kubeconfig
    aws eks --region ${REGION} update-kubeconfig --name ${CLUSTER}
fi
