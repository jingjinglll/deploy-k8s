#!/bin/bash
#namespace="tick"

while true 
do
  case "$1" in
    -n | --namespace) namespace=$2; shift 2;;
    * ) break ;;
  esac
done

# echo "Initializing helm"
# helm init
# kubectl create serviceaccount --namespace kube-system tiller
# kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
# kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
# helm repo update
# sleep 5

# echo "Installing nfs-server-provisioner"
# #helm install stable/nfs-server-provisioner
# helm install stable/nfs-server-provisioner --set=persistence.enabled=true,persistence.size=530Gi,image.repository=jirnsr/nfs-provisioner,image.tag=v1.0.9



#kubectl create ns tick
kubectl create -f influxdb.yaml -R

#kubectl exec -i -t influxdb-0  -- influx

kubectl create -f telegraf.yaml -R
kubectl create -f kapacitor.yaml -R
kubectl create -f chronograf.yaml -R
echo "Export port using: kubectl port-forward svc/chronograf 8888:80"
echo "or expose external ip by using: kubectl expose svc chronograf --name chronograf-external --type LoadBalancer --port 8888"



