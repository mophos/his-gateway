if [ $1 == "help" ]; then
    echo "option sk = skip update"
    exit 1
fi

option=$1


if [[ -d "./hisgateway-docker" && -f "./hisgateway-docker/.env" && -f "./cert/version" ]]; then
   if [[ $option =~ ^(sk)$ ]]; 
    then
    docker-compose -f ./hisgateway-docker/docker-compose.yaml up -d
    else
    ./update.sh   
    docker-compose -f ./hisgateway-docker/docker-compose.yaml up -d
    fi
else
   echo 'install please.'
fi
