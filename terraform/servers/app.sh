# Create sp for terraform with contributor rights to sub

az login

az account list

az account set --subscription=""

az ad sp create-for-rbac --name terraform-contributor --role="Contributor" --scopes="/subscriptions/"