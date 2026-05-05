#!/usr/bin/env bash

echo "-> Performing Login"
az login
az account set -s 8999dec3-0104-4a27-94ee-6588559729d1
TOKEN=$(az acr login --name hmctsprod --subscription DCD-CNP-PROD --expose-token | jq --raw-output '.accessToken')

 if docker login hmctsprod.azurecr.io --username=00000000-0000-0000-0000-000000000000 --password=$TOKEN_PRIVATE > /dev/null ; then
     echo "✅  Logged in successfully to hmctsprod.azurecr.io"
   else
     echo "❌  Something went wrong when performing the log in to hmctsprod.azurecr.io"
   fi

 if docker login hmctsprod.azurecr.io --username=00000000-0000-0000-0000-000000000000 --password=$TOKEN_PUBLIC > /dev/null ; then
     echo "✅  Logged in successfully to hmctsprod.azurecr.io"
   else
     echo "❌  Something went wrong when performing the log in to hmctsprod.azurecr.io"
   fi
