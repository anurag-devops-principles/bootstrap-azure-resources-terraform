variable "subscription_id" {
  description = "The Azure Subscription ID where resources will be created."
  type        = string
}

variable "resource_group" {
  description = "The name of the resource group to create."
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
}
