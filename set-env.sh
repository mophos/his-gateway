MODE=$1
if ! [ -d "./hisgateway-docker" ]; then
    git clone https://github.com/mophos/hisgateway-docker.git
fi
if ! [ -f "./hisgateway-docker/.env" ]  || [[ $MODE =~ ^(set)$ ]]; then
    echo 'Config..'
    echo 'รหัสโรงพยาบาล'
    read -p 'HOSPCODE: ' HOSPCODE
    echo 'ใช้ค่า =1 เปลี่ยนเมื่อโรงพยาบาลมีมากกว่า 1 db ในการส่งข้อมูล'
    read -p 'GROUP: ' GROUP
    # echo 'รหัสของ cert (ในไฟล์ password_xxxxx.txt)'
    # read -p 'PASSWORD: ' PASSWORD
    echo 'ตั้งค่า port ที่จะเปิดเว็บ'
    read -p 'PORT: ' PORT
    echo 'ตั้งค่า SECRET_KEY เป็นอะไรก็ได้ (ex. 123456)'
    read -p 'SECRET_KEY: ' SECRET_KEY
    echo 'ตั้งค่า E-mail ict portail'
    read -p 'E-mail: ' EMAIL_ICTPORTAL
    echo 'ตั้งค่า Password ict portail'
    read -p 'Password: ' PASSWORD_ICTPORTAL

    cat <<EOF >./hisgateway-docker/.env
# แก้ไข 'xxxxx' ให้เป็น รหัสโรงพยาบาล
HOSPCODE=${HOSPCODE}

# 'GROUP=1' เปลี่ยนเมื่อ 1 รพ.สร้างมากกว่า 1 group
GROUP=${GROUP}

# แก้ไข 'PPPPP' ให้เป็น รหัสของ cert (ในไฟล์ 'password_xxxxx.txt')
PASSWORD=PPPPP

# ตั้งค่า 'port' สำหรับเปิดเว็บ
PORT=${PORT}

# path ที่เก็บไฟล์ cert แนะนำให้เอาไว้นอกโฟวเดอร์ hisgateway-docker
PATH_CERT=../cert

PATH_DATA=../data

BROKER_URL=kafka1.moph.go.th:19093

SECRET_KEY=${SECRET_KEY}

EMAIL_ICTPORTAL=${EMAIL_ICTPORTAL}

PASSWORD_ICTPORTAL=${PASSWORD_ICTPORTAL}
EOF
else
    echo 'Set new ENV type "./set-env.sh set"'
fi
