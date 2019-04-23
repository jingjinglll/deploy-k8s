#!/bin/bash
namespace="es"
testClientName="es-test-client"

test_client_po=`kubectl get po -n $namespace| grep  $testClientName | grep Running | awk '{print $1}'`
echo "ssss"$test_client_po
datestr=`date "+%y-%m-%d-%H-%M-%S"`


echo "Copying logs from container"

tar_list=`kubectl exec $test_client_po -n $namespace -- ls | grep tar$`

echo $tar_list

for each in $tar_list
    do
        echo $each
        kubectl cp $namespace/$test_client_po:$each .
        if [ $? -ne 0 ]; then
			echo "Failed to copy result file"
			exit 1;
		fi
		# newDir=`echo $each |  cut -d "." -f1`
		# mkdir $newDir
		# tar -xvzf $each -C $newDir
    done

echo "Generating report..."









