variable "proj_name" {
  description = "Project name"
  type        = string
}

variable "location" {
  description = "Location for the Event Hub"
  type        = string
}

variable "rg_name" {
  description = "Resource group name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "workspace_sku" {
  description = "(Optional) Specifies the sku of the log analytics workspace"
  type        = string
}

variable "workspaces" {
  description = "A map of workspaces and their associated solutions"
  type = map(object({
    retention_days    = number
    solution_name = string
    solution_plan_map = map(object({
      product   = string
      publisher = string
    }))
  }))
}
