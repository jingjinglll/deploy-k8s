#!/bin/bash

namespace="default"
resthead_service="resthead-service-external"
kibana_service="kibana-service"

while true 
do
  case "$1" in
    -u | --user) user=$2; shift 2;;
    -n | --namespace) namespace=$2; shift 2;;
    -r | --resthead-service ) resthead_service=$2; shift 2;;
    -k | --kibana-service ) kibana_service="$2"; shift 2 ;;
    * ) break ;;
  esac
done

if [ -z "$user" ]; then
	echo "Enter your the email address of google clould platform, this will be used to create cluster role binding"
	read user
fi
echo "Creating role binding using: $user"
kubectl create clusterrolebinding default-cluster-admin-binding --clusterrole=cluster-admin --user=$user

kubectl get namespace $namespace > /dev/null 2>&1
if [ $? != 0 ]
then
  echo "Creating Namespace: $namespace"
  kubectl create namespace $namespace
else
  echo "Using namespace: $namespace"
fi

echo "Creating Zookeeper Operator"
kubectl create -n $namespace -f https://raw.githubusercontent.com/pravega/zookeeper-operator/master/deploy/crd.yaml
kubectl create -n $namespace -f https://raw.githubusercontent.com/pravega/zookeeper-operator/master/deploy/all_ns/rbac.yaml
kubectl create -n $namespace -f https://raw.githubusercontent.com/pravega/zookeeper-operator/master/deploy/all_ns/operator.yaml

echo "Creating Pravega Operator"
kubectl create -n $namespace -f https://raw.githubusercontent.com/pravega/pravega-operator/master/deploy/crd.yaml
kubectl create -n $namespace -f https://raw.githubusercontent.com/pravega/pravega-operator/master/deploy/role.yaml
kubectl create -n $namespace -f https://raw.githubusercontent.com/pravega/pravega-operator/master/deploy/role_binding.yaml
kubectl create -n $namespace -f https://raw.githubusercontent.com/pravega/pravega-operator/master/deploy/service_account.yaml
kubectl create -n $namespace -f https://raw.githubusercontent.com/pravega/pravega-operator/master/deploy/operator.yaml


echo "Creating Pravega Search Operator"
kubectl create -n $namespace -f psearch-operator/service_account.yaml
kubectl create -n $namespace -f psearch-operator/role.yaml
kubectl create -n $namespace -f psearch-operator/role_binding.yaml
kubectl create -n $namespace -f psearch-operator/crd.yaml
kubectl create -n $namespace -f psearch-operator/operator.yaml


echo "Creating Zookeeper Cluster"
kubectl create -n $namespace -f example/zookeeper.yaml

echo "Creating Pravega Cluster"
kubectl create -n $namespace -f example/pv-gfs.yaml
kubectl create -n $namespace -f example/pravega-gfs.yaml

echo "Creating Pravega Search Cluster"
kubectl create -n $namespace -f example/psearch.yaml

echo "Verify services and create kibana index"
./verify.sh -n $namespace -k $kibana_service -r $resthead_service

