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

echo "Initializing helm"
helm init --upgrade
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec": {"template": {"spec": {"serviceAccount": "tiller","containers": [{"name": "tiller","image": "jirnsr/tiller:v2.14.0"}]} } } }'

helm repo update
sleep 10


echo "Storage class"
kubectl create -f example/sc.yaml

echo "Installing nfs-server-provisioner"
helm install stable/nfs-server-provisioner --set=persistence.enabled=true,persistence.size=600Gi,image.repository=jirnsr/nfs-provisioner,image.tag=v1.0.9 --namespace $namespace

kubectl get namespace $namespace > /dev/null 2>&1
if [ $? != 0 ]
then
  echo "Creating Namespace: $namespace"
  kubectl create namespace $namespace
else
  echo "Using namespace: $namespace"
fi

echo "Creating Zookeeper Operator"
kubectl create -n $namespace -f https://raw.githubusercontent.com/pravega/zookeeper-operator/master/deploy/crds/zookeeper_v1beta1_zookeepercluster_crd.yaml
kubectl create -n $namespace -f zookeeper-operator/rbac.yaml
kubectl create -n $namespace -f https://raw.githubusercontent.com/pravega/zookeeper-operator/master/deploy/all_ns/operator.yaml

echo "Creating Pravega Operator"
helm install charts/pravega-operator --namespace $namespace --set image.repository=pravega/pravega-operator

echo "Creating Pravega Search Operator"
helm install charts/psearch-operator --namespace $namespace

sleep 5

echo "Creating Zookeeper Cluster"
kubectl create -n $namespace -f example/zookeeper.yaml

echo "Creating Pravega Cluster"
# kubectl create -n $namespace -f example/pravega.yaml
kubectl create -f ./example/pvc-tier2.yaml --namespace $namespace
helm install charts/pravega --name pravega --namespace $namespace --set zookeeperUri=zk-client:2181 --set pravega.tier2=pravega-tier2 
   #--set version=0.5.0 --set bookkeeper.image.repository=pravega/bookkeeper --set pravega.image.repository=pravega/pravega

echo "Creating Pravega Search Cluster"
helm install charts/psearch --name psearch --namespace $namespace --set pravegaControllerIP=pravega-pravega-pravega-controller 

# echo "Verify services and create kibana index"
# ./verify_pks.sh -n $namespace -k $kibana_service -r $resthead_service

