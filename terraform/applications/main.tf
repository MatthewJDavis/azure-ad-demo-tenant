terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-state"
    storage_account_name  = "mdterraform"
    container_name        = "demo-state"
    key                   = "aadapps.tfstate"
  }
}

provider "azuread" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider to be used
  version = "=1.5.0"
}

variable "app_password" {  
  description = "Used for application secret"  
  type        = string  
  sensitive   = true
}

resource "azuread_application" "demo" {
  display_name = "DemoApp1"
  homepage                   = "http://localhost"
  identifier_uris            = ["http://localhost"]
  reply_urls                 = ["http://localhost"]
  available_to_other_tenants = false

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }

}

resource "azuread_application_password" "demo" {
  application_object_id = azuread_application.demo.object_id
  value = var.app_password
  display_name = "testcred"
}

resource "azuread_service_principal" "demo" {
  application_id               = azuread_application.demo.application_id
  app_role_assignment_required = false

  tags = ["example", "tags", "here"]
}

resource "azuread_service_principal_password" "demo" {
  service_principal_id = azuread_service_principal.demo.object_id
}