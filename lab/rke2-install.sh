#!/usr/bin/env bash 

set -euo pipefail

PKG_DIR=$PWD/rke2_install/v1.29.2

install() {
	INSTALL_RKE2_ARTIFACT_PATH=$PKG_DIR INSTALL_RKE2_TYPE=server sh $PKG_DIR/install.sh 
}

install
