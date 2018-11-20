#!/bin/bash
namespace="default"

while true 
do
  case "$1" in
    -n | --namespace) namespace=$2; shift 2;;
    * ) break ;;
  esac
done

jmeter_po=`kubectl get po -n $namespace| grep jmeter | awk '{print $1}'`
kubectl cp $jmeter_po:apache-jmeter-5.0/output/ output/
echo "Longevity reports are saved to ./output"





