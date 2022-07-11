resource "azurerm_subnet" "github_self_hosted_runners" {
  name                 = "github-self-hosted-runners"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/24"]

  enforce_private_link_endpoint_network_policies = true
}

resource "random_password" "dlta_lakehouse_runner_password" {
  length      = 24
  min_lower   = 3
  min_upper   = 3
  min_special = 3
  min_numeric = 3
}

resource "azurerm_key_vault_secret" "dlta_lakehouse_runner_admin_password" {
  name         = var.dlta_lakehouse_runner_admin_name
  value        = random_password.dlta_lakehouse_runner_password.result
  key_vault_id = data.azurerm_key_vault.vault.id
}

resource "azurerm_public_ip" "dlta_lakehouse_runner_public_ip" {
  name                = "dlta-lakehouse-runner-public-ip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = var.tags
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "dlta_lakehouse_runner_nic" {
  name                = "dlta-lakehouse-runner-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.github_self_hosted_runners.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dlta_lakehouse_runner_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "dlta_lakehouse_runner" {
  name                            = "dlta-lakehouse-github-runner-vm"
  computer_name                   = "github-runner"
  location                        = data.azurerm_resource_group.rg.location
  resource_group_name             = data.azurerm_resource_group.rg.name
  size                            = "Standard_B2ms"
  admin_username                  = var.dlta_lakehouse_runner_admin_name
  admin_password                  = random_password.dlta_lakehouse_runner_password.result
  disable_password_authentication = false
  tags                            = var.tags

  network_interface_ids = [
    azurerm_network_interface.dlta_lakehouse_runner_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "dlta_lakehouse_runner" {
  virtual_machine_id = azurerm_linux_virtual_machine.dlta_lakehouse_runner.id
  location           = data.azurerm_resource_group.rg.location
  enabled            = true
  tags               = var.tags

  daily_recurrence_time = "1700"
  timezone              = "Eastern Standard Time"

  notification_settings {
    enabled = false
  }
}

