terraform {
  required_providers {
    azurerm = "~> 2.33"
    azuread = "~>2.0"
  }

  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}

variable "app_name" {
  default   = "networking"
  type      = string
  sensitive = false
}

variable "env" {
  default   = "demo"
  sensitive = false
}

variable "location" {
  default   = "East US 2"
  sensitive = false
  type      = string
}

variable "tags" {
  type = map(string)

  default = {
    application = "networking"
    environment = "demo"
    workload    = "shared-services"
  }
}

variable "admin_user_principal_name" {
  type        = string
  sensitive   = true
  description = "The user principal name of the admin for the app."
  default     = "mikeg@ish-star.com"
}

variable "dlta_lakehouse_runner_admin_name" {
  type        = string
  sensitive   = true
  description = "The name of the admin for the github runner vm."
  default     = "dlta-lakehouse-runner-admin"
}

variable "jumpbox_admin_name" {
  type        = string
  sensitive   = true
  description = "The name of the admin for the github runner vm."
  default     = "jbx-admin"
}

locals {
  loc            = lower(replace(var.location, " ", ""))
  a_name         = replace(var.app_name, "-", "")
  fqrn           = "${var.app_name}-${var.env}-${local.loc}"
  fqrn_condensed = "${length(local.a_name) > 22 ? substr(local.a_name, 0, 22) : local.a_name}${substr(local.loc, 0, 1)}${substr(var.env, 0, 1)}"
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = local.fqrn
}