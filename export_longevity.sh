#!/bin/bash
namespace="default"
filename="result.jtl"


while true 
do
  case "$1" in
    -n | --namespace) namespace=$2; shift 2;;
    * ) break ;;
  esac
done

jmeter_po=`kubectl get po -n $namespace| grep jmeter | grep Running | awk '{print $1}'`
datestr=`date "+%y-%m-%d-%H-%M-%S"`

kubectl cp ./jmeter/generate_report.sh $jmeter_po:/bin -n $namespace
kubectl exec $jmeter_po -n $namespace -- ./bin/generate_report.sh

kubectl cp $jmeter_po:output/dashboard output/dashboard.${datestr} -n $namespace

if [ $? -eq 0 ]; then
  echo "Longevity reports are saved to ./output"
  kubectl exec $jmeter_po -n $namespace -- rm -rf /output/dashboard
else
  echo "Failed in export reports in container, try to generate reports locally"
  kubectl exec $jmeter_po -n $namespace -- tar czvf output/result.tar.gz output/${filename}
  kubectl cp $jmeter_po:output/result.tar.gz output/. -n $namespace

  if [ $? -ne 0 ]; then
  	echo "Failed to copy result file"
  	exit 1;
  fi

  tar xzvf output/result.tar.gz output
  kubectl exec $jmeter_po -n $namespace -- rm output/result.tar.gz

  echo "Pre-processing the jtl..."
  #awk 'FPAT="([^,]+)|(\"[^\"]+\")"{x=$0;while( (x~ /^[0-9]/)&&(gsub(/\"/,"\"",x)%2)!=0){getline;x=x " ";x=x $0};$0=x;print}' | awk -F',' '{print $1}'
  #cat  output/result.jtl  | awk 'FPAT="([^,]+)|(\"[^\"]+\")"{x=$0;while((gsub(/\"/,"\"",x)%2)!=0){getline;x=x " ";x=x $0};$0=x;print}' | head -n -1 >> output/temp.jtl
  #cat  output/temp.jtl  | awk -F',' 'NF == 17' > output/temp2.jtl

  #cat  output/result.jtl | awk 'FPAT="([^,]+)|(\"[^\"]+\")"{x=$0;while((x~ /^[0-9]/)&&(gsub(/\"/,"\"",x)%2)!=0){getline;x=x " ";x=x $0};$0=x;print}' | awk -F',' 'NF == 17' >> output/temp.jtl
  #cat  output/temp.jtl  | awk -F',' 'NF == 17' > output/temp2.jtl
  #awk 'FPAT="([^,]+)|(\"[^\"]+\")"{x=$0;while((x~ /^[0-9]/)&&(gsub(/\"/,"\"",x)%2)!=0){getline;x=x " ";x=x $0};$0=x;print}' output/result.jtl >> temp1.jtl
  #awk -F',' 'NF == 17' temp1.jtl >> output/temp2.jtl

  nlines=`wc -l output/${filename} | awk '{print $1}'`

  head -n 1 output/${filename} > output/temp.jtl

  cat output/${filename} | awk -v nl=${nlines} 'FPAT="([^,]+)|(\"[^\"]+\")"{x=$0;while((x~ /^[0-9]/)&&(NR!=nl)&&(gsub(/\"/,"\"",x)%2)!=0){getline;x=x " ";x=x $0};$0=x;print}' | awk -F',' '$17~/^[0-9]+$/' | awk -F',' 'NF==17' | sed "s/\"//g" >> output/temp.jtl


  if [ ! -e apache-jmeter-5.0 ]; then
  	echo "Downloading Jmeter..."
    wget http://mirrors.advancedhosters.com/apache/jmeter/binaries/apache-jmeter-5.0.tgz
    tar xzvf apache-jmeter-5.0.tgz
    rm apache-jmeter-5.0.tgz
  fi

  echo "Generating report..."
  apache-jmeter-5.0/bin/jmeter -g output/temp.jtl -o output/dashboard.${datestr}
  if [ $? -eq 0 ]; then
  	echo "Longevity reports are saved to ./output/dashboard.${datestr}"
    rm output/temp.jtl output/${filename}
  fi
fi








