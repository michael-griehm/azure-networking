resource "azurerm_virtual_network" "github_self_hosted_runners" {
  name                = "github-self-hosted-runners"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.1.1.0/24"]
  tags                = var.tags
}

resource "azurerm_virtual_network_peering" "github_self_hosted_runners_to_hub" {
  name                      = "github-self-hosted-runners-to-hub"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.delta_lakehouse_databricks_spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
}

resource "azurerm_subnet" "ubuntu" {
  name                 = "ubuntu"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.delta_lakehouse_databricks_spoke.name
  address_prefixes     = ["10.1.1.0/25"]

  enforce_private_link_endpoint_network_policies = true
}

resource "random_password" "password" {
  length      = 24
  min_lower   = 3
  min_upper   = 3
  min_special = 3
  min_numeric = 3
}

data "azurerm_key_vault" "vault" {
  name                = "networking-secrets"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_key_vault_secret" "stored_secret" {
  name         = var.github_runner_admin_name
  value        = random_password.password.result
  key_vault_id = data.azurerm_key_vault.vault.id
}

resource "azurerm_network_interface" "nic" {
  name                = "github-runner-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ubuntu.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "github-runner-vm"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  size                = "Standard_B2ms"
  admin_username      = var.github_runner_admin_name
  admin_password      = random_password.password.result

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}