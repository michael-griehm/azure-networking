resource "azurerm_virtual_network" "delta_lakehouse_databricks_spoke" {
  name                = "delta-lakehouse-databricks-spoke"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.2.0.0/16"]
  tags                = var.tags
}

resource "azurerm_virtual_network_peering" "delta_lakehouse_databricks_spoke_to_hub" {
  name                      = "delta-lakehouse-databricks-spoke-to-hub"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.delta_lakehouse_databricks_spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
}