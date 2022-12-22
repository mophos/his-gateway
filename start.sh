option=$1
set -e
if [[ $option =~ ^(help)$ || $option =~ ^(--help)$ ]]; then
    echo "## Start HIS-Gateway ##"
    echo
    echo "usage: ./start.sh [--help] [--only]"
    echo
    echo -e "help\t list about concept guides"
    echo -e "only\t start only.(skip update)"
    exit 1
fi

if ! [[ $option =~ ^(help)$ || $option =~ ^(--help)$ || $option =~ ^(--only)$ || $option =~ "" ]]; then
    echo "Not found option"
    ./start.sh --help
    exit 1
fi
if [ "$(docker ps -a)" ]; then
    if [[ $option =~ ^(--only)$ ]]; then
        cd hisgateway-docker
        docker-compose up -d
    else
        ./update.sh
        # docker-compose  up -d
    fi
else
    echo 'Plase Start Docker'
fi
