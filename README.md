# azure-ad-demo-tenant

This repo contains code to configure an Azure AD demo tenant. Using Terraform, PowerShell and Azure CLI to manage various aspects of my demo tenant.

## Terraform

Terraform State in Azure Storage

```bash
 export ARM_ACCESS_KEY=<storage access key>
```

Authenticate to Azure with Service principal for terraform.

```bash
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="10000000-2000-3000-4000-500000000000"
 export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
```
