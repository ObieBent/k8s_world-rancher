#!/bin/bash

### Set Variables
export DOMAIN=bomar.bme.lab
export vRancherBackupCrdChart='103.0.0+up4.0.0'
export vRancherBackupCrd=4.0.0
export registry=hauler.bomar.bme.lab:5000
export fileserver=hauler.bomar.bme.lab:8080

### Create Namespace
kubectl get namespace cattle-resources-system || kubectl create namespace cattle-resources-system

### Install via Helm
helm upgrade -i rancher-backup-crd  http://${fileserver}/rancher-backup-crd-${vRancherBackupCrdChart}.tgz \
  -n cattle-resources-system  \
  --version=${vRancherBackupCrd}
