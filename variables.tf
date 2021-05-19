# Variables obligatoires :
###############################################

variable "name" {
  description = "Name for each resources"
  type        = string
}

variable "resource_group" {
  description = "Name of the resource_group"
  type        = string
}




# Variables facultatives :
###############################################

variable "location" {
  description = "Location for the resources"
  type        = string
  default     = "westeurope"
}

variable "vnet_range" {
  description = "cidr for the vnet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_endpoint_range" {
  description = "cidr for the endpoint subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "tags" {
  description = "List of tags"
  type        = map(any)
  default     = {}
}