#!/bin/bash
if [ -d "./hisgateway-docker" && -f "./hisgateway-docker/.env" && -f "./cert/version" ]; then
    ./update.sh
    docker-compose -f ./hisgateway-docker/docker-compose.yaml up -d
else
   echo 'install please.'
fi
