resource "azurerm_lb" "vmss" {
  name                = "vmss-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.vmss.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.vmss.id
  }

  tags = {
    environment = "demo"
    costcenter = "007"
    team = "presales"
    owner = "rohitg"
    function = "api"
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = azurerm_resource_group.vmss.name
  loadbalancer_id     = azurerm_lb.vmss.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "vmss" {
  resource_group_name = azurerm_resource_group.vmss.name
  loadbalancer_id     = azurerm_lb.vmss.id
  name                = "ssh-running-probe"
  port                = var.application_port
}

resource "azurerm_lb_rule" "lbnatrule" {
  resource_group_name            = azurerm_resource_group.vmss.name
  loadbalancer_id                = azurerm_lb.vmss.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = var.application_port
  backend_port                   = var.application_port
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.vmss.id
}

data "azurerm_resource_group" "image" {
  name = "rg-auseast-1"
}

# resource "azurerm_linux_virtual_machine_scale_set" "vmss-linux" {
#   name                = "vmss-linux"
#   resource_group_name = azurerm_resource_group.vmss.name
#   location            = var.location
#   sku                 = "Standard_DS1_v2"
#   instances           = 1
#   admin_username      = "ubuntu"

#   admin_ssh_key {
#     username   = "ubuntu"
#     public_key = var.sshkey
#   }

#   source_image_id=data.azurerm_image.image.id
  

#   os_disk {
#     storage_account_type = "Standard_LRS"
#     caching              = "ReadWrite"
#   }

#   network_interface {
#     name    = "vmsslinuxprofile"
#     primary = true

#     ip_configuration {
#       name      = "vmsslinuxipconfiguration"
#       primary   = true
#       subnet_id = azurerm_subnet.vmss.id
#     }
#     # public_ip_address {
#     #   name                                 = "PublicIPConfiguration"
#     #   idle_timeout                         = "30"
#     #   domain_name_label                    = azurerm_resource_group.vmss.name
#     # }
#   }
  
# }

resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "vmscaleset"
  location            = var.location
  resource_group_name = azurerm_resource_group.vmss.name
  upgrade_policy_mode = "Manual"

  sku {
    name     = "Standard_DS1_v2"
    tier     = "Standard"
    capacity = 1
  }

  storage_profile_image_reference {
    id=data.azurerm_image.image.id
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun          = 0
    caching        = "ReadWrite"
    create_option  = "Empty"
    disk_size_gb   = 20
  }

  os_profile {
    computer_name_prefix = "weatherappnode"
    admin_username       = "ubuntu"
    admin_password       = "ubuntu"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = var.sshkey
    }
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "IPConfiguration"
      subnet_id                              = azurerm_subnet.vmss.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      primary = true
    }
  }

#   public_ip_address_configuration {
#         name                                 = "PublicIPConfiguration"
#         idle_timeout                         = "30"
#         domain_name_label                    = azurerm_resource_group.vmss.name
#     }
  
  tags = {
    environment = "demo"
    costcenter = "007"
    team = "presales"
    owner = "rohitg"
    function = "api"
  }
}