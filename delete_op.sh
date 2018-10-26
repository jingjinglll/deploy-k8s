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

echo "Deleting Pravega Search Operator"

kubectl delete -n $namespace -f psearch-operator

echo "Deleting Pravega Operator"

kubectl delete -n $namespace -f https://raw.githubusercontent.com/pravega/pravega-operator/master/deploy/operator.yaml
kubectl delete -n $namespace -f https://raw.githubusercontent.com/pravega/pravega-operator/master/deploy/rbac.yaml
kubectl delete -n $namespace -f https://raw.githubusercontent.com/pravega/pravega-operator/master/deploy/crd.yaml

echo "Deleting Zookeeper Operator"
kubectl delete -n $namespace -f https://raw.githubusercontent.com/pravega/zookeeper-operator/master/deploy/all_ns/operator.yaml
kubectl delete -n $namespace -f https://raw.githubusercontent.com/pravega/zookeeper-operator/master/deploy/all_ns/rbac.yaml
kubectl delete -n $namespace -f https://raw.githubusercontent.com/pravega/zookeeper-operator/master/deploy/crd.yaml

