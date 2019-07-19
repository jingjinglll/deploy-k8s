#!/bin/bash

namespace="default"

while getopts ":n:" opt
do
  case $opt in
    n)
    namespace=$OPTARG
    ;;
    ?)
    echo "Unknown argument"
    exit 1;;
  esac
done

echo "Deleting Pravega Search Cluster"

kubectl delete -n $namespace -f example/psearch.yaml
kubectl delete pvc --selector="app=psearch-controller" -n $namespace
kubectl delete pvc --selector="app=indexworker" -n $namespace
kubectl delete pvc --selector="app=queryworker" -n $namespace
kubectl delete pvc --selector="app=resthead" -n $namespace
kubectl delete pvc --selector="app=shardworker" -n $namespace

echo "Deleting Pravega Cluster"

kubectl delete -n $namespace -f example/pravega.yaml
kubectl delete pvc --selector="app=pravega-cluster" -n $namespace


echo "Deleting Zookeeper Cluster"

kubectl delete -n $namespace -f example/zookeeper.yaml
kubectl delete pvc --selector="app=zk" -n $namespace

echo "Deleting Jmeter Task"
kubectl delete -n $namespace -f jmeter/jmeter.yaml -n $namespace

# echo "Deleting NFS"
helm del $(helm ls --all --short) --purge

# echo "Deleting all PVCs"
kubectl delete pvc --all -n $namespace

# echo "Deleting all pvc"
# kubectl delete pv --all -n $namespace

echo "Deleting Zookeeper Operator"
kubectl delete -n $namespace -f https://raw.githubusercontent.com/pravega/zookeeper-operator/master/deploy/all_ns/operator.yaml
kubectl delete -n $namespace -f https://raw.githubusercontent.com/pravega/zookeeper-operator/master/deploy/all_ns/rbac.yaml
kubectl delete -n $namespace -f https://raw.githubusercontent.com/pravega/zookeeper-operator/master/deploy/crds/zookeeper_v1beta1_zookeepercluster_crd.yaml
