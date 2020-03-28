#!/bin/bash
ARTIFACT=`packer build -machine-readable packer/azure-ubuntu-nodejs.json | grep 'Image Name'`
AMI_ID=`echo $ARTIFACT | awk -F "'" '{print $2}'`
echo 'variable "AMI_ID" { default = "'${AMI_ID}'" }' > ami.tf



