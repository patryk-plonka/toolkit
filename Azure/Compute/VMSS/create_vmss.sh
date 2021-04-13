#!/bin/bash

az group create --name rg-vmss-test-1 --location westeurope

az vmss create \
  --resource-group rg-vmss-test-1 \
  --name vmss-sample-test-1 \
  --image UbuntuLTS \
  --upgrade-policy-mode automatic \
  --custom-data cloud-init.yml \
  --admin-username azureuser \
  --generate-ssh-keys

az network lb rule create \
  --resource-group rg-vmss-test-1 \
  --name vmss-sample-test-1VNET \
  --lb-name vmss-sample-test-1LB \
  --backend-pool-name vmss-sample-test-1LBBEPool \
  --backend-port 80 \
  --frontend-ip-name loadBalancerFrontEnd\
  --frontend-port 80 \
  --protocol tcp

az network public-ip show \
    --resource-group rg-vmss-test-1 \
    --name vmss-sample-test-1LBPublicIP \
    --query [ipAddress] \
    --output tsv

az vmss list-instances \
  --resource-group rg-vmss-test-1 \
  --name vmss-sample-test-1 \
  --output table

az vmss show \
    --resource-group rg-vmss-test-1 \
    --name vmss-sample-test-1 \
    --query [sku.capacity] \
    --output table

az vmss list-instance-connection-info \
    --resource-group rg-vmss-test-1 \
    --name vmss-sample-test-1