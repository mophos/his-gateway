option=$1
set -e
if [[ $option =~ ^(help)$ || $option =~ ^(--help)$ ]]; then
        echo "## Install HIS-Gateway ##"
        echo "install.sh for centOS7,CentOS8,Ubuntu.  Other please Manual Install git,docker,docker-compose";
        echo;
        echo "usage: ./install.sh [--help]"
        echo;
        echo -e "help\t list about concept guides"
        exit 1
fi


if  [ "$(uname -a | grep el7)" ] || [ "$(uname -a | grep el8)" ] || [ "$(uname -a | grep Ubuntu)" ]; then
    if  [ "$(uname -a | grep el7)" ]; then
        if ! [ -x "$(command -v git)" ]; then
            echo 'install git'
            sudo yum install -y git
            cd ..
            mv -r his-gateway his-gateway-no-git
            git clone https://github.com/mophos/his-gateway.git
            cd his-gateway
        fi

        # if ! [ -x "$(command -v python)" ]; then
        #     sudo yum install python -y
        # fi

        if ! [ -x "$(command -v docker)" ]; then
            echo 'Installing docker...'
            sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            sudo yum install -y docker-ce docker-ce-cli containerd.io
            echo "Starting docker..."
            sleep 3
            sudo systemctl start docker
            sudo systemctl enable docker
        fi
    elif [ "$(uname -a | grep el8)" ]; then
        if ! [ -x "$(command -v git)" ]; then
            echo 'Installing git...'
            sudo dnf install -y git
            cd ..
            mv -r his-gateway his-gateway-no-git
            git clone https://github.com/mophos/his-gateway.git
            cd his-gateway
        fi

        # if ! [ -x "$(command -v python3)" ]; then
        #     sudo dnf install python3 -y
        # fi

        if ! [ -x "$(command -v docker)" ]; then
            echo 'Installing docker...'
            sudo dnf install -y unzip zip wget dialog git net-tools chrony 
            sudo yum-config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
            sudo dnf install -y --allowerasing docker-ce docker-ce-cli containerd.io
            sudo systemctl start docker
            sudo systemctl enable docker
        fi
    elif [ "$(uname -a | grep Ubuntu)" ]; then
         if ! [ -x "$(command -v git)" ]; then
            echo 'Installing git...'
            sudo apt-get install -y git
            cd ..
            mv -r his-gateway his-gateway-no-git
            git clone https://github.com/mophos/his-gateway.git
            cd his-gateway
        fi

        # if ! [ -x "$(command -v python)" ]; then
        #     sudo apt-get install python -y
        # fi

        if ! [ -x "$(command -v docker)" ]; then
            echo 'Installing docker...'
            sudo apt-get remove docker docker-engine docker.io containerd runc
            sudo apt-get install ca-certificates curl gnupg lsb-release
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update
            sudo apt-get install docker-ce docker-ce-cli containerd.io
        fi
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
    ./load-cert.sh
    echo 'install Git,Docker,Docker-compose success.'
    echo 'run start.sh please.'
else
    echo "Please use install.sh for centOS7,Ubuntu. Please Manual Install git,docker,docker-compose"
fi
