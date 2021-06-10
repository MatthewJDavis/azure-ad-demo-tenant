terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-state"
    storage_account_name  = "mdterraform"
    container_name        = "demo-state"
    key                   = "aadgroups.tfstate"
  }
}

provider "azuread" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider to be used
  version = "=1.5.0"
}


resource "azuread_group" "tier0" {
  display_name = "tier-zero"
  members = ["179c49a5-3acd-40d0-a55e-8f7288462c23"]
  description = "Tier Zero users."
  prevent_duplicate_names = true
}

resource "azuread_group" "security" {
  display_name = "security-team"
  description = "Security team."
  prevent_duplicate_names = true
}

resource "azuread_group" "identity" {
  display_name = "identity-team"
  description = "Identity team."
  prevent_duplicate_names = true
}

resource "azuread_group" "developers" {
  display_name = "developers"
  description = "All Developers."
  prevent_duplicate_names = true
}