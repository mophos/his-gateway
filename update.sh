if ! [" $(git remote -v)" ]; then
    cd ..
    rm -rf ../his-gateway-no-git
    mv his-gateway his-gateway-no-git
    git clone https://github.com/mophos/his-gateway.git
    cp -r his-gateway-no-git/cert ./his-gateway/.
    cp -r his-gateway-no-git/data ./his-gateway/.
    cp -r his-gateway-no-git/hisgateway-docker ./his-gateway/.
fi

./load_cert.sh
if [[ -d './hisgateway-docker' && -f './hisgateway-docker/docker-compose.yaml' ]]; then
    # git checkout -- .
    git pull
    docker-compose -f ./hisgateway-docker/docker-compose.yaml down
    git -C ./hisgateway-docker pull
    docker pull mophos/hisgateway-client-web
    docker pull mophos/hisgateway-client-api
    docker pull mophos/hisgateway-history-api
    docker-compose -f ./hisgateway-docker/docker-compose.yaml up -d
else
    echo 'git clone hisgateway-docker'  
    git clone https://github.com/mophos/hisgateway-docker.git
fi
