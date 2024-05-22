# create public subnets
resource "azurerm_subnet" "public_subnet" {
  name                 = "subnet-${var.subnet_name}"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnet_address_prefix
}


# create network security group
resource "azurerm_network_security_group" "public_nsg" {
  name                = "nsg-${var.subnet_name}-${var.proj_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.rg_name
  depends_on          = [var.vnet_name]

  security_rule {
    name                       = "http_rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https_rule"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
  }
}




# associate NSG to public subnets
resource "azurerm_subnet_network_security_group_association" "nsg_associate_public" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.public_nsg.id
}

