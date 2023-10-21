
data "azurerm_resource_group" "ffionline"{
  name = var.rg
   depends_on = [ data.azurerm_resource_group.ffionline]
}

data "azurerm_resource_group" "ManageDomain"{
  provider = azurerm.ManageSubscription
  name = "ManageDomain"
}

data "azurerm_virtual_network" "ffionlinepoolnet" {
  name                = "ffionlinepoolnet"
  resource_group_name = "ffionline"
}

data "azurerm_subnet" "onlinepoolsubnet01" {
  name                 = "onlinepoolsubnet01"
  virtual_network_name = "ffionlinepoolnet"
  resource_group_name = "ffionline"
}


data "azurerm_resource_group" "Managedomain" {
  provider = azurerm.ManageSubscription
    name = "ManageDomain"
}

data "azurerm_virtual_network" "aadds-vnet" {
  provider = azurerm.ManageSubscription
    name                = "aadds-vnet-02"
  resource_group_name = data.azurerm_resource_group.Managedomain.name
  }


resource "azurerm_virtual_network_peering" "tilaad" {
provider = azurerm.ManageSubscription
  name                      = "tilaad02"
  resource_group_name       = data.azurerm_resource_group.ManageDomain.name
  virtual_network_name      = data.azurerm_virtual_network.aadds-vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.ffionlinepoolnet.id
}
