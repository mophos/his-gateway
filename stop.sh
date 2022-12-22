if [ "$(docker ps -a)" ]; then
  cd hisgateway-docker
  docker-compose down
else
  echo 'Please Start docker'
fi
