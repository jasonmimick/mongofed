#!/bin/bash


az group create --location eastus --name mongofed

for region in eastus japanwest francecentral; do
  az aks create --resource-group ${RESOURCE_GROUP} \
                --location ${region} \
                --kubernetes-version 1.11.2 \
                --name "cluster-${region}" 
