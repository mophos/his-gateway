#!/bin/bash
./load_cert.sh
if [ -d './hisgateway-docker'] then
    git checkout -- .
    git pull
    docker-compose -f ./hisgateway-docker/docker-compose.yaml down
    git -C ./hisgateway-docker pull
    docker pull mophos/hisgateway-client-web
    docker pull mophos/hisgateway-client-api
    docker pull mophos/hisgateway-history-api
    docker-compose -f ./hisgateway-docker/docker-compose.yaml up -d
fi
