option=$1
if [[ $option =~ ^(help)$ ]]; then
    echo "option sk = skip update"
    exit 1
fi



if [[ -d "./hisgateway-docker" && -f "./hisgateway-docker/.env" && -f "./cert/version" ]]; then
   if [[ $option =~ ^(sk)$ ]]; 
    then
    docker-compose -f ./hisgateway-docker/docker-compose.yaml up -d
    else
    ./update.sh   
    docker-compose -f ./hisgateway-docker/docker-compose.yaml up -d
    fi
else
  ./set-env.sh
  ./start.sh
fi
