#!/bin/bash 
#
### Set Variables
export DOMAIN=bomar.bme.lab
export vCertManager=1.14.4 
export registry=hauler.bomar.bme.lab:5000
export fileserver=hauler.bomar.bme.lab:8080

### Create Namespace
kubectl get namespace cert-manager || kubectl create namespace cert-manager

### Install via Helm
helm upgrade -i cert-manager http://${fileserver}/cert-manager-v${vCertManager}.tgz \
  -n cert-manager --set installCRDs=true \
  --set image.repository=$registry/jetstack/cert-manager-controller \
  --set webhook.image.repository=$registry/jetstack/cert-manager-webhook \
  --set cainjector.image.repository=$registry/jetstack/cert-manager-cainjector \
  --set acmesolver.image.repository=$registry/jetstack/cert-manager-acmesolver \
  --set startupapicheck.image.repository=$registry/jetstack/cert-manager-startupapicheck

### Configure Cert Manager
kubectl apply -f - << EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: tls-certs
  namespace: cert-manager
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
