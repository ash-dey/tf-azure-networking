# https://registry.terraform.io/modules/Azure/vnet/azurerm/latest

resource "azurerm_resource_group" "vnet" {
  name     = "${var.resource_group_name}-${var.env}-RG"
  location = var.rg_location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name != null ? var.vnet_name : "${var.resource_group_name}-${var.env}-vnet"
  resource_group_name = azurerm_resource_group.vnet.name
  location            = var.vnet_location != null ? var.vnet_location : azurerm_resource_group.vnet.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = merge(var.common_tags, var.extra_tags)
}

resource "azurerm_subnet" "subnet" {
  count                                          = length(var.subnet_names)
  name                                           = "${var.subnet_names[count.index]}-${var.env}"
  resource_group_name                            = azurerm_resource_group.vnet.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [var.subnet_prefixes[count.index]]
  service_endpoints                              = lookup(var.subnet_service_endpoints, var.subnet_names[count.index], null)
  enforce_private_link_endpoint_network_policies = lookup(var.subnet_enforce_private_link_endpoint_network_policies, var.subnet_names[count.index], false)
  enforce_private_link_service_network_policies  = lookup(var.subnet_enforce_private_link_service_network_policies, var.subnet_names[count.index], false)

  dynamic "delegation" {
    for_each = lookup(var.subnet_delegation, var.subnet_names[count.index], {})
    content {
      name = delegation.key
      service_delegation {
        name    = lookup(delegation.value, "service_name")
        actions = lookup(delegation.value, "service_actions", [])
      }
    }
  }
}

locals {
  azurerm_subnets = {
    for index, subnet in azurerm_subnet.subnet :
    subnet.name => subnet.id
  }
}

resource "azurerm_subnet_network_security_group_association" "vnet" {
  for_each                  = var.nsg_ids
  subnet_id                 = local.azurerm_subnets[each.key]
  network_security_group_id = each.value
}

resource "azurerm_subnet_route_table_association" "vnet" {
  for_each       = var.route_tables_ids
  route_table_id = each.value
  subnet_id      = local.azurerm_subnets[each.key]
}
