if ! [ "$(git remote -v)" ]; then
    cd ..
    rm -rf ../his-gateway-no-git
    mv his-gateway his-gateway-no-git
    git clone https://github.com/mophos/his-gateway.git
    cp -r his-gateway-no-git/cert ./his-gateway/.
    cp -r his-gateway-no-git/data ./his-gateway/.
    cp -r his-gateway-no-git/hisgateway-docker ./his-gateway/.
    cd his-gateway
fi

./load-cert.sh
if [[ -d './hisgateway-docker' && -f './hisgateway-docker/docker-compose.yaml' ]]; then
    git checkout -- .
    version_old=`cat ./script.version`
    git pull
    version_new=`cat ./script.version`
    if  ! [[ $version_old == $version_new ]]; then
        ./run-after-update.sh $version_old
    fi
    cd hisgateway-docker
    docker-compose down
    git checkout -- .
    git pull
    docker pull mophos/hisgateway-client-web
    docker pull mophos/hisgateway-client-api
    docker pull mophos/hisgateway-history-api
    docker-compose up -d
    cd ..
else
    echo 'git clone hisgateway-docker'  
    git clone https://github.com/mophos/hisgateway-docker.git
fi