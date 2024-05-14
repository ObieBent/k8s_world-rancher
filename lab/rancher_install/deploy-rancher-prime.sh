#!/usr/bin/env bash

set -euo pipefail 

# Create cattle-system namespace 
if [ -z "$(/usr/local/bin/kubectl get ns -A | grep cattle-system)" ]; then
	/usr/local/bin/kubectl apply -f rancher-ns.yml
fi

# Deploy the secrets 
if [ -z "$(/usr/local/bin/kubectl get secrets -n cattle-system | egrep '(tls-ca|tls-rancher-bomar)')" ]; then 
	/usr/local/bin/kubectl apply -f secrets.yml
fi

# Create registry credentials 
if [ -z "$(/usr/local/bin/kubectl get secret -A | grep regcred)" ]; then
	/usr/local/bin/kubectl create secret docker-registry regcred \
		--docker-server='registry.bomar.bme.lab:5000' \
		--docker-username='admin' \
		--docker-password='admin' \
		--namespace cattle-system
fi

# Install Rancher prime 
/usr/local/bin/helm upgrade --install rancher \
	$PWD/rancher \
	-f values-rancher.yml \
	--version 2.8.2 \
	--namespace cattle-system \
