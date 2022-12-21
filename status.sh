if [  "$(docker ps -a)" ]; then
    docker ps -a
else
    echo 'Plase Start Docker...'
fi