data "azurerm_key_vault" "vault" {
  name                = "networking-secrets"
  resource_group_name = data.azurerm_resource_group.rg.name
}