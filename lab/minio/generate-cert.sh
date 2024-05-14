#!/bin/bash 
#
# Install certgen 
curl -LO https://github.com/minio/certgen/releases/latest/download/certgen-linux-amd64 
file certgen-linux-amd64 
mv certgen-linux-amd64 /usr/local/bin/certgen 
chmod u+x /usr/local/bin/certgen 

# Generate public cert and private key 
certgen -host "localhost,minio.*.nip.io,hauler.bomar.bme.lab" 

# Check the certificate 
openssl x509 -in public.crt -noout -dates
