#!/bin/bash

ACR_NAME=acr-sample
SP_NAME=sp-sample
IMAGE_TAG=acr-sample.azurecr.io/master/my-app:latest
RESOURCE_GROUP_NAME=rg-sample
APP_NAME=my-app
APP_DNS=my-app

ACR_ID=$(az acr show --name $ACR_NAME --query id --output tsv)

ACR_SERVER=$(az acr show --name $ACR_NAME --query loginServer --output tsv)

SP_PASS=$(az ad sp create-for-rbac --name http://$SP_NAME --scopes $ACR_ID --role acrpull --query password --output tsv)

SP_ID=$(az ad sp show --id http://$SP_NAME --query appId --output tsv)

az container create --resource-group $RESOURCE_GROUP_NAME --name $APP_NAME --image $IMAGE_TAG --cpu 1 --memory 1 \
--registry-login-server $ACR_SERVER --registry-username $SP_ID --registry-password $SP_PASS --dns-name-label $APP_DNS --ports 80