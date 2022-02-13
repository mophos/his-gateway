option=$1
if [[ $option =~ ^(help)$ ]]; then
    echo "option sk = skip update"
    exit 1
fi



if [[ -d "./hisgateway-docker" && -f "./hisgateway-docker/.env"  ]]; then
   if [[ $option =~ ^(sk)$ && -f "./cert/version" ]]; then
        docker-compose -f ./hisgateway-docker/docker-compose.yaml up -d
    else
    ./update.sh   
    docker-compose -f ./hisgateway-docker/docker-compose.yaml up -d
    fi
else
  echo 'Please confit ENV  ./set-env.sh'
fi
