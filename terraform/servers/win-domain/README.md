# Create 2 Servers in Azure and configure test domain and Sync server form Azure AD Connect

## Stand up servers using Terraform

State is saved in Azure blobstorage. Service principal is used to connect to Azure.

```bash
 export ARM_ACCESS_KEY=

export ARM_SUBSCRIPTION_ID=""
export ARM_CLIENT_ID=""
export ARM_TENANT_ID=""
 export ARM_CLIENT_SECRET=""
```

Create secrets.tfvar file and complete variable values.

```bash
admin_password = 
my_ip = 
```

```bash
terraform apply --auto-approve -var-file="secrets.tfvars"
```

## PowerShell for Domain

Run New-MDDomain.ps1 on one server to create the domain.

Create domain admin account.

## PowerShell for Sync server

Run New-MDSync.ps1  - need to update IP address of DC once known.

Manual install for Azure AD connect.

Use Enterprise Admin account to configure Azure AD connect.

## Install Azure AD connect health for DS

http://go.microsoft.com/fwlink/?LinkID=820540
