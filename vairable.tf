variable "resourceGroupName"{
    type = string
}

variable "location"{
    type = string
}
variable "vnet_name" {
  description = "Name of the vnet to create"
  type        = string
  default     = "acctvnet"
}
variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.0.0.0/16"]
}
variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  default     = ["subnet1", "subnet2", "subnet3"]
}
variable "nic_name" {
  type = string
}
variable "ip_configuration_name" {
  type = string
}
variable "vm_name" {
  type = string
}

variable "admin_username" {
     type = string
}
variable "admin_password" {
     type = string
}

