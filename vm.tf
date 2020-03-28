resource "azurerm_linux_virtual_machine" "vmssvm" {
    name                  = "weatherappvm"
    location              = var.location
    resource_group_name   = azurerm_resource_group.vmss.name
    network_interface_ids = [azurerm_network_interface.vmss.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "vmdisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_id=data.azurerm_image.image.id

    computer_name  = "weatherappvm"
    admin_username = "azureuser"
    disable_password_authentication = true
        
    admin_ssh_key {
        username       = "azureuser"
        public_key     = var.sshkey
    }

    # boot_diagnostics {
    #     storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    # }

    tags = {
    environment = "demo"
    costcenter = "007"
    team = "presales"
    owner = "rohitg"
    function = "api"
  }
}