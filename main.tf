locals {
  common_tags = {
    APP   = "${var.APP}"
    ENV   = "${var.ENV}"
    OWNER = "${var.OWNER}"
  }
  extra_tags  = {
    DEPLOY = "${var.DEPLOY}"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-${var.ENV}-RG"
  location = var.location
  tags = "${merge( local.common_tags, local.extra_tags)}"
}

# https://registry.terraform.io/modules/Azure/vnet/azurerm/1.0.0
module "network" {
    source              = "Azure/vnet/azurerm"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    address_space       = var.address_space "10.0.0.0/16"
    subnet_prefixes     = var.subnet_prefixes ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    subnet_names        = var.subnet_names ["subnet1", "subnet2", "subnet3"]

    tags = "${merge( local.common_tags, local.extra_tags)}"
}

/*

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "VNET-learntf"
    address_space       = ["10.0.0.0/8"]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    tags = azurerm_resource_group.rg.tags
}

*/