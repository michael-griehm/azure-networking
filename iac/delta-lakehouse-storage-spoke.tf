resource "azurerm_virtual_network" "delta_lakehouse_storage_spoke" {
  name                = "delta-lakehouse-storage-spoke"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/24"]
  tags                = var.tags
}