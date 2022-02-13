if [ -z "$1" ]; then
    echo "Argument <connect|api|basic|nginx> is required!!!"
    exit 1
fi

MODE=$1

if [[ $MODE =~ ^(connect)$ ]]; 
then
     docker logs connect -f --tail 100
fi
if [[ $MODE =~ ^(api)$ ]]; 
then
     docker logs hisgateway-api -f --tail 100
fi
if [[ $MODE =~ ^(basic)$ ]]; 
then
     docker logs history-api -f --tail 100
fi
if [[ $MODE =~ ^(nginx)$ ]]; 
then
     docker logs nginx -f --tail 100
fi
