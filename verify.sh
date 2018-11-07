#!/bin/bash
namespace="default"
resthead_service="resthead-service-external"
kibana_service="kibana-service"
resthead_po="resthead-0"

while true 
do
  case "$1" in
    -n | --namespace) namespace=$2; shift 2;;
    -rs | --resthead-service ) resthead_service=$2; shift 2;;
	-rp | --resthead-pod ) resthead_po=$2; shift 2;;
    -ks | --kibana-service ) kibana_service="$2"; shift 2 ;;
    * ) break ;;
  esac
done

echo -n "Testing query..."
retry=0
while [ $retry -le 100 ]
do
  kubectl cp ./scripts/search_all.sh $resthead_po:/opt/emc/nautilus/resthead -n $namespace  > /dev/null 2>&1
  kubectl exec resthead-0 -n $namespace -- /bin/bash ./search_all.sh #> /dev/null 2>&1
  if [ $? -eq 0 ] 
  then
    echo "Finished"
  	break
  fi
  retry=$[$retry+1]
  echo -ne "."
  sleep 5
done

if [ $retry -eq 100 ]
then
  echo "Query test failed for 100 times, exit the process"
  exit 1
fi

echo -n "Creating Kibana index..."
kubectl cp ./scripts/create_kibana_index.sh $resthead_po:/opt/emc/nautilus/resthead -n $namespace  > /dev/null 2>&1
kubectl exec resthead-0 -n $namespace -- /bin/bash ./create_kibana_index.sh #> /dev/null 2>&1
if [ $? -eq 0 ] 
then
  echo "Finished"
else
  echo "Error in creating Kibana index, please check server status"
fi

echo -n "Awaiting REST service external IP..."
retry=0
while [ $retry -le 100 ]
do
  resthead_url=`echo | kubectl get svc -n $namespace | grep "$resthead_service" | awk -F"[:/ ]+" '{print $4":"$5}'`
  if [[ $resthead_url == *"<pending>"* ]]; then 
    echo -ne "."
	sleep 5
  else
    echo "You can access Rest service at http://$resthead_url"
	break
  fi
done

echo -n "Awaiting Kibana service external IP..."
retry=0
while [ $retry -le 100 ]
do
  kibana_url=`echo | kubectl get svc -n $namespace | grep "$kibana_service" | awk -F"[:/ ]+" '{print $4":"$5}'`
  if [[ $kibana_url == *"<pending>"* ]]; then 
    echo -ne "."
	sleep 5
  else
    echo "You can access Kibana service at http://$kibana_url"
	break
  fi
done
