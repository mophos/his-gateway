if  [ "$(uname -a | grep el7)" ]; then
    if ! [ -x "$(command -v git)" ]; then
        echo 'install git'
        sudo yum install -y git
        cd ..
        mv -r his-gateway his-gateway-no-git
        git clone https://github.com/mophos/his-gateway.git
        cd his-gateway
    fi

    if ! [ -x "$(command -v python)" ]; then
        sudo yum install python -y
    fi

    if ! [ -x "$(command -v docker)" ]; then
        echo 'install docker'
        sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
        sudo yum install -y yum-utils
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install -y docker-ce docker-ce-cli containerd.io
        sudo systemctl start docker
        sudo systemctl enable docker
    fi

    if ! [ -x "$(command -v docker-compose)" ]; then
        echo 'install docker-compose'
        sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi

    if ! [ -d "./hisgateway-docker" ]; then 
        echo 'git clone hisgateway-docker'
        git clone https://github.com/mophos/hisgateway-docker.git
    fi

    ./set-env.sh
    echo 'install Git,Docker,Docker-compose success.'
    echo 'run start.sh please.'
else
    echo "Please use install.sh for centOS7 or Manual Install git,docker,docker-compose"
fi
