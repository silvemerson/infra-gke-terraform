resource "kubernetes_deployment" "supermario" {
  metadata {
    name = "supermario"
  }

  wait_for_rollout = false

  spec {
    replicas = var.supermario_replicas

    selector {
      match_labels = {
        app = "supermario"
      }
    }

    template {
      metadata {
        labels = {
          app = "supermario"
        }
      }

      spec {
        container {
          name  = "supermario"
          image = "pengbai/docker-supermario"

          port {
            container_port = 8080
          }
        }
      }
    }
  }

  depends_on = [google_container_node_pool.gke_pool]
}

resource "kubernetes_service" "supermario" {
  metadata {
    name = "supermario"
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = "supermario"
    }

    port {
      port        = 80
      target_port = 8080
    }
  }

  depends_on = [google_container_node_pool.gke_pool]
}
