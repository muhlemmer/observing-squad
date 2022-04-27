#!/bin/bash
set -e

#Color to the people
CYAN='\x1B[0;36m'
GREEN='\x1B[0;32m'
NC='\x1B[0m'

declare -a NODES=("0" "1" "2" "metachain")

STACK_FOLDER=~/MyObservingSquad

#Create the folder structure for the observer stack
mkdir -p ${STACK_FOLDER}/{node-0,node-1,node-2,node-metachain}

#Start the stack
echo -e
echo -e "${GREEN}--> Starting the Observer+Proxy Stack...${NC}"
echo -e
docker-compose --env-file .env up -d
