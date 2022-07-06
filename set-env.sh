option=$1
if [[ $option =~ ^(help)$ || $option =~ ^(--help)$ ]]; then
        echo "## Set config HIS-Gateway ##"
        echo;
        echo "usage: ./set-env.sh [--help] [--show] [--force]"
        echo;
        echo -e "help\t list about concept guides"
        echo -e "show\t show config"
        echo -e "force\t force set config"
        exit 1
fi

if [[ $option =~ ^(show)$ || $option =~ ^(--show)$ ]]; then
        if  [ -f "./hisgateway-docker/.env" ] ; then
            cat ./hisgateway-docker/.env
        else
            echo "No set config.Please ./set-env.sh"
        fi
        exit 1
fi

if ! [ -d "./hisgateway-docker" ]; then
    git clone https://github.com/mophos/hisgateway-docker.git
fi
if ! [ -f "./hisgateway-docker/.env" ]  || [[ $option =~ ^(set)$ ]] || [[ $option =~ ^(--force)$ ]]; then
    if [ -f "./hisgateway-docker/.env" ]; then
        hospcode=`sed '/^HOSPCODE=/!d;' hisgateway-docker/.env | awk -F '=' '{print $2}'`
        group=`sed '/^GROUP=/!d;' hisgateway-docker/.env | awk -F '=' '{print $2}'`
        port=`sed '/^PORT=/!d;' hisgateway-docker/.env | awk -F '=' '{print $2}'`
        secretkey=`sed '/^SECRET_KEY=/!d;' hisgateway-docker/.env | awk -F '=' '{print $2}'`
        email=`sed '/^EMAIL_ICTPORTAL=/!d;' hisgateway-docker/.env | awk -F '=' '{print $2}'`
        password=`sed '/^PASSWORD=/!d;' hisgateway-docker/.env | awk -F '=' '{print $2}'`
        
    else
        hospcode="12345"
        group="1"
        port="80"
        secretkey="$(echo $(date +%s) | md5sum | head -c 20; echo;)"
        email=""
        password=""
    fi
    echo 'Config..'
    echo 'รหัสโรงพยาบาล'
    read -p "HOSPCODE (defalut: $hospcode): " HOSPCODE
    echo 'ใช้ค่า =1 เปลี่ยนเมื่อโรงพยาบาลมีมากกว่า 1 db ในการส่งข้อมูล'
    read -p "GROUP (defalut: $group): " GROUP
    # echo 'รหัสของ cert (ในไฟล์ password_xxxxx.txt)'
    # read -p 'PASSWORD: ' PASSWORD
    echo 'ตั้งค่า port ที่จะเปิดเว็บ'
    read -p "PORT (defalut: $port): " PORT
    echo 'ตั้งค่า SECRET_KEY เป็นอะไรก็ได้ (ex. 123456)'
    read -p "SECRET_KEY (defalut: $secretkey): " SECRET_KEY
    read -p "E-mail ict portal: (defalut: $email)" EMAIL_ICTPORTAL
    # echo 'ตั้งค่า Password ict portal'
    # read -p 'Password: ' PASSWORD_ICTPORTAL

    HOSPCODE="${HOSPCODE:=`echo $hospcode`}"
    GROUP="${GROUP:=`echo $group`}"
    PORT="${PORT:=`echo $port`}"
    SECRET_KEY="${SECRET_KEY:=`echo $secretkey`}"
    EMAIL_ICTPORTAL="${EMAIL_ICTPORTAL:=`echo $email`}"


    cat <<EOF >./hisgateway-docker/.env
# แก้ไข 'xxxxx' ให้เป็น รหัสโรงพยาบาล
HOSPCODE=${HOSPCODE}

# group เปลี่ยนเมื่อติดตั้งหลายเครื่องหรือต้องการเปลี่ยน config
GROUP=${GROUP}

# แก้ไข 'PPPPP' ให้เป็น รหัสของ cert (ในไฟล์ 'password_xxxxx.txt')
PASSWORD=${password}

# ตั้งค่า 'port' สำหรับเปิดเว็บ
PORT=${PORT}

# path ที่เก็บไฟล์ cert แนะนำให้เอาไว้นอกโฟวเดอร์ hisgateway-docker
PATH_CERT=../cert

PATH_DATA=../data

PATH_DNS=./config/resolv.conf

BROKER_URL=broker1.kafka1.moph.go.th:19093,broker2.kafka1.moph.go.th:19093,broker3.kafka1.moph.go.th:19093,broker4.kafka1.moph.go.th:19093,broker5.kafka1.moph.go.th:19093,broker6.kafka1.moph.go.th:19093,broker7.kafka1.moph.go.th:19093,broker8.kafka1.moph.go.th:19093,broker9.kafka1.moph.go.th:19093

SECRET_KEY=${SECRET_KEY}

EMAIL_ICTPORTAL=${EMAIL_ICTPORTAL}

EOF
echo;
# echo "Please Open firewall for open website."
# echo;
# echo "Ex. \tfirewall-cmd --permanent --add-port=${PORT}/tcp"
# echo "\tfirewall-cmd --reload"
else
    echo 'Set new ENV type "./set-env.sh --force"'
fi
