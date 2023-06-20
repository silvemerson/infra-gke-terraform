variable "gcp_project" {
  description = "Projeto para provisionamento da infra"
  type        = string
  default     = "ID_PROJECT" #Project ID
}

variable "default_region" {
  description = "Região padrão de provisionamento"
  type        = string
  default     = "us-central1"
}

variable "default_zone" {
  description = "Região padrão de provisionamento"
  type        = string
  default     = "us-central1-c"
}


variable "node_size" {
  default     = "e2-medium"
  type        = string
  description = "Tamanho dos nodes do cluster gke"
}
