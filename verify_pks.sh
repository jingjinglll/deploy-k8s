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
  kubectl exec resthead-0 -n $namespace -- /bin/bash ./search_all.sh > /dev/null 2>&1
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
kubectl exec resthead-0 -n $namespace -- /bin/bash ./create_kibana_index.sh > /dev/null 2>&1
if [ $? -eq 0 ] 
then
  echo "Finished"
else
  echo "Error in creating Kibana index, please check server status"
fi

echo "Forward resthead service local port by running:"
echo "  kubectl port-forward service/resthead-service 29098:9098 --namespace=$namespace"
echo "  Then you can access Rest service at http://localhost:29098"

echo "Forward kibana service local port by running:"
echo "  kubectl port-forward service/kibana-service 25601:5601 --namespace=$namespace"
echo "  Then you can access Kibana service at http://localhost:25601"




