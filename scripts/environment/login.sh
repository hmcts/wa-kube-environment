#!/usr/bin/env bash

echo "-> Performing Login"
az login
az account set -s 8999dec3-0104-4a27-94ee-6588559729d1
TOKEN=$(az acr login --name hmctsprivate --subscription DCD-CNP-PROD --expose-token | jq --raw-output '.accessToken')

 if docker login hmctsprivate.azurecr.io --username=00000000-0000-0000-0000-000000000000 --password=$TOKEN > /dev/null ; then
     echo "✅  Logged in successfully to hmctsprivate.azurecr.io"
   else
     echo "❌  Something went wrong when performing the log in to hmctsprivate.azurecr.io"
   fi

 if docker login hmctspublic.azurecr.io --username=00000000-0000-0000-0000-000000000000 --password=$TOKEN_PUBLIC > /dev/null ; then
     echo "✅  Logged in successfully to hmctspublic.azurecr.io"
   else
     echo "❌  Something went wrong when performing the log in to hmctspublic.azurecr.io"
   fi
