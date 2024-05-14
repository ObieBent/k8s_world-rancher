#!/bin/bash

### Set Variables
export DOMAIN=bomar.bme.lab
export vLonghorn=1.6.1
export registry=hauler.bomar.bme.lab:5000
export fileserver=hauler.bomar.bme.lab:8080

### Create Namespace
kubectl create namespace longhorn-system

### Install via Helm
helm upgrade -i longhorn http://${fileserver}/longhorn-${vLonghorn}.tgz \
  -n longhorn-system \
  --version=$vLonghorn \
  --set global.cattle.systemDefaultRegistry=$registry

sleep 30

### Create Encrypted Storage Class
kubectl apply -f http://${fileserver}/longhorn-encrypted-sc.yaml
