variable "subnet_name" {
    description = "The name of the subnet to be created"
    type = string
}
variable "resource_group_name" {
    description = "The name of the resource group in which subnet will create"
    type = string
}
variable "virtual_network_name" {
    description = "The name of the virtual network in which subnet will create"
    type = string
}
variable "address_prefixes" {
    description = "The name of address prefixes"
    type = list(string)
}