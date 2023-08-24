#!/usr/bin/env bash

NAMESPACE="hmcts-local"
SECRET_NAME="hmcts-private-creds"

echo "ℹ️  Setting up Local development environment"
echo "↪️️  Switching context to minikube"
#Switch to local cluster to avoid attempting to deploy in other clusters
kubectl config use-context minikube

echo "↪️️  Creating $NAMESPACE namespace"
#This might error if namespace already exist, but will not stop the script.
kubectl create namespace $NAMESPACE

echo "↪️  Creating persistent volume"
kubectl apply -f ./charts/pv.yaml -n hmcts-local
echo "↪️  Creating persistent volume claim"
kubectl apply -f ./charts/pvc.yaml -n hmcts-local

echo "↪️  Applying ingress config"
kubectl apply -f ./ingress/ingress.yaml -n hmcts-local
#kubectl patch deployment ingress-nginx-controller --patch "$(cat ./ingress/ingress-patch.yaml)" -n ingress-nginx

echo "↪️  Obtaining ACR token"
az login
az account set -s 8999dec3-0104-4a27-94ee-6588559729d1
TOKEN=$(az acr login --name hmctsprivate --subscription DCD-CNP-PROD --expose-token | jq --raw-output '.accessToken')

echo "↪️  Saving Token as secret"
kubectl create secret docker-registry $SECRET_NAME \
  --docker-server=hmctsprivate.azurecr.io \
  --docker-username=00000000-0000-0000-0000-000000000000 \
  --docker-password=$TOKEN \
  -n $NAMESPACE

echo "↪️  Starting deployments"
helmfile -n hmcts-local sync
