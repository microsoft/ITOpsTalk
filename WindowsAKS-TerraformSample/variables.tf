variable "resource_group" {
    type = string
    description = "Resource group name"
    default = "TestRG"
}

variable "location" {
    type = string
    description = "RG and resources location"
    default = "West US"
}

variable "node_count_linux" {
    type = number
    description = "Linux nodes count"
    default = 1
}

variable "node_count_windows" {
    type = number
    description = "Windows nodes count"
    default = 2
}