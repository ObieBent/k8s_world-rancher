#!/usr/bin/env bash 

PROJECT_DIR="$PWD"
OS_VERSION="Rocky Linux release 9.3"
TERRAFORM_HOSTS_BASE_DIR="$PROJECT_DIR/terraform"

echo "Now provisioning nodes for installing RKE2..."

for directory in hypervisor  ; do
    pushd "$TERRAFORM_HOSTS_BASE_DIR/$directory"
    [[ -d .terraform ]] || terraform init
    terraform apply --var  "os_version=$OS_VERSION" --auto-approve
    popd
done

echo "Done."
