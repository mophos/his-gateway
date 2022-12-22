if [ -z "$1" ]; then
    echo "Argument <api> is required!!!"
    exit 1
fi

MODE=$1

if [[ $MODE =~ ^(connect)$ ]]; 
then
     docker logs gw-api -f --tail 100
fi
