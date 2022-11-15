#!/usr/bin/env bash

NAMESPACE="hmcts-local"
SECRET_NAME="hmcts-private-creds"

echo "💣  Deleting ACR token"
kubectl delete secret $SECRET_NAME -n $NAMESPACE

echo "💣  Deleting persistent volume claims"
kubectl delete -n $NAMESPACE pvc --all

echo "💣  Deleting persistentvolumes"
kubectl delete -n $NAMESPACE pv --all

echo "💣  Stopping and removing all containers"
helmfile -n $NAMESPACE destroy
