version_old=$1
version_new=`cat ./script.version`
if  [[ $version_new != "20221215" ]]; then
    docker stop connect
    docker stop hisgateway-web
    docker stop hisgateway-api
    docker stop history-api
    docker stop nginx

    docker rmi mophos/hisgateway-client-web
    docker rmi mophos/hisgateway-client-api
    docker rmi mophos/hisgateway-history-api
    docker rmi debezium/connect:1.7
    docker network rm gw-network

    echo " new HISGW Version minimal"
    exit 1
fi
