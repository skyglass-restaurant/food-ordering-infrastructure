resource "kubernetes_deployment" "food_ordering_postgres" {
  metadata {
    name = "food-ordering-postgres"

    labels = {
      db = "food-ordering-postgres"
    }
  }

  spec {
    selector {
      match_labels = {
        db = "food-ordering-postgres"
      }
    }

    template {
      metadata {
        labels = {
          db = "food-ordering-postgres"
        }
      }

      spec {
        container {
          name  = "food-ordering-postgres"
          image = "postgres:14.4"

          env {
            name  = "POSTGRES_PASSWORD"
            value = "admin"
          }

        }
      }
    }
  }
}

resource "kubernetes_service" "food_ordering_postgres" {
  metadata {
    name = "food-ordering-postgres"

    labels = {
      db = "food-ordering-postgres"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      db = "food-ordering-postgres"
    }

    port {
      protocol    = "TCP"
      port        = 5432
      target_port = 5432
    }
  }
}

# Resource: food-ordering Postgres Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v1" "food_ordering_postgres_hpa" {
  metadata {
    name = "food-ordering-postgres-hpa"
  }
  spec {
    max_replicas = 2
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = kubernetes_deployment_v1.food_ordering_postgres_deployment.metadata[0].name 
    }
    target_cpu_utilization_percentage = 60
  }
}