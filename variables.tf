
variable "ENV" {
  description = "Name of the environment to depploy resources"
  type        = string
}

variable "APP" {
  description = "Name of the app"
  type        = string
  default     = "core-networking"
}

variable "OWNER" {
  description = "Name of the owner"
  type        = string
  default     = "ICT Infrastructure"
}

variable "DEPLOY" {
  description = "Tools used to deploy"
  type        = string
  default     = "Terraform"
}

variable "resource_group_name" {
  type = string
  default = "core-networking"
}

variable "location" {
  description = "Name of the region to deploy"
  type = string
  default = "australiaeast"
}

variable "address_space" {
  description = "Address space of the vnet"
  type = string
}

variable "subnet_prefixes" {
  description = "List of subnet IPs"
  type = list
}

variable "subnet_names" {
  description = "Name of subnets"
  type = list
}
