#!/bin/bash
ARTIFACT=`packer build -machine-readable packer/azure-ubuntu-nodejs.json | grep 'Image Name'`
AMI_ID=`echo $ARTIFACT | awk -F "'" '{print $2}'`
echo $AMI_ID
# echo 'data "azurerm_image" "image" {
#   name                = "'${AMI_ID}'"
#   resource_group_name = data.azurerm_resource_group.image.name
# }' > imagename.tf
