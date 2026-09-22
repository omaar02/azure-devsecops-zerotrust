variable "resource_group_name" {
  description = "The name of the resource group"
  default     = "rg-sc500-devsecops"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  default     = "westeurope"
  type        = string
}

variable "unique_suffix" {
  description = "Unique suffix for the Key Vault name (max 5 alphanumeric characters)"
  default     = "oma01"
  type        = string
}
