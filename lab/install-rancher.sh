#!/bin/bash 
### Set Variables
export DOMAIN=bomar.bme.lab
export vRancher=2.8.2
export registry=hauler.bomar.bme.lab:5000
export fileserver=hauler.bomar.bme.lab:8080

### Create Namespace
kubectl get namesapce cattle-system || kubectl create namespace cattle-system

### Configure Cert Manager
kubectl apply -f - << EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: tls-certs
  namespace: cattle-system
spec:
  issuerRef:
    name: selfsigned-issuer
    kind: ClusterIssuer
  secretName: tls-certs
  commonName: "$DOMAIN"
  dnsNames:
  - "$DOMAIN"
  - "*.$DOMAIN"
EOF

### Install via Helm
helm upgrade -i rancher http://${fileserver}/rancher-${vRancher}.tgz -n cattle-system \
  --set bootstrapPassword=Pa22word \
  --set replicas=1 \
  --set ingress.tls.source=secret \
  --set ingress.tls.secretName=tls-certs \
  --set useBundledSystemChart=true \
  --set privateCA=true \
  --set systemDefaultRegistry=$registry \
  --set rancherImage=$registry/rancher/rancher \
  --set hostname=rancher.$DOMAIN

max_retry=20
iteration=0

while [ -n "$(kubectl get namespace | grep 'cattle-global-data')" ]
do
        echo "Wait for sub namespaces to be created"

        if [ $iteration -eq $max_retry ]; then
                break
        fi

        sleep 10
        ((iteration++))
done

if [ $iteration -eq $max_retry ]; then
        echo "The sub namespaces have failed to be created"
else
        echo "The sub namespaces have been created successfully"
fi 

### Create Classification Banners
kubectl apply -f http://${fileserver}/rancher-banner-ufouo.yaml
