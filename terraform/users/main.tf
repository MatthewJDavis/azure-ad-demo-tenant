terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state"
    storage_account_name = "mdterraform"
    container_name       = "demo-state"
    key                  = "aadusers.tfstate"
  }
}

provider "azuread" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider to be used
  version = "=1.5.0"
}

variable "user_password" {
  description = "User password from env vars"
  type        = string
  sensitive   = true
}

resource "azuread_user" "cm" {
  user_principal_name = "corban.morley@matthewdavis111.com"
  display_name        = "Corban Morley"
  given_name          = "Corban"
  surname             = "Morley"
  job_title           = "HR"
  department          = "Human Resources"
  password            = var.user_password
  company_name        = "MDInc"
  country             = "Canada"
}

resource "azuread_user" "tm" {
  user_principal_name = "teddy.mooney@matthewdavis111.com"
  display_name        = "Teddy Mooney"
  given_name          = "Teddy"
  surname             = "Mooney"
  job_title           = "Security Director"
  department          = "Info Security"
  password            = var.user_password
  company_name        = "MDInc"
  country             = "Canada"
}


resource "azuread_user" "bs" {
  user_principal_name = "bethaney.stafford@matthewdavis111.com"
  display_name        = "Bethaney Stafford"
  given_name          = "Bethaney"
  surname             = "Stafford"
  job_title           = "Security Specialist"
  department          = "Info Security"
  password            = var.user_password
  company_name        = "MDInc"
  country             = "Canada"
}

resource "azuread_user" "ag" {
  user_principal_name = "alan.gardiner@matthewdavis111.com"
  display_name        = "Alan Gardiner"
  given_name          = "Alan"
  surname             = "Gardiner"
  job_title           = "Lead Developer"
  department          = "Web Devs"
  password            = var.user_password
  company_name        = "MDInc"
  country             = "UK"
}
