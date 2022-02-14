if ! [ -x "$(command -v nc)" ]; then
    if  [ "$(uname -a | grep el7)" ]; then
        yum install nc -y
    else
       apt-get install nc
    fi
fi
echo "If show succeeded! is work."
nc -vz kafka1.moph.go.th 19093
nc -vz mqtt.h4u.moph.go.th 9093
nc -vz oauth.moph.go.th 443