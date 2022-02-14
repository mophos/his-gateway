option=$1

if [  "$(docker ps -a)" ]; then
    if [[ $option =~ ^(help)$ ]]; then
        echo "option sk = skip update"
        exit 1
    fi

    if [[ -d "./hisgateway-docker" && -f "./hisgateway-docker/.env"  ]]; then
            cd hisgateway-docker
        if [[ $option =~ ^(sk)$ && -f "./cert/version" ]]; then
            docker-compose  up -d
        else
            ./update.sh   
            docker-compose  up -d
        fi
    else
    echo 'Please confit ENV  ./set-env.sh'
    fi
else
    echo 'Plase Start Docker'
fi