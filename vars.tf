variable "location" {
  type    = string
  default = "australiaeast"
}

variable ARM_SUBSCRIPTION_ID {}
variable ARM_CLIENT_ID {}
variable ARM_CLIENT_SECRET {}
variable ARM_TENANT_ID {}

variable "resource_group_name" {
  description = "Resources craeted by terraform"
  default     = "terraformResourceGroup"
}
