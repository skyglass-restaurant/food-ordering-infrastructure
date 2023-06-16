resource "kubernetes_deployment" "order_api_deployment" {
  metadata {
    name      = "order-api"
    namespace = "default"

    labels = {
      app = "order-api"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "order-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "order-api"
        }
      }

      spec {
        container {
          name  = "order-service"
          image = "ghcr.io/skyglass-restaurant/order-service:1.0-SNAPSHOT"
          image_pull_policy = "Always"
          port {
            container_port = 8181
          }          

          env {
            name  = "SPRING_DATASOURCE_URL"
            value = "jdbc:postgresql://food-ordering-postgres:5432/postgres?currentSchema=order&binaryTransfer=true&reWriteBatchedInserts=true&stringtype=unspecified"
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

resource "kubernetes_horizontal_pod_autoscaler_v1" "order_api_hpa" {
  metadata {
    name = "order-api-hpa"
  }
  spec {
    max_replicas = 2
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = kubernetes_deployment_v1.order_api_deployment.metadata[0].name 
    }
    target_cpu_utilization_percentage = 50
  }
}

resource "kubernetes_service_v1" "order_api_service" {
  metadata {
    name = "order-api"
  }
  spec {
    selector = {
      app = "order-api"
    }
    port {
      port = 8181
    }
  }
}