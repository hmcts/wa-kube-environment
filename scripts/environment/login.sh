#!/usr/bin/env bash

echo "-> Performing Login"
TOKEN_PRIVATE=$(az acr login --name hmctsprivate --subscription DCD-CNP-PROD --expose-token | jq --raw-output '.accessToken')
TOKEN_PUBLIC=$(az acr login --name hmctspublic --subscription DCD-CNP-PROD --expose-token | jq --raw-output '.accessToken')

 if docker login hmctsprivate.azurecr.io --username=00000000-0000-0000-0000-000000000000 --password=$TOKEN_PRIVATE > /dev/null ; then
     echo "✅  Logged in successfully to hmctsprivate.azurecr.io"
   else
     echo "❌  Something went wrong when performing the log in to hmctsprivate.azurecr.io"
   fi

 if docker login hmctspublic.azurecr.io --username=00000000-0000-0000-0000-000000000000 --password=$TOKEN_PUBLIC > /dev/null ; then
     echo "✅  Logged in successfully to hmctspublic.azurecr.io"
   else
     echo "❌  Something went wrong when performing the log in to hmctspublic.azurecr.io"
   fi
