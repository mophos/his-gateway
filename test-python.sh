response=$(
    curl --request POST \
        --silent -d \
        --url https://hisgateway.moph.go.th/api/login \
        --header 'Content-Type: application/x-www-form-urlencoded' \
        --data username=tanjaae@hotmail.com \
        --data password=023930742
)
# echo $response

IFS=':' read -ra ADDR <<< "$response"
t=${ADDR[2]}
IFS='"' read -ra ADDR2 <<< "${ADDR[2]}"
t2=${ADDR2[1]}
echo $t2
# # echo ${ADDR[2]}
# for i in "${ADDR2[@]}"; do
#     echo "$i  ";
# #   # process "$i"
# done

# token=$( echo $response | python3 -c "import sys, json; print json.load(sys.stdin)['token']")
