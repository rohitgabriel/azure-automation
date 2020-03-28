# data "azurerm_image" "image" {
#   name                = "packer-ubuntu18-weatherapp_1585357450"
#   resource_group_name = data.azurerm_resource_group.image.name
# }
data "azurerm_image" "image" { 
    name = "packer-ubuntu18-weatherapp_1585357450" 
    resource_group_name = data.azurerm_resource_group.image.name
}