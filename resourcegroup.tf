resource "azurerm_resource_group" "rg" {
        name = "terraformResourceGroup"
        location = var.location
}