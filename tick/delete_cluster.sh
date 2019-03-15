
kubectl delete -f chronograf.yaml -R

kubectl delete -f kapacitor.yaml -R


kubectl delete -f telegraf.yaml -R

kubectl delete -f influxdb.yaml -R

kubectl delete pvc data-chronograf-0
kubectl delete pvc data-influxdb-0 
kubectl delete pvc data-kapacitor-0  