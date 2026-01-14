variable "project" {
  type        = string
  description = "The name of the tfscaffold project"
}

variable "environment" {
  type        = string
  description = "The name of the tfscaffold environment"
}

variable "component" {
  type        = string
  description = "Component name"
}

variable "aws_account_id" {
  type        = string
  description = "Account ID"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "connection_name" {
  type        = string
  description = "Connection name"
}

variable "header_name" {
  type        = string
  description = "Header name"
}

variable "header_value" {
  type        = string
  description = "Header value"
}

variable "destination_name" {
  type        = string
  description = "Destination Name"
}

variable "invocation_endpoint" {
  type        = string
  description = "Invocation Endpoint"
}

variable "invocation_rate_limit_per_second" {
  type        = string
  description = "Invocation Rate Limit Per Second"
}

variable "http_method" {
  type        = string
  description = "HTTP Method"
}

variable "client_detail" {
  type        = list(string)
  description = "Client Event Detail"
}

variable "client_bus_name" {
  type        = string
  description = "EventBus name where you create the rule"
}

variable "kms_key_arn" {
  type        = string
  description = "KMS Key ARN"
}
