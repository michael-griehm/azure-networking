resource "azurerm_virtual_network" "delta_lakehouse_storage_spoke" {
  name                = "delta-lakehouse-storage-spoke"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/24"]
  tags                = var.tags
}

resource "azurerm_subnet" "storage_private_endpoint" {
  name                 = "storage-private-endpoint"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.delta_lakehouse_storage_spoke.name
  address_prefixes     = ["10.1.0.0/25"]

  enforce_private_link_endpoint_network_policies = true

  service_endpoints = [ "Microsoft.Storage" ]
}

