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

resource "azurerm_subnet" "dbx_public" {
  name                 = "dbx-public"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.delta_lakehouse_databricks_spoke.name
  address_prefixes     = ["10.2.0.0/24 "]

  enforce_private_link_endpoint_network_policies = true

  delegation {
    name = "delegation"

    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

resource "azurerm_subnet" "dbx_private" {
  name                 = "dbx-private"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.delta_lakehouse_databricks_spoke.name
  address_prefixes     = ["10.2.1.0/24 "]

  enforce_private_link_endpoint_network_policies = true

  delegation {
    name = "delegation"

    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}