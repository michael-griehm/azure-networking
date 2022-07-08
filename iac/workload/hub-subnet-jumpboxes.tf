resource "azurerm_subnet" "jumboxes" {
  name                 = "jumboxes"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.2.0/24"]

  enforce_private_link_endpoint_network_policies = true
}

resource "random_password" "jumpbox_password" {
  length      = 24
  min_lower   = 3
  min_upper   = 3
  min_special = 3
  min_numeric = 3
}

resource "azurerm_key_vault_secret" "jumpbox_admin_password" {
  name         = var.jumpbox_admin_name
  value        = random_password.jumpbox_password.result
  key_vault_id = data.azurerm_key_vault.vault.id
}

resource "azurerm_public_ip" "jumpbox_ip" {
  name                = "jumpbox-public-ip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = var.tags
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "jumpbox_nic" {
  name                = "jumpbox-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jumboxes.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox_ip.id
  }
}

resource "azurerm_windows_virtual_machine" "jumbox" {
  name                = "jumpbox"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  size                = "Standard_B2ms"
  admin_username      = var.jumpbox_admin_name
  admin_password      = random_password.jumpbox_password.result
  tags                = var.tags

  network_interface_ids = [
    azurerm_network_interface.jumpbox_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "jumbox" {
  virtual_machine_id = azurerm_windows_virtual_machine.jumbox.id
  location           = data.azurerm_resource_group.rg.location
  enabled            = true
  tags               = var.tags

  daily_recurrence_time = "1700"
  timezone              = "Eastern Standard Time"

  notification_settings {
    enabled = false
  }
}