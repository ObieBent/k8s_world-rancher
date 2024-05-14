## Restoration Process of Rancher Manager 

### Prerequisites 
- Perform a backup of Rancher Manager System 

### Restoration 
1- Install a new cluster kubernetes (RKE/RKE2, k3s)
2- Install the CRDs of Rancher Backup 
3- Install the Rancher Backup Operator 
4- Create the secret for accessing to the S3 bucket 
5- Create the secret 'encryptionconfig' in order to retrieve the encrypted backup file located in the S3 bucket 
6- Deploy the 'restore' manifest 
7- Install Rancher Manager 
  1. Install Cert-Manager 
  2. Install Rancher Manager System 
