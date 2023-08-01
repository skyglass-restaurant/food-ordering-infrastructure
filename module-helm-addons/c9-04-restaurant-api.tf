resource "kubernetes_deployment_v1" "restaurant_api_deployment" {
  depends_on = [helm_release.bitnami_kafka_schema_registry, kubernetes_deployment_v1.food_ordering_postgres]  
  metadata {
    name      = "restaurant-api"
    namespace = "default"

    labels = {
      app = "restaurant-api"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "restaurant-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "restaurant-api"
        }
      }

      spec {
        container {
          name  = "restaurant-service"
          image = "ghcr.io/skyglass-restaurant/restaurant-service"
          image_pull_policy = "Always"
          port {
            container_port = 8183
          }             

          env {
            name  = "SPRING_DATASOURCE_URL"
            value = "jdbc:postgresql://food-ordering-postgres:5432/postgres?currentSchema=restaurant&binaryTransfer=true&reWriteBatchedInserts=true&stringtype=unspecified"
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

resource "kubernetes_horizontal_pod_autoscaler_v1" "restaurant_api_hpa" {
  metadata {
    name = "restaurant-api-hpa"
  }
  spec {
    max_replicas = 2
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = kubernetes_deployment_v1.restaurant_api_deployment.metadata[0].name 
    }
    target_cpu_utilization_percentage = 50
  }
}

resource "kubernetes_service_v1" "restaurant_api_service" {
  metadata {
    name = "restaurant-api"
  }
  spec {
    selector = {
      app = "restaurant-api"
    }
    port {
      port = 8183
    }
  }
}