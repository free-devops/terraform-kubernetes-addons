variable "cluster-name" {
  description = "Name of the Kubernetes cluster"
  default     = "sample-cluster"
  type        = string
}

variable "eks" {
  description = "EKS cluster inputs"
  type        = any
  default     = {}
}

variable "helm_defaults" {
  description = "Customize default Helm behavior"
  type        = any
  default     = {}
}

variable "metricbeat" {
  description = "Customize metricbeat chart, see `metricbeat.tf` for supported values"
  type        = any
  default     = {}
}

variable "filebeat" {
  description = "Customize filebeat chart, see `filebeat.tf` for supported values"
  type        = any
  default     = {}
}

variable "externalsecrets" {
  description = "Customize external-secrets chart, see `external-secrets.tf` for supported values"
  type        = any
  default     = {}
}

variable "pusher_wave" {
  description = "Customize pusher-wave, see `pusher-wave.tf` for supported values"
  type        = any
  default     = {}
}

variable "priority_class" {
  description = "Customize a priority class for addons"
  type        = any
  default     = {}
}

variable "priority_class_ds" {
  description = "Customize a priority class for addons daemonsets"
  type        = any
  default     = {}
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}