resource "azurerm_virtual_network" "delta_lakehouse_spoke" {
  name                = "delta-lakehouse-spoke"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "dbx_public" {
  name                 = "dbx-public"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.delta_lakehouse_spoke.name
  address_prefixes     = ["10.1.0.0/24"]

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
  virtual_network_name = azurerm_virtual_network.delta_lakehouse_spoke.name
  address_prefixes     = ["10.1.1.0/24"]

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

resource "azurerm_subnet" "storage_private_endpoint" {
  name                 = "storage-private-endpoint"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.delta_lakehouse_spoke.name
  address_prefixes     = ["10.1.2.0/24"]

  enforce_private_link_endpoint_network_policies = true

  service_endpoints = ["Microsoft.Storage"]
}
