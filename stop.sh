#!/bin/sh

NAMESPACE="hmcts-local"
SECRET_NAME="hmcts-private-creds"

echo "Deleting ACR token"
kubectl delete secret $SECRET_NAME -n $NAMESPACE

echo "Stopping and removing all containers"
helmfile -n $NAMESPACE destroy
