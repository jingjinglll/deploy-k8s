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

kubectl cp ./jmeter/generate_report.sh $jmeter_po:/bin -n $namespace
kubectl exec $jmeter_po -n $namespace -- ./bin/generate_report.sh

kubectl cp $jmeter_po:output/dashboard output/dashboard -n $namespace
echo "Longevity reports are saved to ./output"

kubectl exec $jmeter_po -n $namespace -- rm -rf /output/dashboard






