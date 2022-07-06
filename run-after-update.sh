version_old=$1
version_new=$(cat ./script.version)
# if  [[ $version_old == "20220215" ]]; then
#     ./set-env.sh --force
#     echo ""
#     echo "Please Add New Connector"
#     echo "HISGW Version 2.1.0"
#     echo "- update Kafka Version"
#     echo "- change topic route"
# fi
if  [[ $version_old != $version_new ]]; then
./set-env.sh --force
echo ""
echo "Please Remove and Add New Connector"
echo "HISGW Version 2.2.0"
echo "- add schema version"
echo "- add line notify"
echo "- add restart service"
echo "- fix error record not key"
echo "- fix bad word"
fi
