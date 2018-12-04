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

echo "Deleting Pravega Cluster"

kubectl delete -n $namespace -f example/pravega.yaml
kubectl delete pvc --selector="app=pravega-cluster"


echo "Deleting Zookeeper Cluster"

kubectl delete -n $namespace -f example/zookeeper.yaml
kubectl delete pvc --selector="app=example"

echo "Deleting Jmeter Task"
kubectl delete -n $namespace -f jmeter/jmeter.yaml

echo "Deleting NFS"
helm del $(helm ls --all --short) --purge

echo "Deleting all PVCs"
kubectl delete pvc --all -n $namespace

echo "Deleting all pvc"
kubectl delete pv --all -n $namespace
