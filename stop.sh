if [  "$(docker ps -a)" ]; then
  if [[ -d "./hisgateway-docker" && -f "./hisgateway-docker/.env"  ]]; then
        cd hisgateway-docker
        docker-compose down
  else
    echo 'Please confit ENV  ./set-env.sh'
  fi
else
  echo 'Please Start docker'
fi