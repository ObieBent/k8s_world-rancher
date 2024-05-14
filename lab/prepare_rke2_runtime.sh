#!/usr/bin/env bash 
#
export vRKE2=1.27.12
export vPlatform=el9
export registry=<FQDN or IP>:5000
export fileserver=<FQDN or IP>:8080 

# script for preparing rke2 runtime

set -euo pipefail

CONF_DIR=$PWD/rke2_conf

# Create etcd group and etcd user 
if [ -z "$(getent passwd | grep etcd)" ]; then
	useradd -s /usr/sbin/nologin -c "etcd service account" -u 52034 -U etcd 
fi

### Install Packages 
# Required for installing properly Longhorn
dnf install -y nfs-utils iscsi-initiator-utils 

### Install Depedencies
dnf install -y http://${fileserver}/rke2-selinux-0.17-1.${vPlatform}.noarch.rpm \
  http://${fileserver}/rke2-common-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm \
  http://${fileserver}/rke2-server-${vRKE2}.rke2r1-0.${vPlatform}.x86_64.rpm

### Modify Settings 
# Required for installing properly Longhorn
echo "InitiatorName=$(/sbin/iscsi-iname)" > /etc/iscsi/initiatorname.iscsi && systemctl enable --now iscsid 

# Disable unnecessary services
systemctl stop firewalld; systemctl disable firewalld; systemctl stop nm-cloud-setup; systemctl disable nm-cloud-setup; systemctl stop nm-cloud-setup.timer; systemctl disable nm-cloud-setup.timer

# Install SELinux related packages 

#if [ -z "$(rpm -qav | grep container-selinux)" ]; then
	#rpm -ivh $PWD/rke2_pkg/container-selinux-2.221.0-1.el9.noarch.rpm
#fi 

#if [ -z "$(rpm -qav | grep rke2-selinux)" ]; then
	#rpm -ivh $PWD/rke2_pkg/rke2-selinux-0.17-1.el9.noarch.rpm
#fi

#if [ -z "$(rpm -qav | grep rancher-selinux)" ]; then
	#rpm -ivh $PWD/rke2_pkg/rancher-selinux-0.4-1.el9.noarch.rpm
#fi
create_rancher_dirs() {
        mkdir -p /var/lib/rancher/rke2/server/manifests
        mkdir -p /etc/rancher/rke2
}

set_conf_files() {
        cp -v -f "$CONF_DIR"/config.yaml /etc/rancher/rke2/config.yaml
        cp -v -f "$CONF_DIR"/registries.yaml /etc/rancher/rke2/registries.yaml
        chmod 0640 /etc/rancher/rke2/config.yaml
        chmod 0640 /etc/rancher/rke2/registries.yaml
        cp -v -f "$CONF_DIR"/rke2-had-psa.yaml /etc/rancher/rke2/rke2-had-psa.yaml
        chmod 0600 /etc/rancher/rke2/rke2-had-psa.yaml
        cp -v -f "$CONF_DIR"/rke2-cilium-config.yaml /var/lib/rancher/rke2/server/manifests/rke2-cilium-config.yaml
        chmod 0640 /var/lib/rancher/rke2/server/manifests/rke2-cilium-config.yaml
        cp -v -f "$CONF_DIR"/audit-policy.yaml /etc/rancher/rke2/audit-policy.yaml
        chmod 0600 /etc/rancher/rke2/audit-policy.yaml
	      cp -v -f "$CONF_DIR"/90-kubelet.conf /etc/sysctl.d/90-kubelet.conf
	      chmod 0600 /etc/sysctl.d/90-kubelet.conf
	      systemctl restart systemd-sysctl.service
}

create_rancher_dirs
set_conf_files
