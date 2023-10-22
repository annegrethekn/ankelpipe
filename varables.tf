variable "deploy_location" {
  default     = "North Europe"
  description = "Location of the resource group."
}
variable "rfc3339" {
  default     = "2023-11-17T12:43:13Z"
  description = "token expiration"

}
variable "rg" {
  type        = string
  default     = "FFIonline"
  description = "Name of the Resource group in which to deploy session host"
}

variable "rdsh_count" {
  description = "Number of AVD machines to deploy"
  default     = 2
}

variable "prefix" {
  type        = string
  default     = "FFIhostpool"
  description = "Prefix of the name of the AVD machine(s)"
}

variable "vm_size" {
  description = "Size of the machine to deploy"
  default     = "Standard_DS1_v2"
}

variable "local_admin_username" {
  type        = string
  default     = "localadm"
  description = "local admin username"
}

/*variable "MaskinNavn" {
  type        = string
  description = "MaskinNavn"
}
*/