#!/bin/bash 
#
### Set Variables 
export vRancher=
export vCertManager=

### Setup Working Directory
rm -rf /shares/hauler/rancher
mkdir -p /shares/hauler/rancher 
cd /shares/hauler/rancher

### Download Cert Manager Images and Modify the List 
### https://github.com/cert-manager/cert-manager 

helm repo add jetstack https://charts.jetstack.io && helm repo update 
certManagerImages=$(helm template jetstack/cert-manager --version=v${vCertManager} | grep 'image:' | sed 's/"//g' | awk '{ print $2 }' | sed -e "s/^/    - name: /")

### Download Rancher Images and Modify the List 
### https://github.com/rancher/rancher 
rancherImages=$(curl -sSfL https://github.com/rancher/rancher/releases/download/v${vRancher}/rancher-images.txt | sed -e "s/^/    - name: /")

### Create Hauler Manifest
cat << EOF >> /shares/hauler/rancher/rancher-airgap-rancher.yaml
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Files
metadata:
  name: rancher-airgap-files-rancher
spec:
  files:
    - path: https://raw.githubusercontent.com/zackbradys/code-templates/main/k8s/yamls/rancher-banner-ufouo.yaml
      name: rancher-banner-ufouo.yaml
    - path: https://raw.githubusercontent.com/zackbradys/code-templates/main/k8s/yamls/rancher-banner-tssci.yaml
      name: rancher-banner-tssci.yaml
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Charts
metadata:
  name: rancher-airgap-charts-rancher
spec:
  charts:
    - name: cert-manager
      repoURL: https://charts.jetstack.io
      version: v${vCertManager}
    - name: rancher
      repoURL: https://releases.rancher.com/server-charts/latest
      version: ${vRancher}
---
apiVersion: content.hauler.cattle.io/v1alpha1
kind: Images
metadata:
  name: rancher-airgap-images-rancher
spec:
  images:
${certManagerImages}
${rancherImages}
EOF
