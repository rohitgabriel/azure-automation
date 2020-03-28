resource "azurerm_network_security_group" "vmss" {
    name                = "vmss-secgrp"
    location            = var.location
    resource_group_name = azurerm_resource_group.vmss.name

    security_rule {
        name                       = "HTTP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3000"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "SSH"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = var.ssh-source-address
        destination_address_prefix = "*"
    }
    tags = {
      environment = "demo",
      costcenter = "007"
    }
}

resource "azurerm_public_ip" "vmssvm" {
    name                         = "vmss-vm-ip"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.vmss.name
    allocation_method            = "Dynamic"

    tags = {
      environment = "demo",
      costcenter = "007"
    }
}

resource "azurerm_network_interface" "vmss" {
    name                        = "vmss-publicnic"
    location                    = var.location
    resource_group_name         = azurerm_resource_group.vmss.name

    ip_configuration {
        name                          = "vmss-publicnic-configuration"
        subnet_id                     = "${azurerm_subnet.vmss.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.vmssvm.id}"
    }

    tags = {
      environment = "demo",
      costcenter = "007"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "vmss" {
    network_interface_id      = azurerm_network_interface.vmss.id
    network_security_group_id = azurerm_network_security_group.vmss.id
}