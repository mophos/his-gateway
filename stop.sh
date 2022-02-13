if [  "$(docker ps -a)" ]; then
  if [[ -d "./hisgateway-docker" && -f "./hisgateway-docker/.env"  ]]; then
    if [[ $option =~ ^(sk)$ && -f "./cert/version" ]]; then
          docker-compose -f ./hisgateway-docker/docker-compose.yaml down
      fi
  else
    echo 'Please confit ENV  ./set-env.sh'
  fi
else
  echo 'Please Start docker'
fi