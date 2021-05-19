data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                     = var.name
  location                 = var.location
  resource_group_name      = var.resource_group
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false
  sku_name                 = "standard"
  tags                     = var.tags
}





resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.name}"
  address_space       = [var.vnet_range]
  location            = var.location
  resource_group_name = var.resource_group
  tags                = var.tags
}

resource "azurerm_subnet" "subnet-endpoint" {
  name                                           = "subnet-endpoint-${var.name}"
  resource_group_name                            = var.resource_group
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [var.subnet_endpoint_range]
  enforce_private_link_service_network_policies  = true
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_private_endpoint" "pep" {
  name                = "pep-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = azurerm_subnet.subnet-endpoint.id
  tags                = var.tags
  private_service_connection {
    name                           = var.name
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "privatelink.${var.name}.azure.net"
  resource_group_name = var.resource_group
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_link" {
  name                  = "link-${var.name}"
  resource_group_name   = var.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}


resource "azurerm_private_dns_a_record" "record_dns" {
  name                = "keyvault"
  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = var.resource_group
  ttl                 = 300
  records             = [azurerm_private_endpoint.pep.private_service_connection[0].private_ip_address]
}
