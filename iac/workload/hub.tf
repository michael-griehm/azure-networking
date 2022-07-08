resource "azurerm_virtual_network" "hub" {
  name                = "hub"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

resource "azurerm_virtual_network_peering" "hub_to_delta_lakehouse_spoke" {
  name                      = "hub-to-delta-lakehouse-spoke"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.delta_lakehouse_spoke.id
}

