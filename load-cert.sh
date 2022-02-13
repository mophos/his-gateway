echo 'Start Download Certificate...'
if [[ -d "./hisgateway-docker"  &&  -f "./hisgateway-docker/.env" ]]; then
  if ! [ -x "$(command -v curl)" ]; then 
    yum install curl -y
  fi

  if ! [ -x "$(command -v unzip)" ]; then 
    yum install unzip -y
  fi

  set -o allexport; source "./hisgateway-docker/.env"; set +o allexport



  response=$(curl --request POST \
    --silent -d \
    --url https://hisgateway.moph.go.th/api/login \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data password=${PASSWORD_ICTPORTAL} \
    --data username=${EMAIL_ICTPORTAL}
  )

  token=$( echo $response | python -c "import sys, json; print json.load(sys.stdin)['token']")

  if [ -f "./cert/version" ]; then
    version=`cat ./cert/version`
    loadtype="1"
    response_check_v=$(curl --request POST \
    --silent -d \
    --url https://hisgateway.moph.go.th/api/api/sh/cert/check \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data token=${token} \
    --data version=${version}
     )
  else
   loadtype="2"
   response_check_v=$(curl --request GET \
    --silent -d \
    --url https://hisgateway.moph.go.th/api/api/cert/check \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data token=${token}
  )
  fi

  check_v=$( echo $response_check_v | python -c "import sys, json; print json.load(sys.stdin)['ok']")
  if [ $check_v == 'True' ]; then
    if [ $loadtype == '1' ]; then
      echo "Certificate New Version."
    fi
    # response_check=$(curl --request GET \
    #   --silent -d \
    #   --url https://hisgateway.moph.go.th/api/api/sh/cert/check \
    #   --header 'Content-Type: application/x-www-form-urlencoded' \
    #   --data token=${token}
    # )

    check_file=$( echo $response_check_v | python -c "import sys, json; print json.load(sys.stdin)['ok']")

    if [ $check_file == 'True' ]; then
        echo "DOWNLOAD CERT"
        curl --request GET \
        --url https://hisgateway.moph.go.th/api/api/cert \
        --header 'Content-Type: application/x-www-form-urlencoded' \
        --data token=${token} -o cert.zip
        if ! [ -d "./cert" ]; then
        mkdir cert 
        fi
        rm -rf cert/*
        unzip cert.zip -d cert/
        rm -rf cert.zip
        password=`cat cert/password*`
        sed -e "s/PASSWORD=.*/PASSWORD=$password/g" "./hisgateway-docker/.env"
    else 
        echo "Certificate not found contact ADMIN"
    fi
  else
    echo "Certificate not found new version."
  fi
else 
  echo 'install please.'
fi
