#!/bin/bash

az group create -n rg-appservice-test-1 -l westeurope

az appservice plan create --name plan-appservice-test-1 \
  --resource-group rg-appservice-test-1 \
  --sku f1 \
  --is-linux

az webapp list-runtimes

az webapp create -g rg-appservice-test-1 \
  -p plan-appservice-test-1 \
  -n app-sample-test-1 \
  --runtime "DOTNETCORE|3.1"