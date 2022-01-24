#!/bin/bash
if [ -d "./cert" ]; then
    if ! [ -x "$(command -v git)" ]; then
        echo 'not git'
        sudo yum install -y git
    fi

    if ! [ -x "$(command -v docker)" ]; then
        echo 'not docker'
        sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
        sudo yum install -y yum-utils
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install -y docker-ce docker-ce-cli containerd.io
        sudo systemctl start docker
        sudo systemctl enable docker
    fi

    if ! [ -x "$(command -v docker-compose)" ]; then
        echo 'not docker'
        sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi

    if ! [ -d "./hisgateway-docker" ]; then 
        echo 'not hisdoc'
        git clone https://github.com/mophos/hisgateway-docker.git
    fi

    if ! [ -f "./hisgateway-docker/.env" ]; then 
        echo 'not hisdoc'
        echo 'รหัสโรงพยาบาล'
        read -p 'HOSPCODE: ' HOSPCODE
        echo 'ใช้ค่า =1 เปลี่ยนเมื่อโรงพยาบาลมีมากกว่า 1 db ในการส่งข้อมูล'
        read -p 'GROUP: ' GROUP
        echo 'รหัสของ cert (ในไฟล์ password_xxxxx.txt)'
        read -p 'PASSWORD: ' PASSWORD
        echo 'ตั้งค่า port ที่จะเปิดเว็บ'
        read -p 'PORT: ' PORT
        echo 'ตั้งค่า SECRET_KEY เป็นอะไรก็ได้ (ex. 123456)'
        read -p 'SECRET_KEY: ' SECRET_KEY

        cat << EOF > ./hisgateway-docker/.env
    # แก้ไข 'xxxxx' ให้เป็น รหัสโรงพยาบาล
    HOSPCODE=${HOSPCODE}

    # 'GROUP=1' เปลี่ยนเมื่อ 1 รพ.สร้างมากกว่า 1 group
    GROUP=${GROUP}

    # แก้ไข 'PPPPP' ให้เป็น รหัสของ cert (ในไฟล์ 'password_xxxxx.txt')
    PASSWORD=${PASSWORD}

    # ตั้งค่า 'port' สำหรับเปิดเว็บ
    PORT=${PORT}

    # path ที่เก็บไฟล์ cert แนะนำให้เอาไว้นอกโฟวเดอร์ hisgateway-docker
    PATH_CERT=../cert

    PATH_DATA=../data

    BROKER_URL=kafka1.moph.go.th:19093

    SECRET_KEY=${SECRET_KEY}
EOF
     fi


    docker-compose -f ./hisgateway-docker/docker-compose.yaml up -d 
else 
    echo 'ไม่พบไฟล์ cert โหลด ได้ที่ https://hisgateway.moph.go.th/homepage (ปุ่ม Download Certificate)'
fi