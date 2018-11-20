#!/bin/bash
namespace="default"

while true 
do
  case "$1" in
    -n | --namespace) namespace=$2; shift 2;;
    * ) break ;;
  esac
done

kubectl create -f jmeter/jmeter.yaml -n $namespace

kubectl get po -w




