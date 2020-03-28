output "vmss_public_ip" {
    value = azurerm_public_ip.vmss.fqdn
}

output "vmssvm_public_ip" {
    value = azurerm_public_ip.vmssvm.vmssvm_public_ip
}


