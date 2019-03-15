#!/bin/bash
namespace="es"

while true 
do
  case "$1" in
    -n | --namespace) namespace=$2; shift 2;;
    * ) break ;;
  esac
done

kubectl create -f es.yaml -n $namespace




