terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

provider "azurerm" {
subscription_id = "29617337-a06e-4788-96db-e7056df65be8"
 client_id       = "93c3041f-48fb-4f2c-88dc-fc03939d763c"
 client_secret   = "5TC8Q~kmmllM3YAJVEx.XqMueK9D70coj2btwctd"
tenant_id       = "db0cb781-b1c3-4ab8-b789-af161847f80b"
  features {}
}
