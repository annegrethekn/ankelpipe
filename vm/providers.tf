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
subscription_id = "aa6c6a01-bc84-4fe7-b193-310f625fccb7"
 client_id       = "4f292588-db7c-456f-9751-14899665ce82"
 client_secret   = "_NK8Q~pW8SivNWoxy9DiaQBtVZJTvwgTy0fdNaW0"
tenant_id       = "96ed6af4-4684-4447-990e-555e53c1af9e"
  features {}
}
provider "azurerm" {
  features {}
  alias           = "ManageSubscription"
  subscription_id = "2007a437-5847-47b4-8207-241e3016edf3"
}