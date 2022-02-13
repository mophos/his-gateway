#!/bin/bash

if [ -d "./hisgateway-docker" && -f "./hisgateway-docker/.env"]; then
  if ! [ -x "$(command -v curl)" ]; then 
  yum install curl -y
  fi

  if ! [ -x "$(command -v unzip)" ]; then 
  yum install unzip -y
  fi

  set -o allexport; source "./hisgateway-docker/.env"; set +o allexport

  version=`cat ./cert/version`

  response=$(curl --request POST \
    --silent -d \
    --url https://hisgateway.moph.go.th/api/login \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data password=${PASSWORD_ICTPORTAIL} \
    --data username=${EMAIL_ICTPORTAIL}
  )

  token=$( echo $response | python -c "import sys, json; print json.load(sys.stdin)['token']")

  response_check_v=$(curl --request GET \
    --silent -d \
    --url https://hisgateway.moph.go.th/api/api/cert/check \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data token=${token}
    --data version=${version}
  )

  check_v=$( echo $response_check_v | python -c "import sys, json; print json.load(sys.stdin)['ok']")
  if [ $check_v == 'True' ]; then
    response_check=$(curl --request GET \
      --silent -d \
      --url https://hisgateway.moph.go.th/api/api/cert/check \
      --header 'Content-Type: application/x-www-form-urlencoded' \
      --data token=${token}
    )

    check_file=$( echo $response_check | python -c "import sys, json; print json.load(sys.stdin)['ok']")

    if [ $check_file == 'True' ]; then
        echo "DOWNLOAD CERT"
        curl --request GET \
        --url https://hisgateway.moph.go.th/api/api/cert \
        --header 'Content-Type: application/x-www-form-urlencoded' \
        --data token=${token} -o cert.zip
        mkdir cert 
        unzip cert.zip -d cert/
        rm -rf cert.zip
    else 
        echo "ไม่พบไฟล์ cert กรุณาติดต่อเจ้าหน้าที่"
        # echo $check_file
    fi
  fi
else 
  echo 'install please.'
if
