resource "azurerm_private_dns_zone" "blobs" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub_blob_link" {
  name                  = "hub-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.blobs.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "delta_lakehouse_databricks_spoke_blob_link" {
  name                  = "delta-lakehouse-databricks-spoke-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.blobs.name
  virtual_network_id    = azurerm_virtual_network.delta_lakehouse_databricks_spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "delta_lakehouse_storage_spoke_blob_link" {
  name                  = "delta-lakehouse-storage-spoke-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.blobs.name
  virtual_network_id    = azurerm_virtual_network.delta_lakehouse_storage_spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "github_runners_blob_link" {
  name                  = "github-runners-blob-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.blobs.name
  virtual_network_id    = azurerm_virtual_network.github_self_hosted_runners.id
}

resource "azurerm_private_dns_zone" "dfs" {
  name                = "privatelink.dfs.core.windows.net"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub_dfs_link" {
  name                  = "hub-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dfs.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "delta_lakehouse_databricks_spoke_dfs_link" {
  name                  = "delta-lakehouse-databricks-spoke-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dfs.name
  virtual_network_id    = azurerm_virtual_network.delta_lakehouse_databricks_spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "delta_lakehouse_storage_spoke_dfs_link" {
  name                  = "delta-lakehouse-storage-spoke-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dfs.name
  virtual_network_id    = azurerm_virtual_network.delta_lakehouse_storage_spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "github_runners_dfs_link" {
  name                  = "github-runners-dfs-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dfs.name
  virtual_network_id    = azurerm_virtual_network.github_self_hosted_runners.id
}