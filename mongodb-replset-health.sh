#!/bin/bash
API_USER="jason.mimick"
API_KEY="a6274075-5a4f-4ee0-b97c-e8a1d65c0e71"
GROUP_ID="58e7e7c19701995e7d9dff42"


printf "Cluster       Status\n"
printf "%-14s %s\n" "-------" "------"

for cluster in Cluster0 free-cluster; do
  CLUSTER_INFO=$(curl --silent --user "${API_USER}:${API_KEY}" \
     --digest "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUP_ID}/clusters/${cluster}")
  #echo "${CLUSTER_INFO}"
  CLUSTER_STATUS=$(echo "${CLUSTER_INFO}" | jq --raw-output '.stateName')
  printf "%-14s %s\n" ${cluster} ${CLUSTER_STATUS}
done
