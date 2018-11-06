#!/bin/bash
namespace="default"
resthead_service="resthead-service-external"
kibana_service="kibana-service"
resthead_po="resthead-0"
pravega_service="pravega-pravega-controller"
pravega_service_external="pravega-pravega-controller-external"

while true 
do
  case "$1" in
    -n | --namespace) namespace=$2; shift 2;;
	-rp | --resthead-pod ) resthead_po=$2; shift 2;;
    * ) break ;;
  esac
done


echo -n "Creating test index..."
kubectl cp ./scripts/create_testindex.sh $resthead_po:/opt/emc/nautilus/resthead -n $namespace  > /dev/null 2>&1
kubectl exec resthead-0 -n $namespace -- /bin/bash ./create_testindex.sh > /dev/null 2>&1
if [ $? -eq 0 ] 
then
  echo "Succeeded"
else
  echo "Error in creating test index, please check server status"
fi

echo "Declaring searchable"
kubectl exec resthead-0 -n $namespace -- curl -ik -XPUT 'http://localhost:9098/searchable/psearch/TestStream?_index=testindex&pointer=false'

#echo "Exposing Pravega controller..."
#kubectl expose service $pravega_service -n $namespace --name $pravega_service_external --type LoadBalancer --port 9090 --target-port 9090

#retry=0
#while [ $retry -le 100 ]
#do
#  pravega_url=`echo | kubectl get svc -n $namespace | grep $pravega_service_external | awk -F"[:/ ]+" '{print $4":"$5}'`
#  if [[ $pravega_url == *"<pending>"* ]]; then 
#    echo -ne "."
#	 sleep 5
#  else
#    echo "You can access Pravega Controller at http://$pravega_url"
#	break
#  fi
#done

echo "Copying cli-0.1.0.0.jar"
kubectl cp ./lib/cli-0.1.0.0.jar controller-0:/opt/emc/nautilus/controller/lib -n $namespace 
echo "Copying httpclient-4.5.5.jar"
kubectl cp ./lib/httpclient-4.5.5.jar controller-0:/opt/emc/nautilus/controller/lib -n $namespace 
echo "Copying httpcore-4.5.5.jar"
kubectl cp ./lib/httpcore-4.4.9.jar controller-0:/opt/emc/nautilus/controller/lib -n $namespace 
echo "Copying scripts"
kubectl cp ./scripts/cli controller-0:/opt/emc/nautilus/controller/bin -n $namespace
kubectl cp ./scripts/generate_data.py controller-0:/opt/emc/nautilus/controller -n $namespace
kubectl cp ./scripts/cli.yml controller-0:/opt/emc/nautilus/controller/conf -n $namespace

echo "Generating data"
kubectl exec controller-0 -n $namespace -- python generate_data.py




