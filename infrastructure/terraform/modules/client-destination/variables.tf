variable "project" {
  type        = string
  description = "The name of the tfscaffold project"
}

variable "environment" {
  type        = string
  description = "The name of the tfscaffold environment"
}

variable "component" {
  type = string
  description = "Component name"
}

variable "connection_name" {
   type = string
  description = "Connection name"
}

variable "header_name" {
  type = string
  description = "Header name"
}

variable "header_value" {
  type = string
  description = "Header value"
}

variable "destination_name" {
  type = string
  description = "Destination Name"
}

variable "invocation_endpoint" {
  type = string
  description = "Invocation Endpoint"
}

variable "invocation_rate_limit_per_second" {
  type = string
  description = "Invocation Rate Limit Per Second"
}

variable "http_method" {
  type = string
  description = "HTTP Method"
}
