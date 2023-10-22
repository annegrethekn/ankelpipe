
resource "random_string" "AVD_local_password" {
  count            = var.rdsh_count
  length           = 16
  special          = true
  min_special      = 2
  override_special = "*!@#?"
}

data "azurerm_resource_group" "rg" {
  provider = azurerm
  name     = var.rg
  }

resource "azurerm_network_interface" "FFIpool_nic" {
  provider            = azurerm
  count               = var.rdsh_count
  name                = "${var.prefix}-${count.index + 1}-nic"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "nic${count.index + 1}_config"
    subnet_id                     = data.azurerm_subnet.onlinepoolsubnet01.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    data.azurerm_resource_group.rg,
    azurerm_virtual_network_peering.tilaad
  ]
}

resource "azurerm_windows_virtual_machine" "FFIVm" {
  provider              = azurerm
  count                 = var.rdsh_count
  name                  = "${var.prefix}-${count.index + 1}"
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  size                  = var.vm_size
  network_interface_ids = ["${azurerm_network_interface.FFIpool_nic.*.id[count.index]}"]

  provision_vm_agent    = true
  admin_username        = var.local_admin_username
  admin_password        = random_password.pol3passord.result
  #license_type  = "Windows_CLient"

  os_disk {
    name                 = "${lower(var.prefix)}-${count.index + 1}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  identity {
    type = "SystemAssigned"
  }

  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "office-365"
    sku       = "win11-21h2-avd-m365"
    version   = "latest"

  }


/*source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "20h2-evd"
    version   = "latest"
   }
   */
   depends_on = [
    data.azurerm_resource_group.rg,
    azurerm_network_interface.FFIpool_nic
 ]

}

resource "azurerm_virtual_machine_extension" "vmext_dsc" {
  count                      = var.rdsh_count
  name                       = "${var.prefix}${count.index + 1}-avd_dsc"
  virtual_machine_id         = azurerm_windows_virtual_machine.FFIVm.*.id[count.index]
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "AADLoginForWindows" {
  count                      = var.rdsh_count
  name                       = "AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.FFIVm.*.id[count.index]
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "2.0"
  auto_upgrade_minor_version = false
}


/*settings = <<SETTINGS
 {
  "mdmId" : "0000000a-0000-0000-c000-000000000000"
 }
SETTINGS
}
*/
  resource "random_password" "pol3passord" {
  length  = 20
  special = true
}