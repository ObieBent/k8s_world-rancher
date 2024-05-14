#!/usr/bin/env bash 
set -euo pipefail

# Create cert-manager namespace 
if [ -z "$(/usr/local/bin/kubectl get ns -A | grep cert-manager)" ]; then
	/usr/local/bin/kubectl apply -f cert-manager-ns.yml
fi
# Create registry credentials 
if [ -z "$(/usr/local/bin/kubectl get secret -A | grep regcred)" ]; then
	/usr/local/bin/kubectl create secret docker-registry regcred \
		--docker-server='registry.bomar.bme.lab:5000' \
		--docker-username='admin' \
		--docker-password='admin' \
		--namespace cert-manager 
fi

# Deploy cert-manager CRDs 
/usr/local/bin/kubectl apply -f cert-manager-crds.yaml 
sleep 5 
# Deploy cert-manager 
helm upgrade --install cert-manager $PWD/cert-manager-v1.14.4.tgz \
	--namespace cert-manager \
	-f $PWD/values-cert-manager.yml
