resource "kubernetes_deployment_v1" "customer_api_deployment" {
  depends_on = [helm_release.bitnami_kafka_schema_registry, kubernetes_deployment_v1.food_ordering_postgres]  
  metadata {
    name = "customer-api"

    labels = {
      app = "customer-api"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "customer-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "customer-api"
        }
      }

      spec {
        container {
          name  = "customer-service"
          image = "ghcr.io/skyglass-restaurant/customer-service"
          image_pull_policy = "Always"
          port {
            container_port = 8184
          }             

          env {
            name  = "SPRING_DATASOURCE_URL"
            value = "jdbc:postgresql://food-ordering-postgres:5432/postgres?currentSchema=customer&binaryTransfer=true&reWriteBatchedInserts=true&stringtype=unspecified"
          }

          env {
            name  = "SPRING_DATASOURCE_INITIALIZATION-MODE"
            value = "always"
          }

          env {
            name  = "KAFKA-CONFIG_BOOTSTRAP-SERVERS"
            value = "bitnami-kafka:9092"
          }

          env {
            name  = "KAFKA-CONFIG_SCHEMA-REGISTRY-URL"
            value = "http://schema-registry:8081"
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "1024Mi"
            }

            requests = {
              cpu    = "200m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "customer_api_hpa" {
  metadata {
    name = "customer-api-hpa"
  }
  spec {
    max_replicas = 2
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = kubernetes_deployment_v1.customer_api_deployment.metadata[0].name 
    }
    target_cpu_utilization_percentage = 50
  }
}

resource "kubernetes_service_v1" "customer_api_service" {
  metadata {
    name = "customer-api"
  }
  spec {
    selector = {
      app = "customer-api"
    }
    port {
      port = 8184
    }
  }
}