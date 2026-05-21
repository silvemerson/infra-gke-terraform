variable "gcp_credentials_file" {
  description = "Caminho para o arquivo JSON de credenciais da service account GCP"
  type        = string
}

variable "gcp_project" {
  description = "ID do projeto GCP para provisionamento da infra"
  type        = string
}

variable "default_region" {
  description = "Região padrão de provisionamento"
  type        = string
  default     = "us-central1"
}

variable "default_zone" {
  description = "Zona padrão de provisionamento"
  type        = string
  default     = "us-central1-c"
}

variable "cluster_name" {
  description = "Nome do cluster GKE"
  type        = string
  default     = "sparta-cluster"
}

variable "node_size" {
  description = "Tipo de máquina dos nodes do cluster GKE"
  type        = string
  default     = "e2-medium"
}

variable "node_count" {
  description = "Número inicial de nodes no pool"
  type        = number
  default     = 1
}

variable "disk_size_gb" {
  description = "Tamanho do disco de cada node em GB"
  type        = number
  default     = 50
}

variable "spot_nodes" {
  description = "Habilitar nodes Spot (preemptíveis) para redução de custo"
  type        = bool
  default     = false
}

variable "min_node_count" {
  description = "Número mínimo de nodes para autoscaling"
  type        = number
  default     = 0
}

variable "max_node_count" {
  description = "Número máximo de nodes para autoscaling"
  type        = number
  default     = 6
}

variable "network_name" {
  description = "Nome da rede VPC utilizada pelo firewall"
  type        = string
  default     = "default"
}

variable "firewall_name" {
  description = "Nome da regra de firewall"
  type        = string
  default     = "asgard-prod-allow"
}

variable "supermario_replicas" {
  description = "Número de réplicas do deployment do Super Mario"
  type        = number
  default     = 2
}
