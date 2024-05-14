#!/bin/bash

### Set Variables
export DOMAIN=bomar.bme.lab
export vRancherBackupCrdChart='103.0.0+up4.0.0'
export vRancherBackup=4.0.0
export registry=hauler.bomar.bme.lab:5000
export fileserver=hauler.bomar.bme.lab:8080

### Create Namespace
kubectl get namespace cattle-resources-system || kubectl create namespace cattle-resources-system

### Create Values files
cat <<EOF  | tee operator.yaml
persistence:
  enabled: false
EOF

### Install via Helm
helm upgrade -i rancher-backup  http://${fileserver}/rancher-backup-${vRancherBackupCrdChart}.tgz \
  -n cattle-resources-system  \
  --version=${vRancherBackup} \
  --values operator.yaml 
