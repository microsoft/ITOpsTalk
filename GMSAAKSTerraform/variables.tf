variable "resource_group" {
    type = string
    description = "Resource group name"
    default = "58TestRG"
}

variable "location" {
    type = string
    description = "RG and resources location"
    default = "East US"
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

variable "win_username" {
  description = "Windows node username"
  type        = string
  sensitive   = false
}

variable "win_userpass" {
  description = "Windows node password"
  type        = string
  sensitive   = true
}

variable "Domain_DNSName" {
  description = "FQDN for the Active Directory forest root domain"
  type        = string
  sensitive   = false
}

variable "netbios_name" {
  description = "NETBIOS name for the AD domain"
  type        = string
  sensitive   = false
}

variable "SafeModeAdministratorPassword" {
  description = "Password for AD Safe Mode recovery"
  type        = string
  sensitive   = true
}

variable "gmsa_username" {
  description = "Username for the standard domain account"
  type        = string
  sensitive   = false
}

variable "gmsa_userpassword" {
  description = "Password for standard domain account"
  type        = string
  sensitive   = true
}