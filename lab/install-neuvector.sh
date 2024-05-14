#!/bin/bash 

### Set Variables
export DOMAIN=<example.com>
export vNeuVector=2.7.3
export registry=<FQDN or IP>:5000
export fileserver=<FQDN or IP>:8080

### Create Namespace
kubectl create namespace cattle-neuvector-system

### Install via Helm
helm upgrade -i neuvector http://${fileserver}/core-${vNeuVector}.tgz -n cattle-neuvector-system \
  --set k3s.enabled=true \
  --set manager.svc.type=ClusterIP \
  --set internal.certmanager.enabled=true \
  --set controller.pvc.enabled=true \
  --set controller.pvc.capacity=10Gi \
  --set global.cattle.url=https://rancher.$DOMAIN \
  --set controller.ranchersso.enabled=true \
  --set rbac=true \
  --set registry=$registry
