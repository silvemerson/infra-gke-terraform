output "cluster_name" {
  description = "Nome do cluster GKE"
  value       = google_container_cluster.gke_cluster.name
}

output "default_zone" {
  description = "Zona onde o cluster foi provisionado"
  value       = google_container_cluster.gke_cluster.location
}

output "cluster_endpoint" {
  description = "Endpoint do cluster GKE"
  value       = google_container_cluster.gke_cluster.endpoint
  sensitive   = true
}

output "kubeconfig_path" {
  description = "Caminho para o kubeconfig gerado"
  value       = local_file.kubeconfig.filename
}

output "supermario_ip" {
  description = "IP externo do LoadBalancer do Super Mario"
  value       = try(kubernetes_service.supermario.status[0].load_balancer[0].ingress[0].ip, "pendente — aguarde o LoadBalancer provisionar")
}

resource "local_file" "kubeconfig" {
  filename        = "${path.module}/kubeconfig.yaml"
  file_permission = "0600"

  content = <<-EOT
    apiVersion: v1
    kind: Config
    clusters:
    - name: ${google_container_cluster.gke_cluster.name}
      cluster:
        server: https://${google_container_cluster.gke_cluster.endpoint}
        certificate-authority-data: ${google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate}
    contexts:
    - name: ${google_container_cluster.gke_cluster.name}
      context:
        cluster: ${google_container_cluster.gke_cluster.name}
        user: ${google_container_cluster.gke_cluster.name}
    current-context: ${google_container_cluster.gke_cluster.name}
    users:
    - name: ${google_container_cluster.gke_cluster.name}
      user:
        token: ${data.google_client_config.default.access_token}
  EOT
}
