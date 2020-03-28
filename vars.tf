variable "location" {
  type    = string
  default = "australiaeast"
}

variable ARM_SUBSCRIPTION_ID {}
variable ARM_CLIENT_ID {}
variable ARM_CLIENT_SECRET {}
variable ARM_TENANT_ID {}
variable sshkey {}

variable "resource_group_name" {
  description = "Resources craeted by terraform"
  default     = "terraform-resource-group"
}

variable "application_port" {
    description = "expose port to the external load balancer"
    default     = 3000
}

variable "admin_password" {
    description = "Default password for admin"
    default = "ubuntu"
}

