#!/bin/bash
ARTIFACT=`packer build -machine-readable packer/azure-ubuntu-nodejs.json | grep 'Image Name'`
AMI_ID=`echo $ARTIFACT | awk -F "'" '{print $2}'`
echo 'data "azurerm_image" "image" { name = "packer-ubuntu18-weatherapp_1585357450" resource_group_name = data.azurerm_resource_group.image.name}' > imagename.tf
echo 'variable "AMI_ID" { default = "'${AMI_ID}'" }' > imagename.tf


data "azurerm_image" "image" {
  name                = "packer-ubuntu18-weatherapp_1585357450"
  resource_group_name = data.azurerm_resource_group.image.name
}
