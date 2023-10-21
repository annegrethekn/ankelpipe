
data "azurerm_resource_group" "ffionline"{
  name = var.rg
   depends_on = [ azurerm_resource_group.ffionline,
                 azurerm_virtual_desktop_host_pool.ffihostpool ]
}

data "azurerm_resource_group" "ManageDomain"{
  provider = azurerm.ManageSubscription
  name = "ManageDomain"
}

resource "azurerm_virtual_network" "ffionlinepoolnet" {
  name                = "ffionlinepoolnet"
 location = data.azurerm_resource_group.ffionline.location
 resource_group_name = data.azurerm_resource_group.ffionline.name
 address_space       = ["192.168.0.0/16"]


depends_on = [
  data.azurerm_resource_group.ffionline
]
}

resource "azurerm_subnet" "onlinepoolsubnet01" {
  name                 = "onlinepoolsubnet01"
  address_prefixes = ["192.168.0.0/18"]
  virtual_network_name = azurerm_virtual_network.ffionlinepoolnet.name
  resource_group_name  = data.azurerm_resource_group.ffionline.name
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
  remote_virtual_network_id = azurerm_virtual_network.ffionlinepoolnet.id
}
