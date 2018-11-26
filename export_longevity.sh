#!/bin/bash
namespace="default"

while true 
do
  case "$1" in
    -n | --namespace) namespace=$2; shift 2;;
    * ) break ;;
  esac
done

jmeter_po=`kubectl get po -n $namespace| grep jmeter | grep Running | awk '{print $1}'`

kubectl cp ./jmeter/generate_report.sh $jmeter_po:/bin -n $namespace
kubectl exec $jmeter_po -n $namespace -- ./bin/generate_report.sh

if [ -e output/dashboard ]; then
  rm -rf output/dashboard
fi

kubectl cp $jmeter_po:output/dashboard output/dashboard -n $namespace

if [ $? -eq 0 ]; then
  echo "Longevity reports are saved to ./output"
  kubectl exec $jmeter_po -n $namespace -- rm -rf /output/dashboard
else
  echo "Failed in export reports in container, try to generate reports locally"
  kubectl cp $jmeter_po:output/log.csv output/log.csv -n $namespace

  cat  output/log.csv  | awk 'FPAT="([^,]+)|(\"[^\"]+\")"{x=$0;while((gsub(/\"/,"\"",x)%2)!=0){getline;x=x " ";x=x $0};$0=x;print}' | head -n -1 >> output/temp.csv
  cat  output/temp.csv  | awk -F',' 'NF == 17' > output/temp2.csv

  if [ ! -e apache-jmeter-5.0 ]; then
    wget http://mirrors.advancedhosters.com/apache/jmeter/binaries/apache-jmeter-5.0.tgz
    tar xzvf apache-jmeter-5.0.tgz
    rm apache-jmeter-5.0.tgz
  fi
  
  apache-jmeter-5.0/bin/jmeter -g output/temp2.csv -o output/dashboard
  if [ $? -eq 0 ]; then
  	echo "Longevity reports are saved to ./output"
    rm output/temp.csv output/temp2.csv output/log.csv
  fi
fi








