!/bin/bash
namespace="ns-elasticsearch"
filename="result.jtl"
dashboard="jmeter"


while true 
do
  case "$1" in
    -n | --namespace) namespace=$2; shift 2;;
    * ) break ;;
  esac
done

jmeter_po=`kubectl get po -n $namespace| grep jmeter | grep Running | awk '{print $1}'`
datestr=`date "+%y-%m-%d-%H-%M-%S"`

#kubectl cp ./jmeter/generate_report.sh $namespace/$jmeter_po:/bin -c $dashboard
#kubectl exec $jmeter_po -n $namespace -c $dashboard -- ./bin/generate_report.sh

#echo "Copying generated dashboard..."
#kubectl cp $namespace/$jmeter_po:output/dashboard output/dashboard.${datestr} -c $dashboard

#if [ $? -eq 0 ]; then
#  echo "Longevity reports are saved to ./output"
#  kubectl exec $jmeter_po -n $namespace -c $dashboard -- rm -rf /output/dashboard
#else
#  echo "Failed in export reports in container, try to generate reports locally"
  echo "zip the logs in container"
  kubectl exec $jmeter_po -n $namespace  -c $dashboard -- tar czvf output/result.tar.gz output/${filename}
  echo "Copying logs from container"
  if [ ! -e output ]; then
    mkdir output
  fi
  kubectl cp $namespace/$jmeter_po:output/result.tar.gz output/result.tar.gz -c $dashboard

  if [ $? -ne 0 ]; then
  	echo "Failed to copy result file"
  	exit 1;
  fi

  tar xzvf output/result.tar.gz output
  kubectl exec $jmeter_po -n $namespace -c $dashboard -- rm output/result.tar.gz

  echo "Pre-processing the jtl..."
  #nlines=`wc -l output/${filename} | awk '{print $1}'`

  head -n 1 output/${filename} > output/temp.jtl

  #cat output/${filename} | awk -v nl=${nlines} 'FPAT="([^,]+)|(\"[^\"]+\")"{x=$0;while((x~ /^[0-9]/)&&(NR!=nl)&&(gsub(/\"/,"\"",x)%2)!=0){getline;x=x " ";x=x $0};$0=x;print}' | awk -F',' '$17~/^[0-9]+$/' | awk -F',' 'NF==17' | sed "s/\"//g" >> output/temp.jtl
  cat output/${filename} | awk -F',' '$16~/^[0-9]+$/' | awk -F',' 'NF==16' | sed "s/\"//g" >> output/temp.jtl


  if [ ! -e apache-jmeter-5.0 ]; then
  	echo "Downloading Jmeter..."
    wget http://mirrors.advancedhosters.com/apache/jmeter/binaries/apache-jmeter-5.0.tgz
    tar xzvf apache-jmeter-5.0.tgz
    echo "jmeter.save.saveservice.assertion_results_failure_message=false" >> apache-jmeter-5.0/bin/jmeter.properties
    rm apache-jmeter-5.0.tgz
  fi

  echo "Generating report..."
  JVM_ARGS="-Xms10g -Xmx14g" apache-jmeter-5.0/bin/jmeter -g output/temp.jtl -o output/dashboard.${datestr}
  if [ $? -eq 0 ]; then
  	echo "Longevity reports are saved to ./output/dashboard.${datestr}"
    rm output/temp.jtl output/${filename} output/result.tar.gz
  fi
#fi








