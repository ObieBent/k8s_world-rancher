#!/usr/bin/bash

# Script to generate a self-signed certificate
# Checking if "openssl" command is installed on the system
if [[ ! $(command -v openssl) ]]; then
    echo "OpenSSL utility is not found on the system, please install it !"
    exit 1
else
    OP=$(command -v openssl)
fi

# Variables
CANAME=Buzz-Music-RootCA

# Generate the private key for the Certificate Authority
mkdir -p ${PWD}/${CANAME}
cd ${CANAME}
${OP} genrsa -out ${PWD}/${CANAME}.key 4096

# Generate the Certificate Authority (CA)
${OP} req -x509 -new \
      -subj '/C=FR/ST=Ile de France/L=Paris/O=Buzz Music Entertainment/CN=Buzz-Music-RootCA' \
      -key ${PWD}/${CANAME}.key \
      -sha256 -days 1826 -out ${PWD}/${CANAME}.crt

# Add the CA certificates to the trusted root certificates
sudo cp -f -v  ${PWD}/${CANAME}.crt /etc/pki/ca-trust/source/anchors
sudo update-ca-trust
cd ..

# Generate the private key for the web app
APP=rms
mkdir -p ${PWD}/${APP}
cd ${APP}
${OP} genrsa -out ${PWD}/${APP}.key 4096

# Generate the Certificate Signing Request (CSR)
${OP} req -new -subj \
      "/C=FR/ST=Ile de France/L=Paris/O=Buzz Music Entertainment/CN=rancher.bomar.bme.lab" \
      -key ${PWD}/${APP}.key -sha256 \
      -out ${PWD}/${APP}.csr

# Create a v3 ext file for SAN properties
cat > ${PWD}/${APP}.v3.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = rancher.bomar.bme.lab
EOF

# Sign the certificate
${OP} x509 -req -in ${PWD}/${APP}.csr -CA ../${CANAME}/${CANAME}.crt -CAkey ../${CANAME}/${CANAME}.key \
      -CAcreateserial -out ${PWD}/${APP}.crt -days 730 -sha256 -extfile ${PWD}/${APP}.v3.ext
