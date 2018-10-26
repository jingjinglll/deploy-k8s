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

echo "Deleting Zookeeper Cluster"

kubectl delete -n $namespace -f example/zookeeper.yaml

echo "Deleting PVCs"

kubectl delete pvc --all

echo "Deleting PVs"

kubectl delete pv --all
