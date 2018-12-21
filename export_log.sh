#!/bin/bash
namespace="default"
type="shardworker"
instance="0"
all=false

while true 
do
  case "$1" in
    -n | --namespace) namespace=$2; shift 2;;
    -t | --type) type=$2; shift 2;;
    -i | --instance) instance=$2; shift 2;;
    -f | --file) filename=$2; shift 2;;
    -a | --all) all=true; shift 1;;
    -l | --list) list=true; shift 1;;
    * ) break ;;
  esac
done

po=$type-$instance
if [ $list ]; then
  echo "List log files: "
  kubectl exec $po -n $namespace -- ls -l log
  exit;
fi

if [ ! -e log ]; then
  mkdir log
fi

datestr=`date "+%y-%m-%d-%H-%M-%S"`
newfilename=logs.${po}.${datestr}.tar.gz
if [ "$all" = true ]; then
  filename=log
  echo "zip the all logs in ${po}"
  kubectl exec $po -n $namespace -- tar czvf ${newfilename} ${filename}
elif [ ! -z $filename ]; then  
  echo "Copy log/${filename} from ${po}"
  kubectl exec $po -n $namespace -- cp log/${filename} ${newfilename}
  kubectl cp $namespace/$po:log/${filename} log/${filename} 
  echo "Logs are saved to log/${filename}"
  exit
else
  filename=log/${type}.log
  echo "zip the ${filename} in ${po}"
  kubectl exec $po -n $namespace -- tar czvf ${newfilename} ${filename}
fi

echo "Copying logs from container"
kubectl cp $namespace/$po:${newfilename} log/${newfilename} 

if [ $? -ne 0 ]; then
  echo "Failed to copy log file"
  exit 1;
else
  echo "Logs are saved to log/${newfilename}"
fi

kubectl exec $po -n $namespace -- rm ${newfilename}








