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

variable "eh_ns_name" {
  description = "eh_ns_name"
  type        = string
}

# location
variable "service_name" {
  type        = string
  description = "Name of the services"
}

variable "partition_count" {
  description = "Specifies the  number of partitions for a Kafka topic."
  type        = number
}
variable "message_retention" {
  description = "Specifies the  number of message_retention "
  type        = number
}
