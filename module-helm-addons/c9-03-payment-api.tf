resource "kubernetes_deployment" "payment_api_deployment" {
  metadata {
    name      = "payment-api"
    namespace = "default"

    labels = {
      app = "payment-api"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "payment-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "payment-api"
        }
      }

      spec {
        container {
          name  = "payment-service"
          image = "ghcr.io/skyglass-restaurant/payment-service:1.0-SNAPSHOT"
          image_pull_policy = "Always"
          port {
            container_port = 8182
          }             

          env {
            name  = "SPRING_DATASOURCE_URL"
            value = "jdbc:postgresql://food-ordering-postgres:5432/postgres?currentSchema=payment&binaryTransfer=true&reWriteBatchedInserts=true&stringtype=unspecified"
          }

          env {
            name  = "SPRING_DATASOURCE_INITIALIZATION-MODE"
            value = "always"
          }

          env {
            name  = "KAFKA-CONFIG_BOOTSTRAP-SERVERS"
            value = "confluent-kafka-cp-kafka-headless:9092"
          }

          env {
            name  = "KAFKA-CONFIG_SCHEMA-REGISTRY-URL"
            value = "http://confluent-kafka-cp-schema-registry:8081"
          }

          resources {
            limits {
              cpu    = "500m"
              memory = "1024Mi"
            }

            requests {
              cpu    = "200m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "payment_api_hpa" {
  metadata {
    name = "payment-api-hpa"
  }
  spec {
    max_replicas = 2
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = kubernetes_deployment_v1.payment_api_deployment.metadata[0].name 
    }
    target_cpu_utilization_percentage = 50
  }
}

resource "kubernetes_service_v1" "payment_api_service" {
  metadata {
    name = "payment-api"
  }
  spec {
    selector = {
      app = "payment-api"
    }
    port {
      port = 8182
    }
  }
}