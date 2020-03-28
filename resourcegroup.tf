resource "azurerm_resource_group" "vmss" {
  name = var.resource_group_name
  location = var.location
  tags {
    environment = "demo"
    costcenter = "007"
  }
}